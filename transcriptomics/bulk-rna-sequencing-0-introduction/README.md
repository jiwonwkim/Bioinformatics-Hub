---
icon: dna
---

# Bulk RNA sequencing #0: Introduction

## What is RNA-seq?

RNA sequencing (RNA-seq) allows us to measure gene expression by sequencing the RNA content of cells or tissues. The goal is to understand **which genes are active**, and **how much they are expressed**, under different conditions.



## Graphic overview

<figure><img src="../../.gitbook/assets/rnaseq overview.png" alt=""><figcaption></figcaption></figure>



## Step-by-Step RNA-seq Analysis Workflow

{% stepper %}
{% step %}
### Quality Control of Raw Reads&#x20;

Quality control is required **to check if the sequencing worked properly and to detect any low quality or contamination** early on. `FastQC` checks for abnormalities such as sequencing quality or adapter contamination. If any were found, they can be removed with `trimgalore` as it can interfere with accurate mapping or quantification.
{% endstep %}

{% step %}
### **Read Alignment or Quantification**

Read alignment, or mapping, is **essential** to figure out which gene or transcript each read came from, so we can measure gene expression. Raw sequencing data don't contain any information about which part of genome they were sequenced from, so we have to use **a reference genome**, whose gene positions we already know about, **to infer where each read came from**. `STAR` is an aligner that maps reads to the reference genome, and `Salmon` gives transcript/gene counts.&#x20;
{% endstep %}

{% step %}
### Quality Control of Mapped Data

To confirm that most reads aligned correctly, and to check for technical problems (e.g., one sample behaving differently from others), post-alignment quality checks are needed. You can run principal component analysis (PCA) to see if there are any outliers within a group. If you have one, you may consider excluding the sample from the analysis as the whole analysis can be biased by the outlier.&#x20;
{% endstep %}

{% step %}
### Normalization

Raw counts are biased by **sequencing depth** and **gene length.** Normalization allows fair comparisons across genes. `Salmon` returns normalized gene counts, Transcripts Per Kilobase Million (TPM), as well as raw counts.
{% endstep %}

{% step %}
### **Differential Expression Analysis**

Once you get expression levels of all genes, you now want to find genes whose expression levels change significantly between your conditions—these are your **DEGs**. R package `DESeq2` compares gene expression levels between groups and returns the fold changes and p-values.
{% endstep %}

{% step %}
### Functional Enrichment Analysis

Knowing which genes are differentially expressed may not be enough to discover what's going on in your samples. To understand what biological pathways or functions are affected by your condition, `GO` or `KEGG` database are used.
{% endstep %}

{% step %}
### **Visualization (volcano plot, heatmap)**

To better understand patterns in. you data, and communicate significant findings clearly,  you can  draw volcano plot or heatmap. Volcano plot shows genes with high significance and big fold change difference, and heatmap shows the gene expression patterns across samples.
{% endstep %}
{% endstepper %}
