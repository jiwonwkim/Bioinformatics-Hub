---
icon: dna
---

# Short-read DNA sequencing #1: nf-core/sarek



{% stepper %}
{% step %}
### Make a project directory & change working directory

```sh
mkdir -p $HOME/projects/sarek/data/fastq
cd $HOME/projects/sarek
```

You should move the raw files into `$HOME/projects/sarek/data` directory. Transfer raw fastq files into the `$HOME/projects/sarek/data/fastq` directory. Click [here](../../handling-files/uploading-raw-data-to-remote-server.md) to see how to upload the raw data.
{% endstep %}

{% step %}
### Creating an Input File for Nextflow

Nextflow uses a **CSV file** (commonly called a _samplesheet_) to specify sample information and locate input files. Below is an example of a samplesheet containing five samples:

{% tabs %}
{% tab title="samplesheet.csv" %}
patient,sample,lane,fastq\_1,fastq\_2

DR1,DR1,1,$HOME/projects/sarek/data/fastq/SRR6701351\_1.fastq.gz,$HOME/projects/sarek/data/fastq/SRR6701351\_2.fastq.gz

DR2,DR2,1,$HOME/projects/sarek/data/fastq/SRR6701353\_1.fastq.gz,$HOME/projects/sarek/data/fastq/SRR6701353\_2.fastq.gz

DR3,DR3,1,$HOME/projects/sarek/data/fastq/SRR6701356\_1.fastq.gz,$HOME/projects/sarek/data/fastq/SRR6701356\_2.fastq.gz

DR4,DR4,1,$HOME/projects/sarek/data/fastq/SRR6701363\_1.fastq.gz,$HOME/projects/sarek/data/fastq/SRR6701363\_2.fastq.gz

DR5,DR5,1,$HOME/projects/sarek/data/fastq/SRR6701368\_1.fastq.gz,$HOME/projects/sarek/data/fastq/SRR6701368\_2.fastq.gz
{% endtab %}
{% endtabs %}

The samplesheet is a simple spreadsheet where columns are separated by **commas,** or a **CSV file**.

Each column stands for **the IDs of the patients**, **the IDs of the samples, lane (always 1 if the sequences are not multiplexed), path to the first file of paired-end fastq**, and **the path to the second file of paired-end fastq** (you can leave it empty if your data is single-read).
{% endstep %}

{% step %}
### Download nf-core sarek pipeline

```sh
export NXF_HOME=$HOME/.nextflow
nextflow pull nf-core/sarek
```
{% endstep %}

{% step %}
### Upload Nextflow configuration file

Configuration file is required to run Nextflow script smoothly. Download the file below and add it to your working directory,  `$HOME/projects/sarek`.

{% file src="../../.gitbook/assets/nextflow (2).config" %}
{% endstep %}

{% step %}
### Run the pipeline

Upload this .sh file to `$HOME/projects/sarek` and submit the job using `qsub`.

{% file src="../../.gitbook/assets/sarek.sh" %}

{% tabs %}
{% tab title="sarek.sh" %}
\#!/bin/bash -l\
\#$ -N sarek\
\#$ -l h\_rt=48:0:0\
\#$ -l mem=6G\
\#$ -pe mpi 12

cd $HOME/projects/sarek

module load python/miniconda3/24.3.0-0\
source $UCL\_CONDA\_PATH/etc/profile.d/conda.sh

\
conda activate nextflow\
conda config --add channels bioconda

nextflow run nf-core/sarek \\\
-profile singularity \\\
-c nextflow.config \\\
\--input samplesheet.csv \\\
\--outdir result \\\
\--gtf $HOME/ACFS/ref/GRCh38.chr.gtf \\\
\--fasta $HOME/ACFS/ref/GRCh38.chr.fa&#x20;
{% endtab %}
{% endtabs %}

```sh
## Change the permission
chmod +x sarek.sh
## Submit it as a job to Myriad cluster
qsub sarek.sh
## Check the status of the job
qstat
```

<figure><img src="../../.gitbook/assets/Screenshot 2025-10-03 at 12.22.09 (2).png" alt=""><figcaption></figcaption></figure>


{% endstep %}

{% step %}
### Retrieve variant calling results

<figure><img src="../../.gitbook/assets/image (31).png" alt=""><figcaption></figcaption></figure>

After the pipeline has finished running, you'll find the called variants in the file: `$HOME/projects/sarek/result/variant_calling/strelka/DR1/DR1.strelka.variants.vcf.gz`.&#x20;


{% endstep %}
{% endstepper %}
