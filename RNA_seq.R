################################################################################
#                    BULK RNA-SEQ ANALYSIS TUTORIAL
#                    Complete Workflow from Counts to Results
################################################################################
#
# This tutorial covers:
# 1. Data preparation and quality control
# 2. Normalization and exploratory data analysis
# 3. Differential expression analysis (DESeq2 and edgeR)
# 4. Visualization (PCA, heatmaps, volcano plots, MA plots)
# 5. Functional enrichment analysis
#
# Author: Cancer Epigenetics Study
# Date: November 2025
################################################################################

# Install required packages (run once)
# if (!require("BiocManager", quietly = TRUE))
#     install.packages("BiocManager")
# BiocManager::install(c("DESeq2", "edgeR", "limma", "biomaRt", "clusterProfiler",
#                        "EnhancedVolcano", "ComplexHeatmap", "org.Hs.eg.db"))
# install.packages(c("pheatmap", "ggplot2", "dplyr", "tidyr", "RColorBrewer",
#                    "ggrepel", "factoextra", "corrplot"))

# Load required libraries
library(DESeq2)
library(edgeR)
library(limma)
library(ggplot2)
library(dplyr)
library(tidyr)
library(pheatmap)
library(RColorBrewer) 
library(ggrepel)

################################################################################
# PART 1: DATA PREPARATION
################################################################################

cat("=== PART 1: DATA PREPARATION ===\n")

# Option A: Load your own count matrix
# counts <- read.table("path/to/counts.txt", header=TRUE, row.names=1)
# Make sure rows = genes, columns = samples

# Option B: Create example data for this tutorial
set.seed(123)
n_genes <- 5000
n_samples_per_group <- 6

# Simulate count matrix (genes x samples)
# Control samples have baseline expression
# Treatment samples have differential expression for ~500 genes
counts_control <- matrix(
  rnbinom(n_genes * n_samples_per_group, mu = 100, size = 10),
  nrow = n_genes,
  ncol = n_samples_per_group
)

counts_treatment <- matrix(
  rnbinom(n_genes * n_samples_per_group, mu = 100, size = 10),
  nrow = n_genes,
  ncol = n_samples_per_group
)

# Introduce differential expression in 500 genes (10%)
de_genes <- sample(1:n_genes, 500)
# Upregulated genes (250)
counts_treatment[de_genes[1:250], ] <- counts_treatment[de_genes[1:250], ] * 3
# Downregulated genes (250)
counts_treatment[de_genes[251:500], ] <- counts_treatment[de_genes[251:500], ] / 3

# Combine into single count matrix
counts <- cbind(counts_control, counts_treatment)
rownames(counts) <- paste0("Gene_", 1:n_genes)
colnames(counts) <- c(paste0("Control_", 1:n_samples_per_group),
                      paste0("Treatment_", 1:n_samples_per_group))

# Create sample metadata (colData)
coldata <- data.frame(
  sample = colnames(counts),
  condition = factor(rep(c("Control", "Treatment"), each = n_samples_per_group)),
  batch = factor(rep(1:2, times = n_samples_per_group)),
  row.names = colnames(counts)
)

cat("Count matrix dimensions:", nrow(counts), "genes x", ncol(counts), "samples\n")
cat("Sample information:\n")
print(coldata)

################################################################################
# PART 2: QUALITY CONTROL
################################################################################

cat("\n=== PART 2: QUALITY CONTROL ===\n")

# 2.1 Check library sizes
library_sizes <- colSums(counts)
cat("Library sizes (total counts per sample):\n")
print(library_sizes)

# Plot library sizes
barplot(library_sizes / 1e6,
        las = 2,
        main = "Library Sizes",
        ylab = "Millions of reads",
        col = c(rep("blue", n_samples_per_group), rep("red", n_samples_per_group)),
        names.arg = colnames(counts),
        cex.names = 0.7)
legend("topright", legend = c("Control", "Treatment"),
       fill = c("blue", "red"))

# 2.2 Count distribution
cat("\nGenes with zero counts across all samples:", 
    sum(rowSums(counts) == 0), "\n")

# Distribution of log counts
log_counts <- log2(counts + 1)
boxplot(log_counts,
        las = 2,
        main = "Distribution of Log2 Counts",
        ylab = "log2(counts + 1)",
        col = c(rep("lightblue", n_samples_per_group), 
                rep("lightcoral", n_samples_per_group)),
        names = colnames(counts),
        cex.axis = 0.7)

