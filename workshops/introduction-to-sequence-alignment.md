---
description: 14 Jul 2026
icon: '2'
---

# Introduction to sequence alignment

## Welcome to the Bioinformatics Hub workshop!&#x20;

Today, we will learn how to align raw RNA-seq reads to a reference genome and quantify gene expression levels.

Before we begin, we need several files required for the analysis. Some files are small, while others can be quite large.

### Required files

Let's start by looking into the files we need today.



First, let's look at the input files we will use today:

#### **1. Paired-end raw sequencing reads (FASTQ files)**

These files contain the raw RNA-seq reads generated from the sequencing experiment. Since our data are paired-end sequencing data, each sample has two FASTQ files:

* `_1.fastq.gz` → forward reads
* `_2.fastq.gz` → reverse reads

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

#### **2. Sample metadata (CSV file)**

This file contains information about each sample, such as **sample names** and **experimental groups**. It allows us to compare gene expression between conditions.

{% file src="../.gitbook/assets/SraRunTable (2).csv" %}

We also need two reference files for the analysis:

#### **3. Reference genome index**

A reference genome provides the known sequence of the organism's genome. We use it as a template to identify where each RNA-seq read originated from during alignment.&#x20;

Since the RNA-seq data used in today's workshop are from **human cells**, we will use the human reference genome. The most widely used human genome reference version is **GRCh38**.

#### **4. Gene annotation file (GTF)**

The gene annotation file contains information about gene locations and names. We use this file during gene quantification to count how many reads belong to each gene.&#x20;

For this workshop, we will use the **GENCODE human release 50** annotation file.

The files will be downloaded directly into Google Colab during the tutorial.



### Software used

* HISAT2 (alignment)
* SAMtools (BAM processing)
* featureCounts (gene quantification)
* DESeq2 (differential expression)
* EnhancedVolcano (visualisation)
* ggplot2 / patchwork (plotting)



## What is sequence alignment?

When RNA is sequenced, the resulting reads are stored in **FASTQ** files as short sequences of nucleotides (A, C, G and T/U). However, these files do not indicate where each read originated in the genome.

To determine the origin of each read, we compare the sequences against a **reference genome** using a sequence alignment (or **mapping**) program. The aligner identifies the most likely genomic location for each read, allowing us to determine which gene it came from.

Sequence alignment is a fundamental step in RNA-seq analysis because it enables us to count how many reads map to each gene. These gene-level counts are then used to estimate gene expression levels and identify genes that are differentially expressed between experimental conditions.

For this workshop, we will analyse a publicly available RNA-seq dataset comparing **TGF-β-treated** and **untreated human trabecular meshwork cells**. If you would like to learn more about the dataset, please refer to the original publication:

{% embed url="https://www.mdpi.com/2218-273X/12/11/1693" %}



## Workflow

Let's begin the RNA-seq analysis workflow.&#x20;

Go to Google Colab.

