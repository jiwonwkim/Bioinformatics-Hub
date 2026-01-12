---
icon: dna
---

# Oxford Nanopore methylation calls #1: nf-core/methylong

To analyze ONT methylation calls, we are going to use [nf-core/methylong](https://nf-co.re/methylong/1.0.0/) pipeline.

{% stepper %}
{% step %}
### Make a project directory & change working directory

```sh
mkdir -p $HOME/projects/methylong/data/ubam
cd $HOME/projects/methylong
```

You should move the raw files into `$HOME/projects/methylong/data/ubam` directory. Transfer uBAM files into the `$HOME/projects/methylong/data/ubam` directory. Click [here](../../handling-files/uploading-raw-data-to-remote-server.md) to see how to upload the raw data.
{% endstep %}

{% step %}
### Clean file names

Before starting downstream analyses, you have to make the file names concise. We recommend using a simple file name format such as `[Sample group][Replicate number].bam`. In this example, we are going to use `AMD1.bam` for an age-related macular degeneration (AMD) sample, and `DR1.bam` for a diabetic retinopathy (DR) sample. You can also add `control1.bam` for healthy control sample if you have one.
{% endstep %}

{% step %}
### Create an Input File for Nextflow <a href="#creating-an-input-file-for-nextflow" id="creating-an-input-file-for-nextflow"></a>

Nextflow uses a **CSV file** (commonly called a _samplesheet_) to specify sample information and locate input files. Below is an example of a samplesheet containing two ONT samples:

{% tabs %}
{% tab title="samplesheet.csv" %}
sample,modbam,ref,method

AMD1,/home/smgxxxx/projects/methylong/data/ubam/AMD1.bam,/home/smgxxxx/ACFS/ref/GRCh38.fa,ont

DR1,/home/smgxxxx/projects/methylong/data/ubam/DR1.bam,/home/smgxxxx/ACFS/ref/GRCh38.fa,ont
{% endtab %}
{% endtabs %}

Each column stands for **the names of the samples**, **the path to the ubam (or modbam)**, **the path to the reference genome**, and **the platform**. Keep in mind that you have to provide a **full path (or an absolute path)** of files in the samplesheet. The sequencing platform must be specified in the samplesheet; it can either be `ont` for Oxford Nanopore Technology or `pacbio` for Pacific Biosciences.
{% endstep %}

{% step %}
### Download nf-core methylong pipeline

```sh
export NXF_HOME=$HOME/.nextflow
nextflow pull nf-core/methylong
```
{% endstep %}

{% step %}
### Upload Nextflow configuration file

Configuration file is required to run Nextflow script smoothly. Download the file below and add it to your working directory, `$HOME/projects/methylong`.

{% file src="../../.gitbook/assets/nextflow (3).config" %}
{% endstep %}

{% step %}
### Run the pipeline

Upload the jobscript file to `$HOME/projects/methylong` and submit the job using `qsub`.

{% file src="../../.gitbook/assets/methylong.sh" %}

```sh
## Change the permission
chmod +x methylong.sh
## Submit it as a job to Myriad cluster
qsub methylong.sh
## Check the status of the job
qstat
```
{% endstep %}

{% step %}
### Retrieve methylation result

You can find your result in `result/ont/[Sample]/pileup/[Sample].bed.gz`.

```sh
sample="AMD1"
# Check your file (Sample AMD1 in this example, do for all of your samples)
zcat result/ont/${sample}/pileup/${sample}.bed.gz | less
```
{% endstep %}
{% endstepper %}