# 2.3 Filter low-count genes
# Keep genes with at least 10 counts in at least 3 samples
keep <- rowSums(counts >= 10) >= 3
counts_filtered <- counts[keep, ]
cat("Genes retained after filtering:", nrow(counts_filtered), 
    "out of", nrow(counts), "\n")

################################################################################
# PART 3: DIFFERENTIAL EXPRESSION ANALYSIS WITH DESeq2
################################################################################

cat("\n=== PART 3: DESeq2 ANALYSIS ===\n")

# 3.1 Create DESeq2 object
dds <- DESeqDataSetFromMatrix(
  countData = counts_filtered,
  colData = coldata,
  design = ~ condition
)

cat("DESeq2 object created with", nrow(dds), "genes\n")

# 3.2 Run DESeq2 pipeline
dds <- DESeq(dds)

# 3.3 Get results
res <- results(dds, 
               contrast = c("condition", "Treatment", "Control"),
               alpha = 0.05)

cat("DESeq2 analysis complete\n")
cat("Summary of results:\n")
summary(res)

# Order by adjusted p-value
res_ordered <- res[order(res$padj), ]
cat("\nTop 10 differentially expressed genes:\n")
print(head(res_ordered, 10))

# 3.4 Extract normalized counts
normalized_counts <- counts(dds, normalized = TRUE)

################################################################################
# PART 4: ALTERNATIVE APPROACH - edgeR
################################################################################

cat("\n=== PART 4: edgeR ANALYSIS ===\n")

# 4.1 Create DGEList object
y <- DGEList(counts = counts_filtered, group = coldata$condition)

# 4.2 Calculate normalization factors (TMM)
y <- calcNormFactors(y, method = "TMM")
cat("Normalization factors:\n")
print(y$samples)

# 4.3 Design matrix
design <- model.matrix(~ condition, data = coldata)

# 4.4 Estimate dispersion
y <- estimateDisp(y, design)
cat("Common dispersion:", y$common.dispersion, "\n")

# Plot biological coefficient of variation
plotBCV(y, main = "Biological Coefficient of Variation")

# 4.5 Differential expression testing
fit <- glmQLFit(y, design)
qlf <- glmQLFTest(fit, coef = 2)

# Get top tags
topTags_edgeR <- topTags(qlf, n = Inf)
cat("\nTop 10 DE genes from edgeR:\n")
print(topTags_edgeR$table[1:10, ])

################################################################################
# PART 5: EXPLORATORY DATA ANALYSIS
################################################################################

cat("\n=== PART 5: EXPLORATORY DATA ANALYSIS ===\n")

# 5.1 Principal Component Analysis (PCA)
vsd <- vst(dds, blind = FALSE)  # Variance stabilizing transformation

# PCA plot
pca_data <- plotPCA(vsd, intgroup = "condition", returnData = TRUE)
percent_var <- round(100 * attr(pca_data, "percentVar"))

ggplot(pca_data, aes(x = PC1, y = PC2, color = condition, label = name)) +
  geom_point(size = 4) +
  geom_text_repel(size = 3) +
  xlab(paste0("PC1: ", percent_var[1], "% variance")) +
  ylab(paste0("PC2: ", percent_var[2], "% variance")) +
  theme_bw() +
  theme(legend.position = "top") +
  ggtitle("PCA of RNA-seq Samples") +
  scale_color_manual(values = c("Control" = "blue", "Treatment" = "red"))

# 5.2 Sample-to-sample distance heatmap
sample_dists <- dist(t(assay(vsd)))
sample_dist_matrix <- as.matrix(sample_dists)
rownames(sample_dist_matrix) <- vsd$sample
colnames(sample_dist_matrix) <- NULL

colors <- colorRampPalette(rev(brewer.pal(9, "Blues")))(255)
pheatmap(sample_dist_matrix,
         clustering_distance_rows = sample_dists,
         clustering_distance_cols = sample_dists,
         col = colors,
         main = "Sample-to-Sample Distances")

# 5.3 Heatmap of top variable genes
top_var_genes <- head(order(rowVars(assay(vsd)), decreasing = TRUE), 50)
mat <- assay(vsd)[top_var_genes, ]
mat <- t(scale(t(mat)))  # Z-score normalization

# Annotation for samples
annotation_col <- data.frame(
  Condition = coldata$condition,
  row.names = colnames(mat)
)

