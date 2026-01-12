---
icon: dna
---

# Short-read DNA sequencing #2: Structural variant calling

To call structural variants, we are going to use `Manta` and `AnnotSV` to annotate them.

`Manta` is optimized for short-read sequencing. For long-read data, such as Oxford Nanopore or PacBio, [Sniffles](../nanopore-dna-rna-sequencing-0-introduction/editor-1.md) is recommended.



## Manta

### Set the environment

Let's start by creating Conda environment for Manta.

```bash
conda create env -n manta manta
conda activate manta
```

Once the environment is activated, create a subdirectory for Manta results.

```bash
cd $HOME/projects/sarek
mkdir -p result/manta
```

### Configure Manta

List all the BAM/CRAM files you created from the previous step to configure Manta. Make sure you use the same reference genome as `sarek`.

```shellscript
configManta.py \
    --bam result/preprocessing/recalibrated/DR1/DR1.recal.cram \
    --bam result/preprocessing/recalibrated/DR2/DR2.recal.cram \
    --bam result/preprocessing/recalibrated/DR3/DR3.recal.cram \
    --bam result/preprocessing/recalibrated/DR4/DR4.recal.cram \
    --bam result/preprocessing/recalibrated/DR5/DR5.recal.cram \
    --referenceFasta /acfs/users/sejjimf/ref/GRCh38.chr.fa \
    --runDir result/manta
```

Once the run is complete, you'll see a notification like this:

```
Successfully created workflow run script.
To execute the workflow, run the following script and set appropriate options:

/myriadfs/home/smgxxxx/projects/sarek/result/manta/runWorkflow.py
```

Because the python script doesn't work with Python 3, we are going to create a jobscript that specifies Python2.

### Submit a Manta job

Save the following script to `manta.sh`.

```shellscript
#!/bin/bash -l
#$ -N manta
#$ -l h_rt=48:0:0
#$ -l mem=4G
#$ -l tmpfs=100G
#$ -pe mpi 36
#$ -cwd
#$ -V

conda activate manta

python2 result/manta/runWorkflow.py
```

```shellscript
qsub manta.sh
```

```
Your job 12345 ("manta") has been submitted
```

Once the job is successfully run, you will see the results in `result/manta/results/variants/` directory. You want to focus on `diploidSV.vcf.gz`.

```
$ ll result/manta/results/variants/
total 51M
drwxr-xr-x 2 smgxxxx smgxxx 4.0K Dec 16 15:45 .
-rw-r--r-- 1 smgxxxx smgxxx 986K Dec 16 10:33 candidateSmallIndels.vcf.gz.tbi
-rw-r--r-- 1 smgxxxx smgxxx 6.1M Dec 16 10:33 candidateSmallIndels.vcf.gz
-rw-r--r-- 1 smgxxxx smgxxx 754K Dec 16 10:33 candidateSV.vcf.gz.tbi
-rw-r--r-- 1 smgxxxx smgxxx 9.6M Dec 16 10:33 candidateSV.vcf.gz
-rw-r--r-- 1 smgxxxx smgxxx 176K Dec 16 10:33 diploidSV.vcf.gz.tbi
-rw-r--r-- 1 smgxxxx smgxxx 4.3M Dec 16 10:33 diploidSV.vcf.gz
drwxr-xr-x 5 smgxxxx smgxxx 4.0K Dec 14 22:15 ..

```

You can check how many structural variants were called using and which types they are using the following commands:

```
$ bcftools view result/manta/results/variants/diploidSV.vcf.gz -H -f PASS | wc -l
23187

$ bcftools query -f '%SVTYPE\\n' result/manta/results/variants/diploidSV.vcf.gz | sort | uniq -c
   6168 BND
  11626 DEL
   1756 DUP
   6236 INS
```

This file includes 6,168 breakends, 11,626 deletions, 1,756 duplications, and 6,236 insertions.&#x20;



## AnnotSV

Now let's annotate these variants to investigate them deeper.

Before we start, we need a Conda environment for `AnnotSV`.

```bash
conda create -n annotsv -c bioconda -c conda-forge annotsv -y
conda activate annotsv
```

### Download annotation

Now we are going to download annotation data into `$HOME/database` directory.

```bash
mkdir -p ~/database ## Create one if not pre-existing
cd ~/database
mkdir AnnotSV_annotations
cd AnnotSV_annotations

if [ $# -lt 1 ]; then
    echo "Cloning AnnotSV (latest version)"
    git clone <https://github.com/lgmgeo/AnnotSV.git>
else
    TAG=$1
    echo "Cloning AnnotSV (version $TAG)"
    git clone --branch "$TAG" <https://github.com/lgmgeo/AnnotSV.git>
fi

cd AnnotSV
make PREFIX=. install
make PREFIX=. install-human-annotation
mv share/AnnotSV/Annotations_Exomiser ..
mv share/AnnotSV/Annotations_Human ..
cd ..
rm -r AnnotSV
```

### Prepare input VCF

As `Manta` doesn't allow gzipped VCF file as input, we need to decompress the file.

```shellscript
gunzip -c result/manta/results/variants/diploidSV.vcf.gz > result/manta/results/variants/diploidSV.vcf
```

Also, we are going to filter the variants that has PASS filter.

```shellscript
bcftools view -f PASS result/manta/results/variants/diploidSV.vcf > result/manta/results/variants/diploidSV.PASS.vcf
```



### Run AnnotSV

```shellscript
# mkdir -p result/AnnotSV

fp1="result/manta/results/variants/diploidSV.PASS.vcf"
anno="/myriadfs/home/smgxxx/database/AnnotSV_annotations/"
of1="result/AnnotSV/diploidSV.PASS.AnnotSV.tsv"

AnnotSV \
  -SVinputFile ${fp1} \
  -SVinputInfo 1 \
  -genomeBuild GRCh38 \
  -annotationsDir ${anno} \
  -outputFile ${of1}
```

Once the run is over, open the `result/AnnotSV/diploidSV.PASS.AnnotSV.tsv` file and filter the variants out with ACMG\_class of 4 (likely pathogenic) or 5 (pathogenic), and check Samples\_ID columns to see which samples have the variant.

