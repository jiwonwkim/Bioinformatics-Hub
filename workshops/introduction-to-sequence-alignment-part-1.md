---
description: Jul 2026
hidden: true
icon: '2'
---

# Introduction to sequence alignment: Part 1

Welcome to the Bioinformatics Hub workshop! Today, we are going to learn how to align raw RNA sequences for quantification.&#x20;

## Required files

Before we begin, we have to download some (or a lot of) files.

Let's start by downloading the files we need.

#### Paired-end raw sequences (FASTQ)

<details>

<summary>Raw sequences (FASTQ)</summary>

#### Treated samples

Treated1

{% file src="../.gitbook/assets/SRR21709659_1.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709659_2.subset.fastq.gz" %}

Treated2

{% file src="../.gitbook/assets/SRR21709661_1.subset.fastq (2).gz" %}

{% file src="../.gitbook/assets/SRR21709661_2.subset.fastq (2).gz" %}

Treated3

{% file src="../.gitbook/assets/SRR21709662_1.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709662_2.subset.fastq.gz" %}

#### Control samples

Control1

{% file src="../.gitbook/assets/SRR21709664_1.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709664_2.subset.fastq.gz" %}

Control2

{% file src="../.gitbook/assets/SRR21709665_1.subset.fastq (1).gz" %}

{% file src="../.gitbook/assets/SRR21709665_2.subset.fastq (1).gz" %}

Control3

{% file src="../.gitbook/assets/SRR21709666_1.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709666_2.subset.fastq.gz" %}

</details>

#### Metadata (CSV)

{% file src="../.gitbook/assets/SraRunTable (2).csv" %}

We also need reference genome for alignment and gene annotation for gene expression quantification. We will download it directly to the google colab during the tutorial.



## Software used

* HISAT2 (alignment)
* SAMtools (BAM processing)
* featureCounts (gene quantification)
* DESeq2 (differential expression)
* EnhancedVolcano (visualisation)
* ggplot2 / patchwork (plotting)



## What is sequence alignment?

When we sequence RNA, the base

{% embed url="https://www.mdpi.com/2218-273X/12/11/1693" %}



## Workflow

Let's open a new document on Google Colab and begin.

<figure><img src="../.gitbook/assets/Screenshot 2026-06-23 at 15.51.09.png" alt=""><figcaption></figcaption></figure>

Click **New notebook in Drive**.

<figure><img src="../.gitbook/assets/image (65).png" alt=""><figcaption></figcaption></figure>

In the notebook, you will see a cell. A cell can be two different types: code or text. Code cells contain code and will allow you to run the code within the cell. Text cells contain plain texts such as titles of the sections or descriptions.

#### 1. Create the project directory structure and prepare a location for FASTQ files. Upload sequencing files and metadata before continuing.

Let's start by creating a dedicated directory (folder) for the project. I will call it `alignment` and also created the nested `/home/projects/alignment/data/fastq` directory. Everything we need today will go into this `alignment` directory - from input fastq files to output volcano plots.

```bash
%%bash
# 1-1. Make a project directory called "alignment" under /home
mkdir -p /home/projects/alignment/data/fastq
```

We we created the project directory `/home/projects/alignment/` and the nested data directory `home/projects/alignment/data/fastq/`. We are going to upload all the `fastq.gz` files and `SraRunTable.csv`  to `home/projects/alignment/data/fastq/`.

<figure><img src="../.gitbook/assets/image (67).png" alt=""><figcaption></figcaption></figure>

Drag the files from your computer

You should see all the files under `home/projects/alignment/data/fastq/`.



#### 2. Install the command-line tools required for alignment, BAM processing, and gene counting.

```bash
%%bash
# 2-1. Update available packages list
apt-get update

# 2-2. Install required packages for alignment and quantification
## hisat2: aligner
## samtools: BAM handling
## subread: quantifier
apt-get install -y hisat2 samtools subread
```



#### 3. Download the human GRCh38 HISAT2 index and GENCODE gene annotation file used later for alignment and quantification.

```bash
%%bash
# 3-1. Make a directory to store references under /home
mkdir -p /home/reference
cd /home/reference/

# 3-2. Download reference genome for hisat2
wget https://genome-idx.s3.amazonaws.com/hisat/grch38_genome.tar.gz
tar -xzf grch38_genome.tar.gz

# 3-3. Download gene annotation for quantification
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_50/gencode.v50.basic.annotation.gtf.gz
```



#### 4. Align paired-end RNA-seq reads against the human genome using HISAT2 and generate BAM files for each sample.

```bash
%%bash
# 4-1. Change current directory into the "alignment" directory
cd /home/projects/alignment/

# 4-2. Make a directory for alignment files (BAM) under data directory
mkdir -p /home/projects/alignment/data/bam

# 4-3. For all the samples, run alignment (takes about 20 mins)
while read SRR; do
echo "Aligning "${SRR}"..."
hisat2 \
  -x /home/reference/grch38/genome \
  -1 /home/projects/alignment/data/fastq/${SRR}_1.subset.fastq.gz \
  -2 /home/projects/alignment/data/fastq/${SRR}_2.subset.fastq.gz \
  -p 8 \
  | samtools sort -o /home/projects/alignment/data/bam/${SRR}.bam

# 4-4. Index the bam file
samtools index /home/projects/alignment/data/bam/${SRR}.bam

done < <(cut -d"," -f1 data/fastq/SraRunTable.csv)

# 4-5. Check if you have 6 bam files (1 per sample)
ls /home/projects/alignment/data/bam

# 4-6. Check the bam files
samtools view /home/projects/alignment/data/bam/${SRR}.bam | tail
```



#### 5. Count reads overlapping genes using featureCounts and create a merged count matrix across all samples.

```bash
%%bash
# 5-1. Make a directory for merged gene counts file
mkdir -p /home/projects/alignment/result/featureCounts/

# 5-2. Use the bam files to quantify gene expression levels
featureCounts \
  -T 4 \
  -p \
  -g gene_name \
  -a /home/reference/gencode.v50.basic.annotation.gtf.gz \
  -o /home/projects/alignment/result/featureCounts/merged_counts.txt \
  /home/projects/alignment/data/bam/*.bam

```







