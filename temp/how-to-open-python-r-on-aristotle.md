---
hidden: true
---

# How to open Python/R on Aristotle

##

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
