library(SummarizedExperiment)
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
input_dir <- args[1]
output_dir <- args[2]

table <- read.table(file.path(input_dir, "GSE150949_pc9_count_matrix.csv"),sep = ",",header = TRUE,row.names = 1)
metadata <- read.table(file.path(input_dir, "GSE150949_metaData_with_lineage.txt"),sep="\t")
new_metadata <- c()
for (i in rownames(metadata)) {
  new_metadata <- append(new_metadata,gsub("-",".",i))
}
rownames(metadata) <- new_metadata

time_points <- unique(metadata$time_point)
j = 1

experiment_list <- list()
for (i in time_points) {
  print(i)
  cells <- rownames(metadata[metadata$time_point==i,])
  matrix <- select(table,cells)
  experiment <- SummarizedExperiment(assay=matrix,colData = metadata[cells,],rowData = data.frame(gene=rownames(matrix)))
  experiment_list[j] <- experiment
  j <- j + 1
}  
names(experiment_list) <- c("Day0","Day3","Day7","Day14")

saveRDS(experiment_list, file.path(output_dir, 'scRNA_PC9_Osimertinib.rds'))
