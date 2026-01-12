---
icon: dna
---

# Single-cell RNA sequencing #0: Introduction

## What is single-cell RNA-seq?

**Single-cell RNA sequencing** is a method scientists use to look at which genes are active in **individual cells**. Human body has many different types of cells, and even similar-looking cells can behave differently. Imagine going to a concert and recording every person’s singing voice separately, instead of listening to the crowd as a whole. That way, you can tell who’s singing what, and maybe find a few people singing off-key (like diseased or special cells).



## Graphic overview

<figure><img src="../../.gitbook/assets/scrnaseq overview.png" alt=""><figcaption></figcaption></figure>



## Step-by-Step scRNA-seq Analysis Workflow

{% stepper %}
{% step %}
### Read Mapping & Quantification

* Align sequencing reads to a reference genome or transcriptome.
* Quantify gene expression by counting how many reads map to each gene for each cell.
* Output: gene-cell count matrix (e.g. UMI counts).
{% endstep %}

{% step %}
### Quality Control (QC)

* Identify and remove poor-quality cells or technical artifacts.
* Common metrics:
  * Low gene count (empty droplets or damaged cells)
  * High mitochondrial gene percentage (stressed or dying cells)
  * Doublets (two cells captured together)
{% endstep %}

{% step %}
### Normalization

* Adjust for differences in sequencing depth or capture efficiency across cells.
* Makes gene expression values comparable between cells.
* Methods: library size normalization, log-normalization, SCTransform, etc.
{% endstep %}

{% step %}
### Feature Selection

* Select highly variable genes (HVGs) that show meaningful biological variation.
* Reduces noise and computational load for downstream analysis.
{% endstep %}

{% step %}
### Dimension Reduction

* Reduce data to fewer dimensions for visualization and analysis.
* Techniques: PCA (Principal Component Analysis), UMAP, t-SNE.
* Helps capture the main biological signals in the data.
{% endstep %}

{% step %}
### Clustering & Cell Type Annotation

* Group cells into clusters based on gene expression similarity.
* Assign biological cell types to clusters using marker genes or reference datasets.
{% endstep %}

{% step %}
### Differential Expression Analysis

* Compare gene expression between groups (e.g. cell types, conditions).
* Identify genes that are up- or down-regulated in different cell populations.
{% endstep %}

{% step %}
### Pathway / Gene Set Enrichment Analysis

* Interpret differentially expressed genes in the context of biological pathways or gene sets in different cell lines.
* Methods: GSEA, KEGG, GO enrichment, Reactome, etc.
{% endstep %}

{% step %}
### Visualization & Interpretation

* Generate plots (e.g. UMAP, violin plots, heatmaps) to summarize and communicate results.
* Integrate findings with prior knowledge to draw biological conclusions.
{% endstep %}
{% endstepper %}
