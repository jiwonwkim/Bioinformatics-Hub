---
icon: dna
---

# Nanopore sequencing #2: Structural variant calling

To call structural variants, we are going to use `Sniffles` and `AnnotSV` to annotate them.

`Sniffles` is optimized for long-read sequencing. For short-read data like Illumina, [Manta](../markdown/short-read-dna-sequencing-2-structural-variant-calling.md) is recommended.



### Sniffles

First, let's start by creating an environment for `Sniffles`.

```shellscript
cd projects/nanoseq
mkdir -p result/sniffles

conda create -n sniffles -c bioconda -c conda-forge \
    sniffles=2.3.3 \
    samtools=1.19 \
    minimap2=2.26 \
    -y

conda activate sniffles
```



### Submit a Sniffles job

`sniffles.sh`

```bash
#!/bin/bash -l
#$ -N sniffles
#$ -l h_rt=48:0:0
#$ -l mem=4G
#$ -l tmpfs=100G
#$ -pe mpi 12
#$ -t 1-6
#$ -cwd
#$ -V

set -e  # Exit on error

# =============================================================================
# Step 1: Activate conda environment
# =============================================================================
echo "Activating environment..."
conda activate sniffles
module load samtools


# =============================================================================
# Step 2: Define variables
# =============================================================================

# Input/Output paths
REFERENCE="/acfs/users/smgxxxx/ref/GRCh38.chr.fa"
SAMPLE_GROUP=$(awk -v n=$SGE_TASK_ID 'BEGIN{FS=","}(NR==n+1){print $1}' samplesheet.csv)
SAMPLE_REP=$(awk -v n=$SGE_TASK_ID 'BEGIN{FS=","}(NR==n+1){print $2}' samplesheet.csv)
SAMPLE_NAME=${SAMPLE_GROUP}"_R"${SAMPLE_REP}
INPUT_BAM="result/minimap2/"${SAMPLE_NAME}".sorted.bam"
OUTPUT_DIR="result/sniffles/"

# Sniffles parameters
MIN_SUPPORT=3           # Minimum read support for SV
MIN_SV_LENGTH=50       # Minimum SV length
THREADS=12              # Number of threads

# Make output directory
mkdir -p ${outdir}    

# =============================================================================
# Step 3: Index BAM file (if not already indexed)
# =============================================================================

echo "Checking BAM index..."
if [ ! -f "${INPUT_BAM}.bai" ]; then
    echo "Indexing BAM file..."
    samtools index -@ ${THREADS} ${INPUT_BAM}
else
    echo "BAM index already exists."
fi


# =============================================================================
# Step 4: Run Sniffles for SV calling
# =============================================================================

echo "Running Sniffles2 for structural variant calling..."

sniffles \
    --input ${INPUT_BAM} \
    --vcf ${OUTPUT_DIR}/${SAMPLE_NAME}.sniffles.vcf \
    --snf ${OUTPUT_DIR}/${SAMPLE_NAME}.snf \
    --threads ${THREADS} \
    --minsvlen ${MIN_SV_LENGTH} \
    --minsupport ${MIN_SUPPORT} \
    --cluster \
    --non-germline \
    --reference ${REFERENCE} 
    
    
# =============================================================================
# Step 5: Compress and index VCF
# =============================================================================

echo "Compressing and indexing VCF..."
bgzip -c ${OUTPUT_DIR}/${SAMPLE_NAME}.sniffles.vcf > ${OUTPUT_DIR}/${SAMPLE_NAME}.sniffles.vcf.gz
tabix -p vcf ${OUTPUT_DIR}/${SAMPLE_NAME}.sniffles.vcf.gz




# =============================================================================
# Step 6: Generate basic statistics
# =============================================================================

echo "Generating SV statistics..."
echo "Total SVs called:" > ${OUTPUT_DIR}/${SAMPLE_NAME}.stats.txt
grep -v "^#" ${OUTPUT_DIR}/${SAMPLE_NAME}.sniffles.vcf | wc -l >> ${OUTPUT_DIR}/${SAMPLE_NAME}.stats.txt

echo ""
echo "SV types breakdown:" >> ${OUTPUT_DIR}/${SAMPLE_NAME}.stats.txt
grep -v "^#" ${OUTPUT_DIR}/${SAMPLE_NAME}.sniffles.vcf | \
    grep -oP 'SVTYPE=[^;]+' | sort | uniq -c >> ${OUTPUT_DIR}/${SAMPLE_NAME}.stats.txt

cat ${OUTPUT_DIR}/${SAMPLE_NAME}.stats.txt


echo "Pipeline successfully ended."


```

