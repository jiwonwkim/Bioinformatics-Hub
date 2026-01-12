---
icon: folder-arrow-down
---

# Downloading public sequence data from NCBI SRA

## NCBI SRA (Sequence Read Archive) [🔗](https://www.ncbi.nlm.nih.gov/sra)

**SRA** is one of the largest public repositories for raw sequencing data.

## Step 1: Find the data

Search for your study of interest (e.g., organism name, study accession, BioProject, BioSample, etc.). Each entry will have an **SRA accession number**:

* Starts with **SRP** (project), **SRX** (experiment), **SRS** (sample), or **SRR** (run).

Once you find the **SRP accession number** for the project you are interested in, you can use SRA Run selector to get metadata and download the sequence data.&#x20;

<figure><img src="../.gitbook/assets/Screenshot 2025-06-11 at 12.13.54 (2).png" alt=""><figcaption></figcaption></figure>

Look up for the project on SRA, and select all the samples you are interested in.&#x20;

<figure><img src="../.gitbook/assets/Screenshot 2025-06-11 at 12.14.03.png" alt=""><figcaption></figcaption></figure>

Click **Send to:** on the bottom left, select **Run Selector** and click **Go**.

<figure><img src="../.gitbook/assets/Screenshot 2025-06-11 at 12.15.02.png" alt=""><figcaption></figcaption></figure>

Click **Metadata** to retreive metadata of each run in one file.&#x20;

<figure><img src="../.gitbook/assets/Screenshot 2025-06-11 at 12.16.01.png" alt=""><figcaption><p>Example metadata</p></figcaption></figure>

## Step 2: Download data

### Option A. Web download (small datasets)

* Click on the SRR accession.
* Use the "Download" button.
* **Not suitable for large files** (>50Mb).

### Option B. Use `sra-tools` (recommended for large datasets)

{% stepper %}
{% step %}
### Install sra-tools

```sh
conda install -c bioconda sra-tools
```
{% endstep %}

{% step %}
### Use prefetch to download .sra files

```sh
## Make a directory for .sra files
mkdir -p data/sra
## Download .sra files
prefetch -O data/sra [SRRXXXXXXX]
```

This will download the `.sra` file for the seqeuncing run SRRXXXXXXX into `data/sra` directory.&#x20;
{% endstep %}

{% step %}
### Use fasterq-dump to convert .sra files to FASTQ

{% hint style="info" %}
If you see `.sralite` instead of `.sra` files, see **sra-toolkit configuration** below.
{% endhint %}

```sh
## Convert .sra files into .fastq files, and split forward and reverse reads
fasterq-dump data/sra/[SRRXXXXXXX] --split-files --threads 4 -O data/fastq
```
{% endstep %}

{% step %}
### Compress fastq files

FASTQ files usually take up a lot of disk space in your server. To reduce the file size and file read-in duration, compressing the files is highly recommended.

```sh
## Load samtools to use bgzip
module load samtools
## Compress all the fastq files in data/fastq directory
bgzip data/fastq/SRR*.fastq
```
{% endstep %}
{% endstepper %}

<details>

<summary>sra-toolkit configuration</summary>

If you used prefetch to download SRA data and got `.sralite` files, you may want to change this setting with `vdb-config` command.

```sh
vdb-config -i
```

<figure><img src="../.gitbook/assets/Screenshot 2025-06-11 at 15.52.18.png" alt=""><figcaption></figcaption></figure>

You now will see this screen. It's not a blue screen, there's nothing to worry about. To disable the SRA Lite preference, type **capital Q** on your keyboard.

<figure><img src="../.gitbook/assets/Screenshot 2025-06-11 at 15.54.04.png" alt=""><figcaption></figcaption></figure>

Now that the SRA Lite preference is disabled, you can save and exit the configuration screen. Type **small s** to save the setting, **small o** for ok, and **small x** to exit the screen.

<figure><img src="../.gitbook/assets/Screenshot 2025-06-11 at 15.56.08.png" alt=""><figcaption></figcaption></figure>

Now try prefetching the SRA dataset, you'll get `.sra` files instead of `.sralite` files.&#x20;

</details>



Your `.fastq.gz` files should be ready.  You can check the list of files using `ls` .

```sh
ll data/fastq
```
