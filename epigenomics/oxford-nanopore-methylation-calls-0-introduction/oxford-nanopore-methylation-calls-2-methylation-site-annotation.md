---
icon: dna
---

# Oxford Nanopore methylation calls #2: Methylation site annotation

In the previous session, we used nf-core/methylong to check the methylation of bases from Nanopore reads. We are now going to extract high-confidence methylation sites and annotate them.



Let's start by filtering the methylation sites with coverage less than 5 and methylation fraction less than 80% out from the raw result.

## Filter methylation sites

```sh
# Set working directory
cd $HOME/projects/methylong

# For all samples in the samplesheet,
while read sample; do
    # Filter the sites with >5 coverage and >80% methylation 
    zcat result/ont/${sample}/pileup/${sample}.bed.gz | \
    awk '($10 > 5 && $11 > 80){print $0}' > result/ont/${sample}/pileup/${sample}.cov5.frac80.bed
    # Check the number of methylation sites
    wc -l result/ont/${sample}/pileup/${sample}.cov5.frac80.bed 
done < <(cut -f1 -d"," samplesheet.csv | tail -n +2)
```

The output will look like:

```
40645381 result/ont/AMD1/pileup/AMD1.cov5.frac80.bed
38884169 result/ont/DR1/pileup/DR1.cov5.frac80.bed
```

Meaning there are 40M and 38M high-confidence methylation sites, respectively.



## Annotate high-confidence methylation sites

### Extract promoter regions from GTF&#x20;

Before we annotate the sites, let's get the **promoter positions from GTF file**. If you don't have a GTF file, please see [here](../../getting-started/essential-downloading-reference-genome.md).

```sh
# Define promoter region as -2,000 ~ +200bp of transciption start site (TSS)
# and save the promoter regions as $HOME/ACFS/ref/GRCh38.promoters.bed
awk -F '\t' '$3 == "gene" {
  # extract gene_id from attributes field
  match($9, /gene_id "[^"]+"/, a)
  gene_id = (length(a) > 0) ? substr(a[0], 10, length(a[0])-10) : "NA"

  if ($7 == "+") {
    start = $4 - 2000; if (start < 0) start = 0
    end = $4 + 200
  } else {
    start = $5 - 200; if (start < 0) start = 0
    end = $5 + 2000
  }

  print $1, start, end, gene_id, 0, $7
}' OFS='\t' $HOME/ACFS/ref/GRCh38.gtf > $HOME/ACFS/ref/GRCh38.promoters.bed
```

### Intersect promoter regions with high-confidence methylation sites

Now that we have promoter regions, we are going to intersect the promoter regions with our methylated sites.

```sh
mkdir -p result/promoter_overlap
# Load bedtools
module unload gcc-libs
module load bedtools

# For all samples in the samplesheet,
while read sample; do
# Intersect the methylated sites with promoter regions
bedtools intersect -a result/ont/${sample}/pileup/${sample}.cov5.frac80.bed \
                   -b $HOME/ACFS/ref/GRCh38.promoters.bed -wa -wb \
                   > result/promoter_overlap/${sample}_me_promoter_overlap.bed
done < <(cut -f1 -d"," samplesheet.csv | tail -n +2)
```

### Summarize the intersection

Now to summarize the overlap, load R.

```sh
module -f unload compilers mpi gcc-libs
module load r/recommended
R
```

On R script, summarize the gene overlap and save the data into `${sample}_promoter_methylation_summary.tsv`.

```r
# Read in the samplesheet
samplesheet <- read.csv("samplesheet.csv", header=TRUE)

# For all samples in the samplesheet,
for (sample in samplesheet$sample){
    # Set input and file name
    fp1 <- paste0("result/promoter_overlap/",sample,"_me_promoter_overlap.bed")
    of1 <- paste0("result/promoter_overlap/",sample,"_promoter_methylation_summary.tsv")
    
    # Load input data into a dataframe
    df <- read.table(fp1, header = FALSE, sep = "\t", stringsAsFactors = FALSE)
    
    # Check column layout
    # V22 = gene_id, V11 = fraction_modified
    gene_id_col <- 22
    fraction_col <- 11
    
    # Clean and convert
    df$gene_id <- df[[gene_id_col]]
    df$frac_mod <- as.numeric(df[[fraction_col]])
    
    # Remove invalid (NA) values
    df_clean <- df[!is.na(df$frac_mod), ]
    
    # Summarize by gene_id
    summary_df <- aggregate(frac_mod ~ gene_id, data = df_clean, FUN = function(x) c(mean = mean(x), count = length(x)))
    
    # Unpack the result into two columns
    summary_df$mean_methylation <- summary_df$frac_mod[, "mean"]
    summary_df$methylation_count <- summary_df$frac_mod[, "count"]
    summary_df$frac_mod <- NULL
    
    summary_df_sorted <- summary_df[order(-summary_df$methylation_count), ]
    
    # Save summary
    write.table(summary_df_sorted, file = of1 , sep = "\t", row.names = FALSE, quote = FALSE)
}
```

The output file `AMD1_promoter_methylation_summary.tsv` is as follows:

```
$ head AMD1_promoter_methylation_summary.tsv

gene_id	mean_methylation	methylation_count
ENSG00000000003	95.5794520547945	73
ENSG00000000005	89.914	10
ENSG00000000419	96.4491995221027	837
...

```

This file contains promoter methylation data for individual genes, including mean methylation percentage and methylation site counts. You can identify genes with high methylation density in their promoter regions or elevated mean methylation levels. Apply filtering based on your criteria (e.g., methylation\_count > X or mean\_methylation > Y) as needed, and interpret the results in the context of gene regulation or epigenetic modifications.