[https://colab.research.google.com/](https://colab.research.google.com/)

Open a new Google Colab notebook:

<figure><img src="../.gitbook/assets/Screenshot 2026-06-23 at 15.51.09.png" alt=""><figcaption></figcaption></figure>

Click **New notebook in Drive**.

<figure><img src="../.gitbook/assets/image (65).png" alt=""><figcaption></figcaption></figure>

In the notebook, you will see a **cell**.

A cell can be one of two types:

* **Code cell**
  * Contains executable code
  * Running the cell will perform the commands written inside
* **Text cell**
  * Contains explanations, titles, and notes
  * Used to document the workflow and describe each step

### I. Analysis Setup

#### 1. Create Project Directories&#x20;

Before starting the analysis, we will create a dedicated project folder to organise all input and output files.

We will create a project directory called:

`/home/projects/alignment/`

Inside this folder, we will create:

`/home/projects/alignment/data/fastq/`

This folder will store the raw sequencing files (FASTQ) and sample metadata.

Throughout this workshop, all files generated during the analysis — from raw sequencing reads to final results such as volcano plots — will be stored inside this project directory.

```bash
%%bash
# 1-1. Make a project directory called "alignment" under /home
mkdir -p /home/projects/alignment/data/fastq
```

Next, we will download the files required for today's analysis:

* Paired-end FASTQ files (`*.fastq.gz`)
  * These contain the raw RNA-seq sequencing reads
* Sample metadata file (`SraRunTable.csv`)
  * This contains information about each sequencing sample

All files will be downloaded into:

`/home/projects/alignment/data/fastq/`

```bash
%%bash
# 1-2. Download FASTQ files and sample metadata
# Move into the directory where the files will be stored
cd /home/projects/alignment/data/fastq

# 1-3. Download FASTQ files and metadata
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



#### 2. Install Required Software

Install the command-line tools needed for RNA-seq analysis.

These tools will be used for:

* **HISAT2**: aligning RNA-seq reads to the reference genome
* **Samtools**: processing and indexing BAM alignment files
* **featureCounts (Subread)**: counting how many reads map to each gene

```bash
%%bash
# 2-1. Update the list of available software packages 
# to make sure we install the newest available versions
apt-get update

# 2-2. Install required packages for alignment and quantification
apt-get install -y hisat2 samtools subread
```



#### 3. Download the Reference Genome and Gene Annotation

Download the files needed for RNA-seq alignment and quantification.

We need two reference files:

1. **HISAT2 genome index**
   * Used by HISAT2 to quickly align reads to the human genome.
   * This is a pre-built version of the GRCh38 human genome.
2. **GENCODE gene annotation file (GTF)**
   * Contains information about gene locations.
   * Used by featureCounts to assign reads to genes.

<pre class="language-bash"><code class="lang-bash"><strong>%%bash
</strong># 3-1. Make a directory to store references under /home
# All genome-related files will be stored here
mkdir -p /home/reference

# Move into the reference directory
cd /home/reference/


# 3-2. Download the pre-built GRCh38 HISAT2 genome index
wget https://genome-idx.s3.amazonaws.com/hisat/grch38_genome.tar.gz

# 3-3. Extract the downloaded HISAT2 index files
tar -xzf grch38_genome.tar.gz

# 3-4. Download GENCODE gene annotation file
# This file contains gene names and genomic coordinates
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_50/gencode.v50.basic.annotation.gtf.gz
</code></pre>



### II. Sequence Alignment & Quantification

#### 4. Align RNA-seq Reads with HISAT2

Align paired-end RNA-seq reads against the human genome.

Input:

* FASTQ files containing raw sequencing reads

Output:

* BAM files containing aligned reads

Each sample will produce:

* sample.bam → aligned reads
* sample.bam.bai → index file for quick access

```bash
%%bash
# 4-1. Create a directory to store alignment output files
mkdir -p /home/projects/alignment/data/bam
```

Run HISAT2 alignment for every sample.

The loop:

1. Reads each sample name from `SraRunTable.csv`
2. Finds the matching paired FASTQ files
3. Aligns reads using HISAT2
4. Sorts the alignment output
5. Saves it as a BAM file
6. Creates an index file

```bash
%%bash
# 4-2. For all the samples, run alignment (takes about 20 mins)
while read SRR; do
echo "Aligning "${SRR}"..."
hisat2 \
  -x /home/reference/grch38/genome \
  -1 /home/projects/alignment/data/fastq/${SRR}_1.subset.fastq.gz \
  -2 /home/projects/alignment/data/fastq/${SRR}_2.subset.fastq.gz \
  -p 8 \
| samtools sort -o /home/projects/alignment/data/bam/${SRR}.bam

# 4-3. Create BAM index file
samtools index /home/projects/alignment/data/bam/${SRR}.bam

# Read sample names from the first column of SraRunTable.csv
done < <(cut -d"," -f1 /home/projects/alignment/data/fastq/SraRunTable.csv)
```

***

## Break!

***

Check whether alignment produced the expected BAM files.

For 6 samples, you should see:

* 6 BAM files
* 6 BAM index files (.bai)

```bash
%%bash
# 4-4. List all generated BAM and index files
ls /home/projects/alignment/data/bam

# 4-5. Check the contents of a BAM file
# samtools view converts BAM back into readable alignment text
# tail shows the last few alignment records
SRR="SRR21709666"
samtools view /home/projects/alignment/data/bam/${SRR}.bam | tail
```



#### 5. Generate Gene Counts with featureCounts

Convert aligned reads into a gene expression count matrix.

featureCounts:

* Takes BAM alignment files as input
* Counts how many reads overlap each gene
* Produces a table that can be used for differential expression analysis

```bash
%%bash
# 5-1. Create a directory to store featureCounts results
mkdir -p /home/projects/alignment/result/featureCounts/
```

Run featureCounts to quantify gene expression.&#x20;

```bash
%%bash
# 5-2. Use the bam files to quantify gene expression levels
featureCounts \
  -T 4 \
  -p \
  -g gene_name \
  -a /home/reference/gencode.v50.basic.annotation.gtf.gz \
  -o /home/projects/alignment/result/featureCounts/merged_counts.txt \
  /home/projects/alignment/data/bam/*.bam  
```



### III. Differential Expression Analysis

#### 6. Enable R in Google Colab

Load the R extension so that we can run R code inside this Python notebook.

```python
# 6-1. Load R extension to run R code
%load_ext rpy2.ipython
```



#### 7. Install R Packages

Install the R packages needed for:

* Data manipulation
* Differential expression analysis
* Volcano plot generation

Packages:

* tidyverse → data processing and plotting
* DESeq2 → differential expression analysis
* EnhancedVolcano → volcano plots
* patchwork → combining multiple plots
* ggrepel → improving text label placement

```r
%%R
# 7-1. Install BiocManager
if(!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager", quiet = TRUE, update = FALSE)
}

# 7-2. Install CRAN packages
cran_packages <- c("tidyverse", "patchwork", "ggrepel")
new_cran <- cran_packages[!(cran_packages %in% installed.packages()[,"Package"])]
if(length(new_cran)) install.packages(new_cran, quiet = TRUE)


# 7-3. Install Bioconductor packages
bioc_packages <- c("DESeq2", "EnhancedVolcano")
new_bioc <- bioc_packages[!(bioc_packages %in% installed.packages()[,"Package"])]
if(length(new_bioc)) BiocManager::install(new_bioc, update = FALSE, ask = FALSE, quiet = TRUE)
```



#### 8. Load Count Matrix on R

Read the `featureCounts` output file from step 5.

The featureCounts table contains:

* Gene information columns
* Read counts for each sample

We remove unnecessary annotation columns and keep only the count matrix `count_matrix`.

```r
%%R
set.seed(123) # Set random seed so results are reproducible

# 8-1. Read the featureCounts file, skipping the first header line (the command line info)
counts_data <- read.table("/home/projects/alignment/result/featureCounts/merged_counts.txt", 
                                header = TRUE, sep = "\t", 
                                check.names = FALSE)

# 8-2. Set gene IDs as row names
rownames(counts_data) <- counts_data$Geneid

# 8-3. Remove the metadata columns (Chr, Start, End, Strand, Length)
# and the original Geneid column to leave only the raw counts
count_matrix <- counts_data[, -c(1:6)]

# 8-4. Clean up sample names (column names)
colnames(count_matrix) <- gsub(".bam$", "", colnames(count_matrix)) # removes .bam suffix
colnames(count_matrix) <- basename(colnames(count_matrix))          # removes the directory path

# 8-5. Convert to a matrix format required by DESeq2
count_matrix <- as.matrix(count_matrix)
print(head(count_matrix))
print(class(count_matrix))
```



#### 9. Create the DESeq2 Dataset

DESeq2 needs:

1. Count matrix
   * genes × samples
2. Sample metadata
   * information about each sample group
3. Experimental design
   * tells DESeq2 what comparison to perform

<pre class="language-r"><code class="lang-r">%%R
# Load DESeq2 library
library(DESeq2)

# 9-1. Load sample metadata table
# This contains information about each sample,
# including which group it belongs to
sample_metadata &#x3C;- read.csv("/home/projects/alignment/data/fastq/SraRunTable.csv", 
                              header = TRUE, 
                              stringsAsFactors = TRUE)

# 9-2. Match metadata rows with count matrix columns
# The row names must match sample names exactly
rownames(sample_metadata) &#x3C;- sample_metadata$Run

# 9-3. Keep only useful metadata columns
# For example, keeping 'SampleName' and 'SampleGroup' (Treated vs Control)
sample_metadata &#x3C;- sample_metadata[, c("SampleName", "SampleGroup")]

# 9-4. Take a look at the formatted metadata
print(head(sample_metadata))

# 9-5. Create DESeq2 dataset
# design = ~ SampleGroup means:
# compare samples based on their treatment group
dds &#x3C;- DESeqDataSetFromMatrix(countData = count_matrix,
                              colData = sample_metadata,
                              design = ~ SampleGroup)

# 9-6. Set the control group as the reference
# Results will be: Treated vs "Control"
<strong>dds$SampleGroup &#x3C;- relevel(dds$SampleGroup, ref = "Control")
</strong></code></pre>



#### 10. Run Differential Expression Analysis

DESeq2 performs:

* Normalisation
* Estimation of dispersion
* Statistical testing

Low-count genes are removed first because they provide unreliable results.

```r
%%R

# 10-1. Select genes to keep with at least 5 counts in at least 3 samples
keep <- rowSums(counts(dds) >= 5) >= 3

# 10-2. Filter low-expression genes from dds
dds <- dds[keep, ]

# 10-3. Run the differential expression pipeline
dds <- DESeq(dds)

# 10-4. View a summary of the results
# It should look like: "SampleGroup Treated vs Control"
resultsNames(dds)
```



#### 11. Check the DE Analysis Result

Extract results from the DESeq2 model.

The output contains:

* log2FoldChange → size and direction of change
* p-value → statistical significance
* adjusted p-value → corrected for multiple testing

```r
%%R
# 11-1. Extract the results for Treated vs Control
res1 <- results(dds, name="SampleGroup_Treated_vs_Control")

# 11-2. Convert to a dataframe
res_df1 <- as.data.frame(res1)

# 11-3. View first few genes
head(res_df1)
```



#### 12. Visualise Differentially Expressed Genes

A volcano plot shows:

X-axis:

* log2 fold change
* positive = increased expression in Treated
* negative = decreased expression in Treated

Y-axis:

* adjusted p-value

Genes far from the centre are more differentially expressed.

```r
%%R
# Load EnhancedVolcano library
library(EnhancedVolcano)

# 12-1. Use DESeq2 results
res_df <- res_df1

# 12-2. Select the top 15 most significant genes
top_genes <- rownames(res_df[order(res_df$padj, na.last = TRUE), ])[1:15]

# 12-3. Generate volcano plot and save into p1
p1 <- EnhancedVolcano(res_df,
    lab = rownames(res_df),
    x = 'log2FoldChange',
    y = 'padj',
    pCutoff = 0.05,
    FCcutoff = 1.0,

    # --- The Fixes ---
    selectLab = top_genes,          # ONLY draw text labels for these top 10 genes
    drawConnectors = TRUE,          # Draws lines from the dot to the text label
    widthConnectors = 0.5,          # Thin connector lines
    colConnectors = 'black',        # Color of the lines
    arrowheads = FALSE,             # Keep lines clean without arrow tips

    ylim = c(0, 5),
    legendPosition = 'none',
    caption = NULL,
    max.overlaps = 20,              # Keeps R from crashing if labels crowd up
    pointSize = 1.5,                # Shrink the dots slightly to un-crowd the base
    labSize = 3.5,                  # Shrink font size slightly for better fitting
    # ------------------

    title = 'Treated vs Control',
    subtitle = NULL)
    
# 12-4. Show p1
print(p1)
```

Which genes are upregulated downregulated from the result?



#### 13. Reverse the Comparison Direction

Repeat the differential expression analysis, but this time use the **Treated** group as the reference.

Changing the reference group reverses the sign of the log2 fold changes:

* **Control as reference** → positive values indicate genes upregulated in Treated.
* **Treated as reference** → positive values indicate genes upregulated in Control.

The statistical significance remains the same; only the direction of the comparison changes.

```r
%%R
# 13-1. Recreate the DESeq2 dataset from count_matrix
dds <- DESeqDataSetFromMatrix(countData = count_matrix,
                              colData = sample_metadata,
                              design = ~ SampleGroup)

# 13-2. Set Treated as the reference group
# Results will now be reported as: Control vs Treated
dds$SampleGroup <- relevel(dds$SampleGroup, ref = "Treated")
```



#### 14. Check the Reversed DE Anlaysis Result

Run DESeq2 again using the new reference group and extract the results.

```r
%%R

# 14-1. Remove genes with very low read counts
# Keep genes with at least 5 reads in at least 3 samples
keep <- rowSums(counts(dds) >= 5) >= 3
dds <- dds[keep, ]

# 14-2. Run the differential expression pipeline
dds <- DESeq(dds)

# 14-3. View a summary of the results to make sure it ran against your reference group
# It should look something like: "SampleGroup Control vs Treated"
resultsNames(dds)

# 14-4. Extract the results for Control vs Treated
res2 <- results(dds, name="SampleGroup_Control_vs_Treated")

# 14-5. Convert the results into a standard data frame
res_df2 <- as.data.frame(res2)

# 14-6. View the first few genes
head(res_df2)
```



#### 15. Generate a Reversed Volcano Plot

Create a volcano plot for the Control vs Treated comparison.

The overall pattern should look identical to the previous volcano plot, but the log2 fold changes will have opposite signs.

```r
%%R

# 15-1. Use the reversed DESeq2 results
res_df <- res_df2

# 15-2. Select the 15 most significant genes for labelling
top_genes <- rownames(res_df[order(res_df$padj, na.last = TRUE), ])[1:15]

# 15-3. Generate the volcano plot
p2 <- EnhancedVolcano(res_df,
    lab = rownames(res_df),
    x = 'log2FoldChange',
    y = 'padj',
    pCutoff = 0.05,
    FCcutoff = 1.0,

    # --- The Fixes ---
    selectLab = top_genes,          # ONLY draw text labels for these top 10 genes
    drawConnectors = TRUE,          # Draws lines from the dot to the text label
    widthConnectors = 0.5,          # Thin connector lines
    colConnectors = 'black',        # Color of the lines
    arrowheads = FALSE,             # Keep lines clean without arrow tips

    ylim = c(0, 5),
    legendPosition = 'none',
    caption = NULL,
    max.overlaps = 20,              # Keeps R from crashing if labels crowd up
    pointSize = 1.5,                # Shrink the dots slightly to un-crowd the base
    labSize = 3.5,                  # Shrink font size slightly for better fitting
    # ------------------

    title = 'Control vs Treated',
    subtitle = NULL)

# 15-4. Display the plot
print(p2)

```

What difference did you find? What are the biological implications of the difference?

This is why the control should always be behind the vs.



#### 16. Save the Figures

Combine the two volcano plots into a single figure and save it as a PNG image.

```r
%%R
# 16-1. Load patchwork and ggplot2 libraries for plotting
library(patchwork)
library(ggplot2)

# 16-2. Create the output directory 
dir.create('/home/projects/alignment/result/DESeq2', showWarnings = FALSE)

# 16-3. Arrange the two volcano plots side-by-side
combined_plot <- p1 | p2

# 16-4. Save the figure
ggsave(filename = '/home/projects/alignment/result/DESeq2/volcano_plots.png',
       plot = combined_plot,
       width = 10,
       height = 6,
       dpi = 300)
```



#### 17. Export Significant Genes

Extract significantly differentially expressed genes and save them as a CSV file.

Here we define significant genes as:

* Adjusted p-value < 0.05

The genes are also separated into:

* Upregulated genes
* Downregulated genes

```r
%%R
# Load data manipulating packages
library(tidyverse)
library(dplyr)

# 17-1. Import the first result again into res_df
res_df <- res_df1

# 17-2. Keep only statistically significant genes
sig_genes <- res_df %>%
  filter(padj < 0.05 & !is.na(padj)) %>%
  arrange(padj) # Sorts by most significant first

# 17-3. Split them into Up and Down regulated for deeper insights
sig_up <- sig_genes %>% filter(log2FoldChange > 0)    # Genes with positive log2 fold change
sig_down <- sig_genes %>% filter(log2FoldChange < 0)  # Genes with negative log2 fold change

# 17-4. Save the significant genes table
write.csv(sig_genes, "/home/projects/alignment/result/DESeq2/Treated_vs_Control_DE_genes_padj0.05.csv", row.names = TRUE)
```



#### 18. Summarise the Results

Display a simple summary of the differential expression analysis.

The summary includes:

* Total number of significant genes
* Number of upregulated genes
* Number of downregulated genes

```r
%%R
# Print a breakdown of the counts
cat("--- Differential Expression Summary ---\n")
cat("Total Significant Genes: ", nrow(sig_genes), "\n")
cat("Up-regulated (Treated > Control): ", nrow(sig_up), "\n")
cat("Down-regulated (Control > Treated): ", nrow(sig_down), "\n")
```



## **Congratulations on completing the workshop!**

&#x20;You have successfully aligned raw RNA-seq reads, quantified gene expression, and performed differential expression analysis to identify biologically meaningful changes. We hope this workshop has given you a solid foundation for analysing your own RNA-seq data.

If you would like to apply this workflow to your own research project or need help adapting it to your or public data, don't hesitate to contact the **Bioinformatics Hub** at jiwon.kim@ucl.ac.uk.

