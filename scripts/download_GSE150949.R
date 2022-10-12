library(GEOquery)
args <- commandArgs(trailingOnly = TRUE)
work_dir <- args[1]

getGEOSuppFiles("GSE150949", makeDirectory=FALSE, baseDir=work_dir)

gunzip(file.path(work_dir, "GSE150949_pc9_count_matrix.csv.gz"))
gunzip(file.path(work_dir, "GSE150949_metaData_with_lineage.txt.gz"))

files = list.files(path=work_dir, pattern='*.gz$')
file.remove(file.path(work_dir, files))