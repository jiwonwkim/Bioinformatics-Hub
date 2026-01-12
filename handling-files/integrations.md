---
icon: files
---

# File Formats

Different types of data are stored in different file formats, which are usually indicated by the **file extension**—the suffix at the end of a file name. For example, in `example.pdf`, the `.pdf` extension tells you that it's a PDF document. Similarly, raw sequencing data are typically stored in `.fastq` or `.fq` files.

### Compressed

To save disk space and reduce file processing time, these files are often **compressed**. This is indicated by extensions like `.gz` or `.tar.gz` added to the end of the file name. For example, a compressed FASTQ file might appear as `example.fq.gz`.

Just like zip files, compressed files can't be read directly and must be **decompressed** first.\
On Linux, you can use the following commands to decompress them:

#### For **`.gz`**  files:

```sh
gzip -d [filename.gz]
```

#### For **`.tar.gz`**  files:

```sh
tar -zxfv [filename.tar.gz]
```

In many cases, compressed files are **indexed** to allow bioinformatic tools to access directly to the relevant part of the file **without decompressing** the whole file for efficient run.&#x20;



### Metadata

Metadata are typically stored in **comma-separated values (CSV)** format, which is commonly used to organise information about samples.



### Sequence

There are two common file formats for storing DNA/RNA sequences: **FASTA** and **FASTQ**.

<details>

<summary>FASTA (.fasta / .fastq.gz / .fa / .fa.gz)</summary>

**FASTA** is typically used for storing sequences with known positions and functions, such as genes or genomes.

</details>

<details>

<summary>FASTQ (.fastq / .fastq.gz / .fq / .fq.gz)</summary>

**FASTQ** is used for raw sequencing data, including quality scores for each base, which are essential for aligning the reads to a reference genome and interpreting their biological meaning. If you have **paired-end** read data, you will have two fastq files per sample: `sample1_R1.fq` for forward reads and `sample1_R2.fq` for reverse reads. &#x20;

</details>



### Alignment

Millions of raw reads in FASTQ format are aligned to a reference genome to determine their genomic positions.&#x20;

<details>

<summary>SAM/BAM (.sam / .bam): <strong>S</strong>equence <strong>A</strong>lignment Map / Binary Alignment Map</summary>

**SAM files** store alignment information of raw sequencing reads, including mapping quality and various metadata. **BAM files** are the binary, compressed version of SAM files—unreadable to humans but much smaller in size and faster to process. Despite the format difference, a BAM file contains the exact same information as its corresponding SAM file.

</details>



### Variants

Variant calling involves comparing aligned sequences to a reference genome to identify genetic differences. These differences, such as single nucleotide polymorphisms (SNPs) and insertions or deletions (indels), are typically stored in VCF files.

<details>

<summary>VCF (.vcf / .vcf.gz): Variant Calling Format</summary>

**VCF files** store sequence variants that differ from the reference genome. They can include genotype information for multiple individuals at each variant site, enabling population-level analyses.

</details>



### General features

To describe genes and other features of DNA or RNA, the General Feature Format (GFF) is used. There are two similar versions of this format—GFF and GTF—that differ slightly in structure and usage.

<details>

<summary>GFF (.gff3 / .gff2/ .gff): General Feature Format</summary>

**GFF** comes in several versions, with **GFF2** and **GFF3** being the most commonly used. While they differ slightly in structure and syntax, both are used to describe genomic features such as gene structures.

</details>

<details>

<summary>GTF (.gtf): Gene Transfer Format</summary>

**GTF format** is functionally equivalent to GFF version 2, with only minor differences in naming and usage.

</details>



For more detailed explanation and examples of these file formats, please follow the link below.

{% embed url="https://rnnh.github.io/bioinfo-notebook/docs/file_formats.html" %}

{% embed url="https://bioinformatics.uconn.edu/resources-and-events/tutorials-2/file-formats-tutorial/" %}

