---
icon: dna
---

# Short-read DNA sequencing #0: Introduction

## What is short-read DNA sequencing?

**Short-read DNA sequencing** is a high-throughput method that determines the nucleotide sequence of DNA by reading small fragments—typically 50 to 300 base pairs—at a time. Platforms like **Illumina** generate millions to billions of these reads in parallel, which are then computationally aligned to a reference genome or assembled de novo to analyze **genetic variations**.





## Step-by-Step DNA-seq Analysis Workflow

{% stepper %}
{% step %}
### Quality Control & Read Trimming

Tool: `FastQC`, `MultiQC` (QC)/ `Trim Galore!`, `cutadapt`, `Trimmomatic`

* Assess read quality (per-base quality, GC content, adapter contamination).
* Identify and trim low-quality bases or adapters.
* Output: cleaned FASTQ files
{% endstep %}

{% step %}
### Alignment to Reference Genome

Tool: `BWA`, `Bowtie2`, `STAR` (RNA-seq), `HISAT2`

* Map reads to a reference genome.
* Output: SAM/BAM file
{% endstep %}

{% step %}
### Sort & Index, Mark PCR duplicates

Tool: `SAMtools`, `Picard`, `GATK`

* Convert SAM to BAM, sort and index.
* Mark PCR duplicates.
* Ouput: deduplicated & sorted SAM/BAM file
{% endstep %}

{% step %}
### Variant Calling

Tool: `GATK`, `FreeBayes`, `bcftools`

* Identify SNPs and small insertions/deletions (indels).
* Output: VCF (variant call format) file
{% endstep %}

{% step %}
### Variant Filtering

Tool:  `bcftools filter`,  `GATK VariantFiltration`, `vcftools`

* Remove false positives and low-confidence variants.
{% endstep %}

{% step %}
### Downstream analysis

Tool: `ANNOVAR`, `SnpEff`, `Ensembl VEP`, `SIFT`

* Variant annotation, Functional interpretation, Variant effect prediction
{% endstep %}
{% endstepper %}
