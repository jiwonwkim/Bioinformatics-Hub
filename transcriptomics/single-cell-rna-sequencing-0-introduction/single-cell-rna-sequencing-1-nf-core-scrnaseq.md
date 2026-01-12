---
icon: dna
---

# Single-cell RNA sequencing #1: nf-core/scrnaseq

We are going to use the **cellranger** pipeline of [**nf-core/scrnaseq**](https://nf-co.re/scrnaseq/4.0.0/) in this example.

{% stepper %}
{% step %}
### Make a project directory & change working directory

```sh
mkdir -p $HOME/projects/scrnaseq/data/fastq
cd $HOME/projects/scrnaseq
```

You should move the raw files into `$HOME/projects/scrnaseq/data` directory. Transfer raw fastq files into the `$HOME/projects/scrnaseq/data/fastq` directory. Click [here](../../handling-files/uploading-raw-data-to-remote-server.md) to see how to upload the raw data.
{% endstep %}

{% step %}
### Cleaning file names

Before starting downstream analyses, you have to make the file names concise. We recommend  using a simple file name format such as `[Group][Replicate #]_R1.fq.gz` and `[Group][Replicate #]_R2.fq.gz`.&#x20;
{% endstep %}

{% step %}
### Creating an Input File for Nextflow

Nextflow uses a **CSV file** (commonly called a _samplesheet_) to specify sample information and locate input files. Below is an example of a samplesheet containing three control and three patient samples:

{% tabs %}
{% tab title="samplesheet.csv" %}
sample,fastq\_1,fastq\_2\
ctrl1,$HOME/projects/scrnaseq/data/ctrl1\_R1.fastq.gz,$HOME/projects/scrnaseq/data/ctrl1\_R2.fastq.gz\
ctrl2,$HOME/projects/scrnaseq/data/ctrl2\_R1.fastq.gz,$HOME/projects/scrnaseq/data/ctrl2\_R2.fastq.gz\
ctrl3,$HOME/projects/scrnaseq/data/ctrl3\_R1.fastq.gz,$HOME/projects/scrnaseq/data/ctrl3\_R2.fastq.gz\
case1,$HOME/projects/scrnaseq/data/case1\_R1.fastq.gz,$HOME/projects/scrnaseq/data/case1\_R2.fastq.gz\
case2,$HOME/projects/scrnaseq/data/case2\_R1.fastq.gz,$HOME/projects/scrnaseq/data/case2\_R2.fastq.gz\
case3,$HOME/projects/scrnaseq/data/case3\_R1.fastq.gz,$HOME/projects/scrnaseq/data/case3\_R2.fastq.gz
{% endtab %}
{% endtabs %}

The samplesheet is a simple spreadsheet where columns are separated by **commas,** or a **CSV file**.

Each column stands for **the names of the samples**, **the path to the first file of paired-end fastq**, and **the path to the second file of paired-end fastq** (you can leave it empty if your data is single-read).

Assuming all your raw data is in the data `data/fastq` directory and had their name has a format of `[[Group][Replicate #]_R1.fastq.gz` or `[Group][Replicate #]_R2.fastq.gz`, you can simply upload this **create\_samplesheet\_scrnaseq.sh** file and run it to create the samplesheet.

&#x20;Upload this file to `$HOME/projects/scrnaseq` directory, and run it with the following code.

{% file src="../../.gitbook/assets/create_samplesheet_scrnaseq (1).sh" %}

```sh
cd $HOME/projects/scrnaseq
## Change the permission to run of the bash script
chmod +x create_samplesheet_scrnaseq.sh
## Run the bash script
bash create_samplesheet_scrnaseq.sh
```
{% endstep %}

{% step %}
### Download nf-core rnaseq pipeline

```sh
export NXF_HOME=$HOME/.nextflow
nextflow pull nf-core/scrnaseq
```
{% endstep %}

{% step %}
### Upload Nextflow configuration file

Configuration file is required to run Nextflow script smoothly. Download the file below and add it to your working directory,  `$HOME/projects/scrnaseq`.

{% file src="../../.gitbook/assets/nextflow (1).config" %}
{% endstep %}

{% step %}
### Run the pipeline

Upload this file to `$HOME/projects/scrnaseq` and submit the job using `qsub`.

{% file src="../../.gitbook/assets/scrnaseq.sh" %}

{% tabs %}
{% tab title="scrnaseq.sh" %}
\#!/bin/bash -l\
\#$ -N scrnaseq\
\#$ -l h\_rt=48:0:0\
\#$ -l mem=6G\
\#$ -pe mpi 12

cd $HOME/projects/scrnaseq

module load python/miniconda3/24.3.0-0\
source $UCL\_CONDA\_PATH/etc/profile.d/conda.sh\
conda activate nextflow\
source \~/.bashrc\
conda config --add channels bioconda

nextflow run nf-core/scrnaseq \\\
-profile singularity \\\
-c nextflow.config \\\
\--input samplesheet.csv \\\
\--outdir result \\\
\--aligner cellranger \\\
\--gtf $HOME/ACFS/ref/GRCm39.chr.gtf \\\
\--fasta $HOME/ACFS/ref/GRCm39.fa&#x20;
{% endtab %}
{% endtabs %}

```sh
## Change the permission
chmod +x scrnaseq.sh
## Submit it as a job to Myriad cluster
qsub scrnaseq.sh
## Check the status of the job
qstat
```

<figure><img src="../../.gitbook/assets/Screenshot 2025-05-16 at 14.23.53.png" alt=""><figcaption></figcaption></figure>
{% endstep %}

{% step %}
### Retrieve gene count results

After the pipeline has finished running, you'll find the unnormalized gene-level read counts in the file: `$HOME/projects/scrnaseq/result/star_salmon/salmon.merged.gene_counts.tsv`.




{% endstep %}
{% endstepper %}