```bash
qsub sniffles.sh
```

```
Your job 54321 ("sniffles") has been submitted
```

Once the job is complete, you will see some `.vcf` and `.snf` files in `result/sniffles` directory.

```
$ ll result/sniffles/
total 172M
drwxr-xr-x 4 smgxxxx smgxxx 4.0K Dec 19 11:22 ..
drwxr-xr-x 2 smgxxxx smgxxx 4.0K Dec 18 18:08 .
-rw-r--r-- 1 smgxxxx smgxxx  139 Dec 18 16:26 ctrl_R1.stats.txt
-rw-r--r-- 1 smgxxxx smgxxx 175K Dec 18 16:26 case_R1.sniffles.vcf.gz.tbi
-rw-r--r-- 1 smgxxxx smgxxx 2.3M Dec 18 16:26 case_R1.sniffles.vcf.gz
-rw-r--r-- 1 smgxxxx smgxxx  12M Dec 18 16:26 case_R1.sniffles.vcf
-rw-r--r-- 1 smgxxxx smgxxx  60M Dec 18 16:26 case_R1.snf
-rw-r--r-- 1 smgxxxx smgxxx  139 Dec 18 16:19 ctrl_R1.stats.txt
-rw-r--r-- 1 smgxxxx smgxxx 183K Dec 18 16:19 ctrl_R1.sniffles.vcf.gz.tbi
-rw-r--r-- 1 smgxxxx smgxxx 2.7M Dec 18 16:19 ctrl_R1.sniffles.vcf.gz
-rw-r--r-- 1 smgxxxx smgxxx  14M Dec 18 16:19 ctrl_R1.sniffles.vcf
-rw-r--r-- 1 smgxxxx smgxxx  67M Dec 18 16:19 ctrl_R1.snf
...
```



You'll see all the samples having five files as a set: `.stats.txt`, `.vcf`, `.vcf.gz`, `.vcf.gz.tbi`, and `.snf`. We are going to merge all `.vcf` files into one file for multi-sample calling.

```bash
module load bcftools
vcfs=$(ls result/sniffles/*.vcf.gz)
bcftools merge ${vcfs} -o result/sniffles/combined.vcf
```

#### Multi-sample calling

Submit a multi-sample calling job.

`sniffles_multi.sh`

```bash
#!/bin/bash -l
#$ -N sniffles_multi
#$ -l h_rt=48:0:0
#$ -l mem=4G
#$ -l tmpfs=100G
#$ -pe mpi 12
#$ -cwd
#$ -V

set -e  # Exit on error

# =============================================================================
# Step 1: Activate conda environment
# =============================================================================
echo "Activating environment..."
conda activate sniffles
module load samtools

# =============================================================================
# Step 2: Define variables
# =============================================================================

# Input/Output paths
REFERENCE="/acfs/users/smgxxxx/ref/GRCh38.chr.fa"
OUTPUT_DIR="result/sniffles/"

# Sniffles parameters
MIN_SUPPORT=3           # Minimum read support for SV
MIN_SV_LENGTH=50       # Minimum SV length
THREADS=12              # Number of threads


# =============================================================================
# Step 3: Multi-sample calling
# =============================================================================
# Step 3-1: Generate .snf files for each sample (done above)
# Step 3-2: Create a snf list
realpath  result/sniffles/*.snf > snf_list.txt

# Step 3-3: Multi-sample calling
sniffles \
     --input sample_list.tsv \
     --vcf ${OUTPUT_DIR}combined.vcf \
     --threads ${THREADS} \
     --minsvlen ${MIN_SV_LENGTH} \
     --minsupport ${MIN_SUPPORT}
```

Now that the multi-sample calling is done, we can proceed to `AnnotSV`.



### AnnotSV

If you have never set up AnnotSV, please refer to [here](../markdown/short-read-dna-sequencing-2-structural-variant-calling.md#annotsv) and set the database up.

```bash
mkdir result/AnnotSV

fp1="result/sniffles/combined.vcf"
anno="/myriadfs/home/smgxxxx/database/AnnotSV_annotations/"
of1="result/AnnotSV/combined.AnnotSV.tsv"
AnnotSV \
  -SVinputFile ${fp1} \
  -SVinputInfo 1 \
  -genomeBuild GRCh38 \
  -annotationsDir ${anno} \
  -outputFile ${of1}
```

You will now be able to see the annotated structural variants in `result/AnnotSV/combined.AnnotSV.tsv`.
