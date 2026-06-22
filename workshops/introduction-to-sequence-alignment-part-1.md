---
description: Jul 2026
hidden: true
icon: '2'
---

# Introduction to sequence alignment: Part 1

Welcome to the Bioinformatics Hub workshop! Today, we are going to&#x20;

[https://www.mdpi.com/2218-273X/12/11/1693](https://www.mdpi.com/2218-273X/12/11/1693)

## Required files

Before we begin, we have to download some (or a lot of) files.

Let's go through what files we need.

#### Raw sequences (FASTQ)

<details>

<summary>Raw sequences (FASTQ)</summary>

{% file src="../.gitbook/assets/SRR21709666_2.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709666_1.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709665_2.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709665_1.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709664_2.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709664_1.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709663_2.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709663_1.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709662_2.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709662_1.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709661_2.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709661_1.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709660_2.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709660_1.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709659_2.subset.fastq.gz" %}

{% file src="../.gitbook/assets/SRR21709659_1.subset.fastq.gz" %}







</details>

#### Metadata (CSV)

{% file src="../.gitbook/assets/SraRunTable.csv" %}

#### Reference genome

```
wget https://genome-idx.s3.amazonaws.com/hisat/grch38_genome.tar.gz
```

#### Gene annotation (GTF)

```
curl https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_50/gencode.v50.basic.annotation.gtf.gz
```