pheatmap(mat,
         annotation_col = annotation_col,
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         show_rownames = FALSE,
         show_colnames = TRUE,
         main = "Top 50 Most Variable Genes",
         color = colorRampPalette(c("blue", "white", "red"))(50),
         fontsize_col = 8)

# 5.4 Heatmap of DE genes
sig_genes <- rownames(res_ordered)[which(res_ordered$padj < 0.05 & 
                                         abs(res_ordered$log2FoldChange) > 1)]
if(length(sig_genes) > 100) {
  sig_genes <- sig_genes[1:100]  # Top 100 DE genes
}

if(length(sig_genes) > 0) {
  mat_de <- assay(vsd)[sig_genes, ]
  mat_de <- t(scale(t(mat_de)))
  
  pheatmap(mat_de,
           annotation_col = annotation_col,
           cluster_rows = TRUE,
           cluster_cols = TRUE,
           show_rownames = FALSE,
           show_colnames = TRUE,
           main = paste("Top", length(sig_genes), "DE Genes (padj < 0.05, |log2FC| > 1)"),
           color = colorRampPalette(c("blue", "white", "red"))(50),
           fontsize_col = 8)
}

################################################################################
# PART 6: VISUALIZATION OF DIFFERENTIAL EXPRESSION
################################################################################

cat("\n=== PART 6: DIFFERENTIAL EXPRESSION VISUALIZATION ===\n")

# 6.1 Volcano Plot
res_df <- as.data.frame(res)
res_df$gene <- rownames(res_df)
res_df$significant <- ifelse(res_df$padj < 0.05 & abs(res_df$log2FoldChange) > 1,
                              ifelse(res_df$log2FoldChange > 1, "Up", "Down"),
                              "Not Sig")

# Count significant genes
cat("Upregulated genes (padj < 0.05, log2FC > 1):", 
    sum(res_df$significant == "Up", na.rm = TRUE), "\n")
cat("Downregulated genes (padj < 0.05, log2FC < -1):", 
    sum(res_df$significant == "Down", na.rm = TRUE), "\n")

# Create volcano plot
ggplot(res_df, aes(x = log2FoldChange, y = -log10(padj), color = significant)) +
  geom_point(alpha = 0.6, size = 1.5) +
  scale_color_manual(values = c("Up" = "red", "Down" = "blue", "Not Sig" = "gray")) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "black") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "black") +
  theme_bw() +
  theme(legend.position = "top") +
  labs(title = "Volcano Plot",
       x = "log2 Fold Change",
       y = "-log10 Adjusted P-value",
       color = "Expression") +
  xlim(c(-6, 6))

# 6.2 MA Plot (Mean vs Log2FC)
plotMA(res, ylim = c(-5, 5), main = "MA Plot")
abline(h = c(-1, 1), col = "red", lty = 2)

# 6.3 P-value distribution
hist(res$pvalue[res$baseMean > 1], 
     breaks = 50, 
     col = "skyblue",
     main = "Distribution of P-values",
     xlab = "P-value",
     border = "white")

# 6.4 Plot counts for top gene
top_gene <- rownames(res_ordered)[1]
plotCounts(dds, gene = top_gene, intgroup = "condition",
           main = paste("Normalized counts for", top_gene))

################################################################################
# PART 7: EXPORT RESULTS
################################################################################

cat("\n=== PART 7: EXPORTING RESULTS ===\n")

# 7.1 Create comprehensive results table
results_table <- as.data.frame(res_ordered) %>%
  mutate(
    gene = rownames(.),
    significant = padj < 0.05 & abs(log2FoldChange) > 1,
    regulation = case_when(
      padj < 0.05 & log2FoldChange > 1 ~ "Upregulated",
      padj < 0.05 & log2FoldChange < -1 ~ "Downregulated",
      TRUE ~ "Not significant"
    )
  ) %>%
  select(gene, baseMean, log2FoldChange, lfcSE, stat, pvalue, padj, 
         significant, regulation)

# Preview results
cat("\nFinal results table preview:\n")
print(head(results_table, 10))

# 7.2 Save results to CSV
# write.csv(results_table, file = "DESeq2_results.csv", row.names = FALSE)
# write.csv(normalized_counts, file = "normalized_counts.csv", row.names = TRUE)

