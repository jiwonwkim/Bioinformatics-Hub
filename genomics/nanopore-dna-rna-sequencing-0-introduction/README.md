---
icon: dna
---

# Nanopore DNA/RNA sequencing #0: Introduction

## What is Nanopore sequencing?

**Nanopore sequencing** is a DNA or RNA sequencing technology that reads nucleotide sequences by passing single molecules through tiny protein pores (nanopores) and measuring changes in electrical current. These changes correspond to specific bases (A, T, C, G or U), allowing real-time, **long-read sequencing** without the need for amplification.

In some cases, nanopore sequencing detect DNA methylation **directly without requiring bisulfite conversion**. Changes in electrical current caused by modified bases, like 5-methylcytosine, produce distinct signals that can be identified using specialized software (e.g., Nanopolish or Guppy with methylation calling).&#x20;





## Step-by-Step Nanopore sequencing Analysis

{% stepper %}
{% step %}
### Sample Preparation & Sequencing

* **Library preparation** using Oxford Nanopore kits (with or without barcoding)
* **Loading** onto a Nanopore device (e.g., MinION, GridION, PromethION)
* Converts raw electrical signals into nucleotide sequences.
* **Tool**: `Guppy`, `Bonito`, or `Dorado`
* **Output**: FASTQ files (can include methylation tags if enabled)
{% endstep %}

{% step %}
### Quality Control

* Assess read quality, length, and yield.
* **Tools**: `NanoPlot`, `pycoQC`, `FastQC`
{% endstep %}

{% step %}
### Read Alignment

* Align reads to a reference genome.
* **Tool**: `minimap2` (commonly used for long reads)
* **Output**: SAM/BAM files
{% endstep %}

{% step %}
### Variant Calling

* Identify SNPs, indels, structural variants
* **Tools**:
  * Small variants: `Medaka`, `Nanopolish`, `Clair3`
  * SVs: `Sniffles`, `cuteSV`
{% endstep %}

{% step %}
### Downstream Analysis

* **For DNA**: Structural variant analysis, methylation patterns, genome comparison
* **For RNA**: Isoform identification, gene expression
* **Tools**: `IGV` (visualization), `Samtools`, `BEDtools`, `Ensembl VEP`
{% endstep %}
{% endstepper %}





