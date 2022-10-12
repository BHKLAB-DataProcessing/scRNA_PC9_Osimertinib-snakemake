library(GEOquery)
library(SummarizedExperiment)

setwd("/results/")
getGEOSuppFiles("GSE150949")
files = list.files("./GSE150949/")
for (i in files) {
  gunzip(paste("./GSE150949/",i,sep = ""))
}
table <- read.table("./GSE150949/GSE150949_pc9_count_matrix.csv",sep = ",",header = TRUE,row.names = 1)
metadata <- read.table("./GSE150949/GSE150949_metaData_with_lineage.txt",sep="\t")
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