# 7.3 Save significant genes only
sig_results <- results_table %>%
  filter(significant == TRUE) %>%
  arrange(padj)

cat("\nTotal significant genes:", nrow(sig_results), "\n")
# write.csv(sig_results, file = "significant_genes.csv", row.names = FALSE)

################################################################################
# PART 8: GENE SET ENRICHMENT (OPTIONAL)
################################################################################

cat("\n=== PART 8: GENE SET ENRICHMENT (OPTIONAL) ===\n")
cat("For real data, you would perform:\n")
cat("- GO (Gene Ontology) enrichment\n")
cat("- KEGG pathway analysis\n")
cat("- GSEA (Gene Set Enrichment Analysis)\n")
cat("\nExample code (requires annotation):\n")
cat("# library(clusterProfiler)\n")
cat("# library(org.Hs.eg.db)\n")
cat("# \n")
cat("# # Convert gene IDs to Entrez\n")
cat("# sig_genes_entrez <- bitr(sig_results$gene, \n")
cat("#                          fromType = 'SYMBOL',\n")
cat("#                          toType = 'ENTREZID',\n")
cat("#                          OrgDb = org.Hs.eg.db)\n")
cat("# \n")
cat("# # GO enrichment\n")
cat("# ego <- enrichGO(gene = sig_genes_entrez$ENTREZID,\n")
cat("#                 OrgDb = org.Hs.eg.db,\n")
cat("#                 ont = 'BP',\n")
cat("#                 pAdjustMethod = 'BH',\n")
cat("#                 qvalueCutoff = 0.05)\n")
cat("# \n")
cat("# dotplot(ego, showCategory = 20)\n")

################################################################################
# PART 9: COMPARISON OF DESeq2 vs edgeR
################################################################################

cat("\n=== PART 9: COMPARING DESeq2 AND edgeR ===\n")

# Extract significant genes from both methods
deseq2_sig <- rownames(res_ordered)[which(res_ordered$padj < 0.05)]
edger_sig <- rownames(topTags_edgeR$table)[which(topTags_edgeR$table$FDR < 0.05)]

# Overlap analysis
overlap <- intersect(deseq2_sig, edger_sig)
cat("DESeq2 significant genes:", length(deseq2_sig), "\n")
cat("edgeR significant genes:", length(edger_sig), "\n")
cat("Overlap between methods:", length(overlap), "\n")
cat("Agreement:", round(length(overlap) / length(union(deseq2_sig, edger_sig)) * 100, 2), "%\n")

################################################################################
# SUMMARY AND NEXT STEPS
################################################################################

cat("\n" %+% paste(rep("=", 70), collapse = "") %+% "\n")
cat("ANALYSIS COMPLETE!\n")
cat(paste(rep("=", 70), collapse = "") %+% "\n\n")

cat("Summary:\n")
cat("- Total genes analyzed:", nrow(counts_filtered), "\n")
cat("- Samples analyzed:", ncol(counts_filtered), "\n")
cat("- Significant genes (DESeq2, padj < 0.05):", sum(res$padj < 0.05, na.rm = TRUE), "\n")
cat("- Upregulated (log2FC > 1):", sum(res_df$significant == "Up", na.rm = TRUE), "\n")
cat("- Downregulated (log2FC < -1):", sum(res_df$significant == "Down", na.rm = TRUE), "\n")

cat("\nNext steps:\n")
cat("1. Validate results with qRT-PCR for top candidates\n")
cat("2. Perform functional enrichment analysis\n")
cat("3. Investigate biological pathways\n")
cat("4. Compare with published datasets\n")
cat("5. Plan follow-up experiments\n")

cat("\nFiles ready to export:\n")
cat("- results_table: All genes with statistics\n")
cat("- sig_results: Only significant genes\n")
cat("- normalized_counts: Normalized expression matrix\n")

cat("\n✓ Tutorial complete! Your data is ready for downstream analysis.\n")

################################################################################
# ADDITIONAL RESOURCES
################################################################################

cat("\n=== ADDITIONAL RESOURCES ===\n")
cat("DESeq2 vignette: https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html\n")
cat("edgeR guide: https://bioconductor.org/packages/release/bioc/vignettes/edgeR/inst/doc/edgeRUsersGuide.pdf\n")
cat("RNA-seq best practices: https://www.bioconductor.org/help/course-materials/2016/CSAMA/lab-3-rnaseq/rnaseq_gene_CSAMA2016.html\n")
