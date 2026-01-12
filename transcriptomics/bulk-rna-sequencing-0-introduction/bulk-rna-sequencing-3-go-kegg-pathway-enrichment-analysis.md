---
icon: dna
---

# Bulk RNA sequencing #3: GO/KEGG Pathway enrichment analysis

In the previous session,  you identified differentially expressed genes (DEGs) using [DESeq2](https://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html). Using the list of differentially expressed genes (DEGs), you can run pathway enrichment analysis to figure out which process or pathway the DEGs are involved in.

This session starts from the result of previous session, `res`. R package [clusterProfiler](https://bioconductor.org/packages/release/bioc/html/clusterProfiler.html) is used for enrichment analysis.



Let's start with installing the required packages.

```
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("clusterProfiler")
BiocManager::install("org.Hs.eg.db")
BiocManager::install("fgsea")
BiocManager::install("pathview")
```

Now let's load the packages and load the differential expression analysis result into `res`.

```r
library(DESeq2)
library(clusterProfiler)
library(org.Hs.eg.db)  # For human annotations, for mouse, use 'org.Mm.eg.db'
library(fgsea)
library(pathview)

# Remove any NAs in 'res'
res <- res[!is.na(res$padj) & !is.na(res$log2FoldChange), ]
```

## GO

**Gene Ontology (GO) terms** are standardized labels from the **Gene Ontology** that describe a gene’s role in terms of its **biological process**, **molecular function**, or **cellular component**, helping to consistently annotate and interpret gene functions across species.&#x20;

```r
# Get list of significant DEGs
de_genes <- rownames(res[res$padj < 0.05, ])

# GO enrichment
go_enrich <- enrichGO(gene = de_genes,
                      OrgDb = org.Hs.eg.db,
                      keyType = "ENSEMBL",  
                      ont = "BP",  # Biological Process
                      pAdjustMethod = "BH",
                      pvalueCutoff = 0.05,
                      qvalueCutoff = 0.2)

# Visualize and save into files
png("GOenrich_BP_Top20_dotplot.png", width=600, height=900, dpi=300)
dotplot(go_enrich, showCategory = 20) ## Adjust the number of GO terms as you wish
dev.off()

png("GOenrich_BP_Top20_barplot.png", width=600, height=900, dpi=300)
barplot(go_enrich, showCategory = 20)
dev.off()
```

<details>

<summary>GO dotplot example (To be added)</summary>



</details>

## KEGG

**Kyoto Encyclopedia of Genes and Genomes (KEGG)** is a database that maps genes to **biological pathways**, such as metabolism, signaling, and disease processes, allowing researchers to understand how **groups of genes interact in functional systems**.

```r
# Convert gene symbols to ENTREZ IDs
# enrichKEGG() can only take ENTREZ IDs as input
de_genes_entrez <- bitr(de_genes, fromType = "ENSEMBL", 
                        toType = "ENTREZID", OrgDb = org.Hs.eg.db)

kegg_enrich <- enrichKEGG(gene = de_genes_entrez$ENTREZID,
                          organism = "hsa",
                          pvalueCutoff = 0.1,
                          pAdjustMethod = "BH")

png("KEGGenrich_BP_Top20_dotplot.png", width=600, height=900, dpi=300)
dotplot(kegg_enrich, showCategory = 15)
dev.off()

# Get ENTREZ IDs and fold changes
gene_data <- res$log2FoldChange
names(gene_data) <- mapIds(org.Hs.eg.db, keys = rownames(res), 
                           column = "ENTREZID", keytype = "ENSEMBL")

# Visualize specific KEGG pathway (e.g., pathway ID "04110" for cell cycle)
hsas <- head(rownames(kegg_enrich@result)) ## Get pathway IDs of top 6 KEGG pathways
for (hsa in hsas){
    pathview(gene.data = gene_data,
        pathway.id = hsa,
        species = "hsa")
}
```

<details>

<summary>KEGG dotplot example (To be added)</summary>



</details>

If you don't get any specific pathways from your data, you can try applying more lenient statistical significance such as setting `pvalueCutoff = 0.4`  and see which pathways have the highest significance.

