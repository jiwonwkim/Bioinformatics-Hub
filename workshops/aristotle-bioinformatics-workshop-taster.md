---
description: This taster is for IoO Lates mini workshop on 29th January 2026.
icon: '0'
---

# Aristotle: Bioinformatics workshop taster

## Welcome to bioinformatics taster session!

In this session, we are going to learn:

1. What is a remote server
2. How to access a remote server (Aristotle)
3. How to download reference genome
4. How to get reference sequence of a gene
5. Practice



## 1. What is a remote server?

A **remote server** is a powerful computer located elsewhere that you can access over the internet. It has lots of storage and processing power, so it can handle big bioinformatics tasks like analyzing genomes, aligning sequences, and more.

You can connect to a remote server from your own computer (desktop or laptop) using tools like **SSH**, a secure login method. Once connected, you can run commands and programs on the server. In most cases, interacting with a remote server is done through the **command-line interface (CLI)**, which means there are no graphical icons; Everything is typed as commands. (Don't panic!)

Now, let's get started. Open **Terminal (macOS)** or **Powershell (Windows)** on your computer as following.

#### 1-1. Opening Terminal/Powershell

{% tabs %}
{% tab title="Windows" %}
Open **Windows PowerShell** as administrator.

<div align="left"><figure><img src="../.gitbook/assets/image (3).png" alt="" width="375"><figcaption></figcaption></figure></div>

<div align="left"><figure><img src="../.gitbook/assets/image (2).png" alt="" width="289"><figcaption></figcaption></figure></div>

<figure><img src="../.gitbook/assets/image (4).png" alt="" width="563"><figcaption></figcaption></figure>
{% endtab %}

{% tab title="macOS" %}
Open **Terminal**.

<div align="left" data-full-width="true"><figure><img src="../.gitbook/assets/image.png" alt="" width="178"><figcaption></figcaption></figure></div>

<figure><img src="../.gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>
{% endtab %}
{% endtabs %}



## 2. Accessing UCL Aristotle

**UCL Aristotle** is a Linux-based compute service for practicing the command-line interface. Anyone with a UCL user ID and within the UCL institutional firewall can access Aristotle with the following command on **Terminal (macOS)** or **Powershell (Windows)**:

#### 2-1. Access Aristotle

Replace `smgxxxx` with your UCL ID and enter the command:

```bash
ssh smgxxxx@aristotle.rc.ucl.ac.uk
```

Once you type the command, you may see the following message if you have never accessed Aristotle before:

```
The authenticity of host 'aristotle.rc.ucl.ac.uk (144.82.251.107)' can't be established.
ED25519 key fingerprint is SHA256:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? 
```

You can simply type `yes` and press Enter. You will then be asked to enter your password:

```
smgxxxx@aristotle.rc.ucl.ac.uk's password: 
```

Type your UCL password. Nothing will appear on the screen while you are typing — this is normal. Just enter your password and press Enter.

If you enter your password incorrectly, you will see:

```
Permission denied, please try again.
smgxxxx@aristotle.rc.ucl.ac.uk's password:
```

You can then try entering your password again.

Once you enter the correct password, you will see the bash prompt, which usually looks like this:

<pre><code>Last failed login: Mon Jan 12 15:22:57 GMT 2026 from xx.xx.x.x on ssh:notty
There were 1 failed login attempts since the last successful login.
Last login: Thu Jan  8 13:33:07 2026 from xx.xx.x.x
-bash-4.2<a data-footnote-ref href="#user-content-fn-1">$</a> 
</code></pre>

This means you are now logged into Aristotle and can run commands on the remote server.&#x20;

Also, it’s important to know that at any point while following these instructions, you can use **Ctrl+C** to cancel the current command.

<details>

<summary>If you’re unsure whether you’re using <code>bash</code></summary>

`bash` might not be the default shell on Aristotle. To check which shell you’re currently using, type:

```bash
 echo $0
```

This will display your current shell, for example: `sh`, `csh`, or `bash`.

To switch to Bash, simply type:

```bash
bash
```

and press **Enter**. Your prompt will now be in Bash.

</details>



## 3. Downloading reference genome

We are going to download the reference genome (FASTA file: `*.fa`) and the annotation (GTF file: `*.gtf`).&#x20;

The **reference genome** is the raw DNA sequence of the genome, consisting of A, C, G, and T. It is used as a base when running various analyses.&#x20;

The **annotation** file contains information about where genes, exons, transcripts, and other features are located on the genome. It does not contain the actual DNA sequence, but instead includes genomic coordinates, gene IDs, and related metadata.

To save disk space, we will download only a single chromosome from the reference genome. You can replace `CHR` with your desired chromosome.

The downloaded files will be compressed (gzipped, `*.gz`). We will unzip the reference genome file, but we will keep the annotation file compressed.

#### 3-1. Make a reference genome directory under the home directory

```bash
## Make a reference directory under $HOME
mkdir -p $HOME/reference
```

#### 3-2. Move to the reference directory

Change the current directory to `$HOME/reference`:

```bash
## Change current directory into $HOME/reference
cd $HOME/reference
```

Now that you are in this directory, you can download the reference genome.

If you want to check which files and directories are in the current directory, use:

```bash
## List the files in the current directory
ls
```

Since you just created this directory, there are no files inside, so nothing will be shown.

#### 3-3. Set the chromosome (1-22, X, or Y)

Specify the chromosome whose reference sequence you want to download:

```bash
## Set the chromosome (1-22/X/Y)
CHR=22
```

#### 3-4. Download the reference genome

Download the compressed reference genome and save it as `GRCh38.chr22.fa.gz` (for example).

```bash
## Download the reference genome (sequence)
wget -O GRCh38.chr$CHR.fa.gz https://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.chromosome.$CHR.fa.gz
```

Then, decompress the file.&#x20;

```bash
## Unzip the compressed fasta file
gzip -d GRCh38.*.fa.gz
```

#### 3-5. Download the annotation

Download the compressed annotation file and save it as `GRCh38.gtf.gz`. This file contains the positions of genes and other genomic features.

```bash
## Download the annotation (gene position)
wget -O GRCh38.gtf.gz https://ftp.ensembl.org/pub/release-115/gtf/homo_sapiens/Homo_sapiens.GRCh38.115.chr.gtf.gz
```

#### 3-6. Index the FASTA file

Many analyses require the reference genome to be indexed for efficient access to any position in the file.

Load `samtools` module to index the file.

```bash
## Load required modules
module load gcc-libs samtools
```

Index the reference genome using `samtools faidx`.

```bash
## Index the fasta file
samtools faidx GRCh38.chr$CHR.fa
```

Now that the reference genome is indexed, you can proceed to find the DNA sequence of a specific gene.



## 4. Extracting reference sequence of a gene&#x20;

Find the coordinates of the gene you want to extract. In this example, we use _MCAT_, since we downloaded the reference genome for chromosome 22.

You can replace `GENE` with any gene located on the chromosome you selected.

#### 4-1. Set the gene name on the chromosome

Specify the gene you want to extract from the reference genome:

```bash
## Set the gene name
GENE=MCAT
```

#### 4-2. Find a gene position from the annotation file

Use the annotation file to locate the genomic coordinates of your gene:

```bash
## Find the gene in the GTF file
zcat GRCh38.gtf.gz  | grep $GENE -m 1 -w -i 
```

Example output:

```
22	ensembl_havana	gene	43132209	43143398	.	-	.	gene_id "ENSG00000100294"; gene_version "14"; gene_name "MCAT"; gene_source "ensembl_havana"; gene_biotype "protein_coding";
```

From this line, the relevant coordinates are:

* **Column 1:** Chromosome (`22`)
* **Column 4:** Gene start position (`43132209`)
* **Column 5:** Gene end position (`43143398`)

#### 4-3. Get the reference sequence of the gene

You can now extract the gene sequence using `samtools faidx`. Specify the coordinates in the **`chr:start-end`** format and add them at the end of the command, like this:

```bash
samtools faidx GRCh38.chr$CHR.fa 22:43132209-43143398
```

This will output the DNA sequence of the gene directly from the reference genome:

```
>22:43132209-43143398
TTGGAATGTCTCATACTTAATATTGGCGCAGGAGCTGCTCTGAGGACGGGGCATGGAGCC
AGGGGTCAGCTCCGAGGCAGGTATGTGCTGTGCTCCCTCTGGCGCCCCGCAGACCCGCAG
TCCCAGTGGGTGACCAGGGTGTTCCTCCATGGTTCCACCCCTAGGACCAGGGCCTCAGTC
GCCCTCCCTACCTGGCACTCCCCACACCCCGCACCTCACTCAAGGACCTTTCTACCAGAA
...
CCTGGCTGCCCTGGCCCGGGAAGAGCAGCACGGAGCACTGGCCCGGCATTCGCCGCTCCG
TCGCCGCCCAGGGCGCCTCCTCCTCCGCCCCGGTCGCATCTCGCAGCAGCTCCGCTACAC
CCTGGGCGCCCGGCGGAGGCACCGGGAAGCTCGAGGCGCCGCGGCGGTAGCTGGCGCCCA
AGCCCCTGACCCACGCTACCCGTGCGACCCGGACGCTCATGGTCGGACACCTGCCCGCGC
GCGTTACCGTGGCGACCGAGGCCCGACTGC
```

Well done! This is the reference sequence of the gene you selected.



## 5. Practice

Try these exercises on your own:

1. Find the genomic coordinates of the gene with **gene ID** `ENSG00000141510`.
2. Download and index the chromosome that contains `ENSG00000141510`.
3. Extract the DNA sequence of `ENSG00000141510`.
4. Determine the **gene name** corresponding to `ENSG00000141510`. Which file did you use to find this information?

<details>

<summary>Solutions</summary>

1.

```bash
## Set the gene ID
GENE=ENSG00000141510
## Find the coordinate
zcat GRCh38.gtf.gz | grep $GENE -i -w -m 1 
```

```
17	ensembl_havana	gene	7661779	7687546	.	-	.	gene_id "ENSG00000141510"; gene_version "20"; gene_name "TP53"; gene_source "ensembl_havana"; gene_biotype "protein_coding";
```

2.

```bash
## Set the chromosome
CHR=17
## Download the reference genome of chromosome 17
wget -O GRCh38.chr$CHR.fa.gz https://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.chromosome.$CHR.fa.gz
## Decompress the FASTA file
gzip -d GRCh38.*.fa.gz

## Load samtools
module load gcc-libs samtools
## Index the fasta file
samtools faidx GRCh38.chr$CHR.fa
```

3.

```bash
samtools faidx GRCh38.chr$CHR.fa 17:7661779-7687546
```

```
>17:7661779-7687546
gagacagagtctcactctgttgcacaggctggagtgcagtggcacaatctctgctcactg
caacctcctcctccctggttaagagatcctcctgcctcagcccccttagtagctgggatt
acaggcgtgggccaccactgccaggctaatttttgtatttttagtagagatgggatttcg
ctatgttggccaggctgtcttgaactcctgacctcaggtgatccacctgccttggcctAA
...
ccccacccccagccccaGCGATTTTCCCGAGCTGAAAATACACGGAGCCGAGAGCCCGTG
ACTCAGAGAGGACTCATCAAGTTCAGTCAGGAGCTTACCCAATCCAGGGAAGCGTGTCAC
CGTCGTGGAAAGCACGCTCCCAGCCCGAACGCAAAGTGTCCCCGGAGCCCAGCAGCTACC
TGCTCCCTGGACGGTGGCTCTAGACTTTTGAGAAGCTCAAAACTTTTAGCGCCAGTCTTG
AGCACATGGGAGGGGAAAACCCCAATCC
```

4\.

The gene name is _**TP53**_. The annotation (GTF) file provides both the `gene_id` and `gene_name`.



</details>



Thank you for following along! If you’re interested, please consider participating in the [survey](https://forms.cloud.microsoft/e/3DQD321xMg), so we can improve and tailor future workshops for you.

[^1]: Bash prompt
