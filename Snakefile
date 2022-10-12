from snakemake.remote.S3 import RemoteProvider as S3RemoteProvider
S3 = S3RemoteProvider(
    access_key_id=config["key"],
    secret_access_key=config["secret"],
    host=config["host"],
    stay_on_remote=False
)
prefix = config["prefix"]
filename = config["filename"]

rule last_step:
    input:
        S3.remote(prefix + 'processed/scRNA_PC9_Osimertinib.rds')
    output:
        S3.remote(prefix + 'scRNA_PC9_Osimertinib.rds')
    shell:
        """
        mv {prefix}processed/scRNA_PC9_Osimertinib.rds {prefix}scRNA_PC9_Osimertinib.rds
        """

rule process_GSE150949:
    input:
        S3.remote(prefix + 'download/GSE150949_pc9_count_matrix.csv'),
        S3.remote(prefix + 'download/GSE150949_metaData_with_lineage.txt')
    output:
        S3.remote(prefix + 'processed/scRNA_PC9_Osimertinib.rds')
    resources:
        mem_mb=15000,
        disk_mb=6000
    shell:
        """
        Rscript scripts/process_GSE150949.R \
        {prefix}download \
        {prefix}processed
        """

rule download_data:
    output:
        S3.remote(prefix + 'download/GSE150949_pc9_count_matrix.csv'),
        S3.remote(prefix + 'download/GSE150949_metaData_with_lineage.txt')
    shell:
        """
        Rscript scripts/download_GSE150949.R \
        {prefix}download
        """
