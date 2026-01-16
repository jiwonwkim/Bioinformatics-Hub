---
description: This taster workshop is for IoO Lates mini workshop on 29th January 2026.
icon: '0'
---

# Aristotle: Bioinformatics workshop taster

## Welcome to bioinformatics taster session!

In this session, we are going to learn:

1. What is a remote server
2. How to access a remote server (Aristotle)
3. How to open R/Python on a remote server
4. How to run a code on a remote server



## What is a remote server?

A **remote server** is a powerful computer located elsewhere that you can access over the internet. It has lots of storage and processing power, so it can handle big bioinformatics tasks like analyzing genomes, aligning sequences, and more.

You can connect to a remote server from your own computer (desktop or laptop) using tools like **SSH**, a secure login method. Once connected, you can run commands and programs on the server. In most cases, interacting with a remote server is done through the **command-line interface (CLI)**, which means there are no graphical icons— everything is typed as commands. (Don't panic!)



## UCL Aristotle

**UCL Aristotle** is a Linux-based compute service for practicing the command-line interface. Anyone with a UCL user ID and within the UCL institutional firewall can access Aristotle with the following command on **Terminal (macOS)** or **Powershell (Windows)**:

```bash
ssh smgxxxx@aristotle.rc.ucl.ac.uk
```

`smgxxxx` is your UCL ID.

After running the command, you'll be asked to enter your password:

```
smgxxxx@aristotle.rc.ucl.ac.uk's password: 
```

Type your UCL password in. Nothing will appear on the screen while typing—this is normal. Just type it and press Enter.

If you enter it incorrectly, you’ll see:

```
Permission denied, please try again.
smgxxxx@aristotle.rc.ucl.ac.uk's password:
```

and you can try again.

Once the correct password is entered, you will now see the **bash prompt**, which usually starts with `bash-4.2$`:

<pre><code>Last failed login: Mon Jan 12 15:22:57 GMT 2026 from xx.xx.x.x on ssh:notty
There were 1 failed login attempts since the last successful login.
Last login: Thu Jan  8 13:33:07 2026 from xx.xx.x.x
-bash-4.2<a data-footnote-ref href="#user-content-fn-1">$</a> 
</code></pre>

This means you are now logged into Aristotle and can run commands on the remote server.

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



## How to download reference genome

```bash
## Make directory under $HOME
mkdir -p $HOME/reference
cd $HOME/reference

## Set the chromosome
chr=22
## Download the compressed files
wget -O GRCh38.chr${chr}.fa.gz https://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.chromosome.${chr}.fa.gz
wget -O GRCh38.gtf.gz https://ftp.ensembl.org/pub/release-115/gtf/homo_sapiens/Homo_sapiens.GRCh38.115.chr.gtf.gz

## Unzip the compressed files
gzip -d GRCh38.*.gz

## Open the file
less GRCh38.chr${chr}.fa
```



### Index the reference genome

```bash
module load gcc-libs samtools
samtools faidx GRCh38.chr.${chr}.fa
```





## How to open Python/R on Aristotle

### Python

To open Python prompt, you have to load the python module first.

```bash
module load gcc-libs python3/recommended
python3
```

```
Python 3.9.10 (main, Feb  9 2022, 13:29:07) 
[GCC 4.9.2] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
```

If you see `>>>`, this means you're now on python prompt, and the commands must be in Python syntax.&#x20;

For example, if you wish to print a string "Hello!", you now have to type `print("Hello!")` instead of `echo "Hello!"`, which is a bash syntax.

If you wish to exit the prompt:

```python
>>> quit()
```

will take you back to the bash prompt.

### R

Opening R prompt is similar to opening a Python one, you need to load the r module first.

```bash
module load r/recommended
R
```

```
R version 4.2.0 (2022-04-22) -- "Vigorous Calisthenics"
Copyright (C) 2022 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> 
```

If you see `>`, this means you're now on R prompt. Again, the syntax now has to be adjusted to R.&#x20;

If you wish to exit the prompt, type the following command:

```r
q()
```

```
Save workspace image? [y/n/c]: 
```

and type `n` in not to save workspace image.&#x20;



## Practice

### Getting reverse complement sequence on R

Now, let's practice running code on Aristotle.

Use large-language model of your choice to get the following R code:

(If you can, try write it yourself and troubleshoot.)

1. A function which generates random 20bp-long DNA sequence
2. A function which returns a reverse complement sequence of a DNA sequence
3. A function which returns a GC content of a DNA sequence
4. A function which returns counts of each base in a DNA sequence



<details>

<summary>Example solution</summary>

```r
## 1. Random DNA generation
# Define nucleotides
nucleotides <- c("A", "T", "G", "C")

# Generate a random 20 bp sequence
dna_seq <- paste0(sample(nucleotides, 20, replace = TRUE), collapse = "")

# Print the sequence
dna_seq

## 2. Reverse complement
# Define a function to get reverse complement
reverse_complement <- function(seq) {
  # Complement each nucleotide
  comp <- chartr("ATGC", "TACG", seq)
  # Reverse the complemented sequence
  rev_comp <- paste(rev(strsplit(comp, NULL)[[1]]), collapse = "")
  return(rev_comp)
}

# Get reverse complement
rev_comp_seq <- reverse_complement(dna_seq)

# Print reverse complement
rev_comp_seq

## 3. GC content
# Function to calculate GC content
gc_content <- function(seq) {
  # Split sequence into individual nucleotides
  nucleotides <- strsplit(seq, NULL)[[1]]
  # Count G and C
  gc_count <- sum(nucleotides %in% c("G", "C"))
  # Calculate GC percentage
  gc_percent <- (gc_count / length(nucleotides)) * 100
  return(gc_percent)
}

# Calculate GC content
gc_content(dna_seq)

## 4. Base count
# Split sequence into individual nucleotides
nucleotides <- strsplit(dna_seq, NULL)[[1]]

# Count each base
base_counts <- table(nucleotides)

# Print counts
base_counts
```

</details>



Thank you for following! If you are interested, please consider participating in the [survey](https://forms.cloud.microsoft/e/3DQD321xMg), so that we can deliver optimized workshops for you.&#x20;



[^1]: Bash prompt
