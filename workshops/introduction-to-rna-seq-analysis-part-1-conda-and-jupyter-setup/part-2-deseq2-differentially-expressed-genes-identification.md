# Part 2: DESeq2: Differentially expressed genes identification

### Running DESeq2

Now, let's run differential expression analysis using an R package DESeq2.&#x20;

Start by making a project directory on your desktop.

```bash
## Make project directory
mkdir -p $HOME/projects/rnaseq
## Change into the project directory
cd $HOME/projects/rnaseq
```

Make `data` directory to store the count table, and `result` directory to store DESeq2 run results.

```bash
## Make subdirectories
mkdir data
mkdir result
```

Move the file explorer into the data directory and drag the `salmon.merged.gene_counts.tsv` file to move it into the directory. Move the file explorer back into the `rnaseq` directory and open an R notebook.

<figure><img src="../../.gitbook/assets/image (44).png" alt=""><figcaption></figcaption></figure>

Set the working directory.

```r
# Set working directory
setwd("~/projects/rnaseq")
```

#### Install libraries

We need a couple of libraries for differentially expressed genes (DEGs) identification.&#x20;

```r
# Create directory for R libraries
dir.create(path = Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)
```

**BiocManager** is an R package that provides a simple and reliable way to install and manage Bioconductor packages and their dependencies. Install and load BiocManager if not already installed using the code below.

```r
# Install BiocManager if not installed
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", lib = Sys.getenv("R_LIBS_USER"))
}
BiocManager::install(version = "3.22")

# Load BiocManager
library(BiocManager)
```

Now that BiocManager is installed, we will use it to install **DESeq2** and **org.Hs.eg.db**, which are, respectively, a package for differential expression analysis and a human gene annotation database. Similar to what we did before, please install these libraries on your system.

```r
# Install DESeq2 if not installed
if (!requireNamespace("DESeq2", quietly = TRUE)) {
  BiocManager::install("DESeq2", lib = Sys.getenv("R_LIBS_USER"))
}
# Install org.Hs.eg.db (human gene database) if not installed
if (!requireNamespace("org.Hs.eg.db", quietly = TRUE)) {
  BiocManager::install("org.Hs.eg.db", lib = Sys.getenv("R_LIBS_USER"), force=TRUE)
}
```

Once the installation is complete, load the `DESeq2` and `org.Hs.eg.db` libraries.

```r
# Load the libraries
library(DESeq2)
library(org.Hs.eg.db)
```

Now that the libraries are ready, we can begin **differential expression analysis (DEG identification)**.

#### Load the data

Set the path to your count table file:

```r
# Set the file path
file1 <- 'data/salmon.merged.gene_counts.tsv' 
```

\-------------------------------------------------------------

using `read.csv` and&#x20;

Import the count table into `count_data`



```r
# Read in raw gene count table and save it to count_data
count_data <- read.csv(file1, sep="\t", header=TRUE)
count_data <- count_data[!duplicated(count_data$gene_name), ]
rownames(count_data) <- count_data$gene_name
count_data = subset(count_data, select = -c(gene_name, gene_id))
```

Check if the count table is well imported into `count_data`.

```
head(count_data)
```



```r
# Generate metadata (contain sample names and conditions)
metadata <- data.frame(
	sample = colnames(count_data),  # sample name
	condition = sub("[0-9]+$", "", colnames(count_data)) # condition
)
# change rownames of metadata into sample names
rownames(metadata) <- metadata$sample 
```

```markdown
metadata
```

#### Run DESeq2

```r
###########################################
## 3. Run DESeq2 pairwise (GA vs NORMAL) ##
###########################################
# Convert count_data into appropriate format for DESeq2 run and save to dds
dds <- DESeqDataSetFromMatrix(countData = round(count_data), 
                              colData = metadata, 
                              design = ~ condition)
# Set Control group as refrence
dds$condition <- relevel(dds$condition, ref = "Control")    
# Run default DEG analysis with normalization                      
dds <- DESeq(dds)
# Extract differential expression of ALL the genes 
# (including the insignificant ones) to res
res <- results(dds)
# Omit any NA values in padj or log2FoldChange
res <- subset(res, !is.na(padj) & !is.na(log2FoldChange))
# Save the genes with Padj < 0.05 to sig_res (significant genes)
sig_res <- res[res$padj < 0.05,] 
```



#### Save data

```r
name='Treated_vs_Control'
of1 <- paste0("result/",name,"_DESeq2_Results.csv")
write.csv(res, of1, row.names = TRUE, quote = FALSE)
```

```r
of2 <- paste0("result/",name,"_DESeq2_Results_padj0.05.csv") 
write.csv(sig_res, of2, row.names = TRUE, quote = FALSE)
```

<figure><img src="../../.gitbook/assets/image (45).png" alt=""><figcaption></figcaption></figure>

You can download the significant DEG table from `result` directory.



`Treated_vs_Control_DESeq2_Results_padj0.05.csv`

<table data-full-width="true"><thead><tr><th>gene</th><th>baseMean</th><th>log2FoldChange</th><th>lfcSE</th><th>stat</th><th>pvalue</th><th>padj</th></tr></thead><tbody><tr><td><strong>LMCD1</strong></td><td>130.116911</td><td><strong>2.6717296</strong></td><td>0.59349932</td><td>4.50165568</td><td>6.74E-06</td><td><strong>0.00987641</strong></td></tr><tr><td><strong>EDN1</strong></td><td>78.1486286</td><td><strong>5.03592727</strong></td><td>1.17566667</td><td>4.28346522</td><td>1.84E-05</td><td><strong>0.01717116</strong></td></tr><tr><td><strong>NOX4</strong></td><td>50.8925357</td><td><strong>4.63850252</strong></td><td>0.87965212</td><td>5.27311017</td><td>1.34E-07</td><td><strong>0.0006238</strong></td></tr><tr><td><strong>DHRS2</strong></td><td>17.2594646</td><td><strong>4.02682742</strong></td><td>0.92447889</td><td>4.35578084</td><td>1.33E-05</td><td><strong>0.01425229</strong></td></tr><tr><td><strong>MMP15</strong></td><td>1628.26954</td><td><strong>0.69259116</strong></td><td>0.16609922</td><td>4.16974346</td><td>3.05E-05</td><td><strong>0.02390385</strong></td></tr><tr><td><strong>XYLT1</strong></td><td>1624.5707</td><td><strong>2.4763288</strong></td><td>0.58203059</td><td>4.25463684</td><td>2.09E-05</td><td><strong>0.01865176</strong></td></tr></tbody></table>

