# Part 3: Visualization

### Heatmap

We will now generate a heatmap to visualize expression patterns of significant genes across samples.

Install and load the `pheatmap` package, which is used to draw heatmaps in R.

```r
# Install pheatmap if not installed
if (!requireNamespace("pheatmap", quietly = TRUE)) {
  BiocManager::install("pheatmap", force=TRUE)
}
```

```
library(pheatmap)
```

Extract the names of significantly differentially expressed genes from the results table.

```r
# Get significant gene names
sig_genes <- rownames(sig_res)
sig_genes
```

Select only the significant genes from the count matrix for visualization.

```r
# Extract the significant genes from the raw count data table
mat <- count_data
mat
```

Apply variance stabilizing transformation (`vst()`) to normalize the data and reduce dependence on sequencing depth.

```r
# Normalize the raw counts
vsd <- vst(dds, blind = FALSE)
mat_norm <- assay(vsd)[sig_genes, ]
mat_norm
```

Scale each gene across samples so that differences in expression patterns are easier to visualize.

```r
# Scale the normalized data
mat_scaled <- t(scale(t(mat_norm)))
mat_scaled
```

Generate a heatmap with clustering for both genes and samples.

```r
# Draw heatmap
pheatmap(mat_scaled,
         cluster_rows = TRUE, # genees
         cluster_cols = TRUE, # samples
         show_rownames = TRUE)
```

<figure><img src="../../.gitbook/assets/heatmap_sig (1).png" alt=""><figcaption></figcaption></figure>

To save the heatmap in a png format, simply add `filename = 'result/heatmap_sig.png'` option.

```r
pheatmap(mat_scaled,
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         show_rownames = TRUE,
         filename = "result/heatmap_sig.png")
```

You can download the heatmap from `result` directory.



### Volcano plot

We will create a volcano plot to visualize differential expression results, highlighting significant genes.

Install and load packages for plotting (`ggplot2`) and for adding non-overlapping labels (`ggrepel`).

```r
# Install ggplot2 if not installed
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  BiocManager::install("ggplot2", force=TRUE)
}
# Install ggrepel if not installed
if (!requireNamespace("ggrepel", quietly = TRUE)) {
  BiocManager::install("ggrepel", force=TRUE)
}
```

```r
library(ggplot2)
library(ggrepel)
```

Classify genes into “Up”, “Down”, or “Not Sig” based on adjusted p-value and fold change thresholds and add it as a column in `res`.

```r
# Set default as "Not Sig"
res$significance <- "Not Sig"
# Mark as "Up" if padj < 0.05 and log2FC > 1
res$significance[res$padj < 0.05 & res$log2FoldChange > 1] <- "Up"
# Mark as "Down" if padj < 0.05 and log2FC < -1
res$significance[res$padj < 0.05 & res$log2FoldChange < -1] <- "Down"
head(res)
```

Plot fold change against statistical significance, with colors indicating gene categories and dashed lines showing thresholds.

```r
# Plot volcano plot
ggplot(res, aes(x = log2FoldChange, y = -log10(padj), color = significance)) +
  geom_point(alpha = 0.7) +
  scale_color_manual(values = c("blue", "grey", "red")) +
  theme_minimal() +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed")
```

<figure><img src="../../.gitbook/assets/volcano_plot.png" alt=""><figcaption></figcaption></figure>

Select the most significant genes (lowest adjusted p-values) and stores their names for labeling on the plot. In this example, all the genes with padj < 0.05 was used, but you can change the number of genes you want to show label of by changing `nrow(sig_res)` into the desired number.

```r
# Get the list of genes with padj < 0.05 for labeling
top <- res[order(res$padj), ][1:nrow(sig_res), ]
top$gene <- rownames(top)
```

Add labels to the genes with padj < 0.05 while preventing overlap, making key genes easier to identify.

```r
# Plot volcano plot with the significant genes label
ggplot(res, aes(x = log2FoldChange, y = -log10(padj), color = significance)) +
  geom_point(alpha = 0.7) +
  scale_color_manual(values = c("blue", "grey", "red")) +
  theme_minimal() +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed")+
  geom_point(alpha = 0.7) +
  geom_text_repel(data = top, aes(label = gene), size = 3) 
```

<figure><img src="../../.gitbook/assets/volcano_plot_sig (1).png" alt=""><figcaption></figcaption></figure>

Save the volcano plot in the `result` directory.

```r
# Save the volcano plot
ggsave("result/volcano_plot_sig.png", width = 6, height = 5, dpi = 300)
```





