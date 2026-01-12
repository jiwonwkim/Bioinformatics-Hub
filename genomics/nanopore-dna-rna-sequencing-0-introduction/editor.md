---
icon: dna
---

# Nanopore sequencing #1: nf-core/nanoseq

We are going to use  [**nf-core/nanoseq**](https://nf-co.re/nanoseq/3.1.0/) in this example.

{% stepper %}
{% step %}
### Make a project directory & change working directory

```sh
mkdir -p $HOME/projects/nanoseq/data/fastq
cd $HOME/projects/nanoseq
```

You should move the raw files into `$HOME/projects/nanoseq/data` directory. You can transfer the raw fastq files into `$HOME/projects/nanoseq/data/fastq` directory. Click [here](../../handling-files/uploading-raw-data-to-remote-server.md) to see how to upload the raw data.
{% endstep %}

{% step %}
### Clean file names

Before starting downstream analyses, you have to make the file names concise. We recommend  using a simple file name format such as `[Group][Replicate #].fq.gz`. For example, `Control1.fastq.gz` or `Case1.fastq.gz`.&#x20;
{% endstep %}

{% step %}
### Creating an Input File for Nextflow

Nextflow uses a **CSV file** (commonly called a _samplesheet_) to specify sample information and locate input files. Below is an example of a samplesheet containing three control and three patient samples:

{% tabs %}
{% tab title="samplesheet.csv" %}
group,replicate,barcode,input\_file,fasta,gtf

ctrl,1,,/myriadfs/home/smgxxxx/projects/nanoseq/data/fastq/ctrl1.fastq.gz,/acfs/users/smgxxxx/ref/GRCh38.chr.fa,/acfs/users/smgxxxx/ref/GRCh38.chr.gtf

ctrl,2,,/myriadfs/home/smgxxxx/projects/nanoseq/data/fastq/ctrl2.fastq.gz,/acfs/users/smgxxxx/ref/GRCh38.chr.fa,/acfs/users/smgxxxx/ref/GRCh38.chr.gtf

ctrl,3,,/myriadfs/home/smgxxxx/projects/nanoseq/data/fastq/ctrl3.fastq.gz,/acfs/users/smgxxxx/ref/GRCh38.chr.fa,/acfs/users/smgxxxx/ref/GRCh38.chr.gtf

case,1,,/myriadfs/home/smgxxxx/projects/nanoseq/data/fastq/case1.fastq.gz,/acfs/users/smgxxxx/ref/GRCh38.chr.fa,/acfs/users/smgxxxx/ref/GRCh38.chr.gtf

case,2,,/myriadfs/home/smgxxxx/projects/nanoseq/data/fastq/case2.fastq.gz,/acfs/users/smgxxxx/ref/GRCh38.chr.fa,/acfs/users/smgxxxx/ref/GRCh38.chr.gtf

case,3,,/myriadfs/home/smgxxxx/projects/nanoseq/data/fastq/case3.fastq.gz,/acfs/users/smgxxxx/ref/GRCh38.chr.fa,/acfs/users/smgxxxx/ref/GRCh38.chr.gtf
{% endtab %}
{% endtabs %}

Each column stands for the group name, replicate number, barcode&#x20;

Assuming all your raw data is in the data `data/fastq` directory and had their name has a format of `[[Group][Replicate #].fastq.gz`, you can simply upload this **create\_samplesheet\_nanoseq.sh** file and run it to create the samplesheet.

&#x20;Upload this file to `$HOME/projects/nanoseq` directory, and run it with the following code.

{% file src="../../.gitbook/assets/create_samplesheet_nanoseq.sh" %}

```sh
cd $HOME/projects/nanoseq
## Change the permission to run of the bash script
chmod +x create_samplesheet_nanoseq.sh
## Run the bash script
bash create_samplesheet_nanoseq.sh
```
{% endstep %}

{% step %}
### Download nf-core rnaseq pipeline

```sh
export NXF_HOME=$HOME/.nextflow
nextflow pull nf-core/nanoseq
```
{% endstep %}

{% step %}
### Upload Nextflow configuration file

Configuration file is required to run Nextflow script smoothly. Download the file below and add it to your working directory,  `$HOME/projects/rnaseq`.

{% file src="../../.gitbook/assets/nextflow.config" %}
{% endstep %}

{% step %}
### Run the pipeline

Running the pipeline differs depending on your file type - DNA or RNA.&#x20;

{% tabs %}
{% tab title="DNA" %}
For DNA samples, quantification is not required, as we are not comparing gene expression levels (`--skip_quantification`).&#x20;

```sh
#!/bin/bash -l
#$ -N nanoseq
#$ -pe mpi 12        # CPU 
#$ -l mem=7G         # Memory per core (84GB in total) 
#$ -l h_rt=48:0:0    # Run time limit
#$ -l tmpfs=100G     # Temporary directory size
#$ -wd $HOME/projects/nanoseq    # Working directory

# Change into project directory
cd $HOME/projects/nanoseq

# Load conda and activate nextflow environment
module load python/miniconda3/24.3.0-0
source $UCL_CONDA_PATH/etc/profile.d/conda.sh 
conda activate nextflow
conda config --add channels bioconda

# Run nf-core/nanoseq with DNA protocol
nextflow run nf-core/nanoseq \
    --input samplesheet.csv \
    --protocol DNA \
    --outdir result  \
    --skip_quantification \
    --skip_demultiplexing \
    --skip_qc \
    --call_variants \
    --variant_caller deepvariant \
    -profile singularity \
    -c nextflow.config 
```
{% endtab %}

{% tab title="RNA" %}
For RNA samples, quantification is required, but not variant calling.

```sh
#!/bin/bash -l
#$ -N nanoseq
#$ -pe mpi 12        # CPU 
#$ -l mem=7G         # Memory per core (84GB in total) 
#$ -l h_rt=48:0:0    # Run time limit
#$ -l tmpfs=100G     # Temporary directory size
#$ -wd $HOME/projects/nanoseq    # Working directory

# Change into project directory
cd $HOME/projects/nanoseq

# Load conda and activate nextflow environment
module load python/miniconda3/24.3.0-0
source $UCL_CONDA_PATH/etc/profile.d/conda.sh 
conda activate nextflow
conda config --add channels bioconda

# Run nf-core/nanoseq with cDNA protocol
nextflow run nf-core/nanoseq \
    --input samplesheet.csv \
    --protocol cDNA \
    --outdir result  \
    --skip_demultiplexing \
    --skip_qc \
    -profile singularity \
    -c nextflow.config 
```
{% endtab %}
{% endtabs %}

Upload (or copy & paste)  this file to `$HOME/projects/nanoaseq` and submit the job using `qsub`.

#### For DNA samples:

{% file src="../../.gitbook/assets/nanoseq_dna.sh" %}

#### For RNA samples:

{% file src="../../.gitbook/assets/nanoseq_cdna.sh" %}

```sh
## Change the permission
chmod +x nanoseq_dna.sh
## Submit it as a job to Myriad cluster
qsub nanoseq_dna.sh
## Check the status of the job
qstat
```
{% endstep %}

{% step %}
### Retrieve results

After the pipeline has finished running, you'll find variant calling result in: `$HOME/projects/nanoseq/result/`.


{% endstep %}
{% endstepper %}





<details>

<summary>Running nf-core/nanoseq from aligned BAM file</summary>

You can also run the pipeline with the pre-aligned BAM file. In many cases, **alignment** is the most **time-consuming** and **resource-expensive** process. If you already have BAM file, you can skip alignment for time efficiency.

#### Input file formats

You can start from either **FASTQ (.fastq /.fq)** files or pre-aligned **BAM** files.\
\
You need **two input files** in the **data** directory:

### 1. FASTQ or BAM files

**FASTQ files (.fastq / .fq / .fastq.gz / .fq.gz)** are files that store a DNA/RNA sequence and its quality scores. File extensions that contain **.gz** represents the gzip compressed files.

**BAM files (.bam)** are the compressed binary version of **SAM files (.sam)** that represent the aligned sequences. SAM files are human-readable unlike BAM files. You can use the command `samtools view file.bam` if you wish to know the content of BAM files. You have one BAM file per sample.

* [x] Put ALL of your BAM files into **data/bam** directory

```sh
mkdir -p projects/nanoseq/data/fastq  // make the project directory and data subdirectory
cd projects/nanoseq    // change directory into the project directory, all of the analysis will be done in this directory
mv <bam file directory>/*.bam* data/bam // move the files from where they were to the data directory
```

### 2. CSV file

You now need a **CSV file**, Comma-Separated Values, which lists your input files.

* [x] Make the CSV file

```sh
touch samplesheet.csv
nano samplesheet.csv
```

The header of this file is:

```
group,replicate,barcode,input_file,fasta,gtf
```

* group: patient/control
* replicate: number your samples (i.e. 1, 2, ...)
* barcode: unique ID for your samples (i.e. patient1)
* input\_file: full path of your input file
* fasta: reference fasta to which sequences are aligned
* gtf: annotation (optional)

For example, your samplesheet.csv file will look like:

```
group,replicate,barcode,input_file,fasta,gtf
AMD,1,AMD_P1,/project/AMD/data/AMD_P1.bam,hg38,
AMD,2,AMD_P2,/project/AMD/data/AMD_P2.bam,hg38,
Control,1,AMD_C1,/project/AMD/data/AMD_C1.bam,hg38,
Control,2,AMD_C2,/project/AMD/data/AMD_C2.bam,hg38,
```

You can specify FASTQ files in the input\_file column if your sequenced data aren't aligned yet.

```
group,replicate,barcode,input\_file,fasta,gtf AMD,1,AMD\_P1,/project/AMD/data/AMD\_P1.fastq,hg38,
```

Note that the last value is left empty as it is optional.

## Running nanoseq

Because we have BAM files, we are going to start the pipeline from samtools command. To do this, we need to provide two parameters: `--skip_demultiplexing` and `--skip_alignment`

* [x] Run the nanoseq If you are using **BAM** files, as it is already aligned, you can skip alignment.

```sh
nextflow run nf-core/nanoseq \  // run nanoseq
    --input samplesheet.csv \   // provide the CSV file you created above
    --protocol cDNA \           // RNA
    --outdir result
    -profile conda
    -c resourceLimits.config
    -with-tower
    --skip_demultiplexing
    --skip_nanoplot
    --skip_fastqc
    --skip_fusion_analysis
    --skip_alignment
```

However, if you are using **FASTQ** files, you can't skip the alignment.

```sh
nextflow run nf-core/nanoseq \  // run nanoseq
    --input samplesheet.csv \   // provide the CSV file you created above
    --protocol cDNA \           // RNA
    --outdir result
    -profile conda
    -c resourceLimits.config
    -with-tower
    --skip_demultiplexing
    --skip_nanoplot
    --skip_fastqc
    --skip_fusion_analysis
```

Once you're done with the run, you'll see the results in `result` directory.

</details>

