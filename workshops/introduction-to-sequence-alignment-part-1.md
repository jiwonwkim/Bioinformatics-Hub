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

We we created the project directory `/home/projects/alignment/` and the nested data directory `home/projects/alignment/data/fastq/`.&#x20;

We are going to download all the `fastq.gz` files and `SraRunTable.csv`  to `home/projects/alignment/data/fastq/`.

```bash
%%bash
# 1-2. Download *.fastq.gz abd SraRunTable.csv into /home/projects/alignment/data/fastq ##
cd /home/projects/alignment/data/fastq
wget -O SRR21709659_1.subset.fastq.gz https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FDE8uIHF5mILKd1wvDn7f%2Fuploads%2FQH315NJqT1pJdmk9Pc6s%2FSRR21709659_1.subset.fastq.gz?alt=media&token=2f52d3ef-16e8-420b-9434-23d12e116f05
wget -O SRR21709659_2.subset.fastq.gz https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FDE8uIHF5mILKd1wvDn7f%2Fuploads%2Fkjo8wsrWSvFzJPrSr4VF%2FSRR21709659_2.subset.fastq.gz?alt=media&token=77f5c3ef-1b81-428e-8ad7-d510d97121ac
wget -O SRR21709661_1.subset.fastq.gz https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FDE8uIHF5mILKd1wvDn7f%2Fuploads%2FfIz3wRAi1O9WCMtrQs7C%2FSRR21709661_1.subset.fastq.gz?alt=media&token=f59f7284-d246-4ba0-a726-7a0c4b1745da
wget -O SRR21709661_2.subset.fastq.gz https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FDE8uIHF5mILKd1wvDn7f%2Fuploads%2F3NO0EQUcdTre7h004ZX1%2FSRR21709661_2.subset.fastq.gz?alt=media&token=49c75223-bb12-41d5-93d4-567db5dc45e7
wget -O SRR21709662_1.subset.fastq.gz https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FDE8uIHF5mILKd1wvDn7f%2Fuploads%2F9pTqCl6nnoc8Rqnucd8N%2FSRR21709662_1.subset.fastq.gz?alt=media&token=78c04238-3a3c-4ee9-8ea8-c7b6c7f47c16
wget -O SRR21709662_2.subset.fastq.gz https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FDE8uIHF5mILKd1wvDn7f%2Fuploads%2FKOPmB3CJPn2woFGq4NBg%2FSRR21709662_2.subset.fastq.gz?alt=media&token=0422521d-b855-4974-976d-69bb16d211e4
wget -O SRR21709664_1.subset.fastq.gz https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FDE8uIHF5mILKd1wvDn7f%2Fuploads%2FJlcQb2SILyALHyzI8ngJ%2FSRR21709664_1.subset.fastq.gz?alt=media&token=4f474d5c-38ac-417b-b444-9ae011250899
wget -O SRR21709664_2.subset.fastq.gz https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FDE8uIHF5mILKd1wvDn7f%2Fuploads%2FpgLHtij32ZF0sG7yDZIn%2FSRR21709664_2.subset.fastq.gz?alt=media&token=8398de4f-b5bd-425f-ae25-716c7f3626e1
wget -O SRR21709665_1.subset.fastq.gz https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FDE8uIHF5mILKd1wvDn7f%2Fuploads%2FDjgadjP0v5YngE1hYqC1%2FSRR21709665_1.subset.fastq.gz?alt=media&token=cf5c2862-aa85-4e4c-88f2-d16cdefecc9d
wget -O SRR21709665_2.subset.fastq.gz https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FDE8uIHF5mILKd1wvDn7f%2Fuploads%2FWxXQWUVnjP7w0mbnbTF0%2FSRR21709665_2.subset.fastq.gz?alt=media&token=f1a6813d-f04a-4525-bd3e-18cfca7d3b0c
wget -O SRR21709666_1.subset.fastq.gz https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FDE8uIHF5mILKd1wvDn7f%2Fuploads%2FVfx5MqGYwtWaOKgmprQo%2FSRR21709666_1.subset.fastq.gz?alt=media&token=cc1ee1fb-5404-43a8-95f7-29d9ed0ba404
wget -O SRR21709666_2.subset.fastq.gz https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FDE8uIHF5mILKd1wvDn7f%2Fuploads%2FRoES1qgyesHwJXwl6pqf%2FSRR21709666_2.subset.fastq.gz?alt=media&token=a7c5a1dd-811f-4227-beee-3eab2fae2e0a
wget -O SraRunTable.csv https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FDE8uIHF5mILKd1wvDn7f%2Fuploads%2F0ls4UzV4WIX0k6KB8ZjU%2FSraRunTable.csv?alt=media&token=363ea478-b1dd-4a0c-be89-cc757e2c4548

```

<figure><img src="../.gitbook/assets/image (67).png" alt=""><figcaption></figcaption></figure>

You should see all the files under `home/projects/alignment/data/fastq/`.



#### 2. Install the command-line tools required for alignment, BAM processing, and gene counting.

```bash
%%bash
# 2-1. Update available packages list
apt-get update
```

```bash
%%bash
# 2-2. Install required packages for alignment and quantification
## hisat2: aligner
## samtools: BAM handling
## subread: quantifier
apt-get install -y hisat2 samtools subread
```



#### 3. Download the human GRCh38 HISAT2 index and GENCODE gene annotation file used later for alignment and quantification.

<pre class="language-bash"><code class="lang-bash"><strong>%%bash
</strong># 3-1. Make a directory to store references under /home
mkdir -p /home/reference

# 3-2. Download reference genome for hisat2
wget https://genome-idx.s3.amazonaws.com/hisat/grch38_genome.tar.gz
tar -xzf grch38_genome.tar.gz

# 3-3. Download gene annotation for quantification
cd /home/reference/
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_50/gencode.v50.basic.annotation.gtf.gz
</code></pre>



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







