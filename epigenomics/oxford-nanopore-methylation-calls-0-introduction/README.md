---
icon: dna
---

# Oxford Nanopore methylation calls #0: Introduction



## What is Nanopore methylation calls?

Oxford Nanopore sequencing allows **native DNA sequencing**, meaning methylation marks are preserved and read directly—without bisulfite conversion. Unlike bisulfite sequencing which detects 5-methylcytosine (5mC), Nanopore detects multiple DNA modifications with single-nucleotide resolution, including **5‑hydroxymethylcytosine (5hmC), and 6‑methyladenine (6mA) as well as 5mC.**

Once Nanopore sequening is complete, the raw sequence reads are saved into FASTQ format, while methylation calls are stored into uBAM (unaligned BAM) format. The uBAM format enables **per-base modification calls** (e.g., 5mC, 6mA) to be embedded in BAM files using standardized tags, preserving bothe sequence and modification inforamtion.



Oxford Nanopore provides direct detection of DNA or RNA methylation. As opposed to bisulfite sequencing, Nanopore detects m<sup>6</sup>A in RNA and 5mC, 5hmC, and 6mA in DNA, without&#x20;
