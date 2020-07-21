rule platypus_variant:
    input:
        '{sample}.analysis/gatk38_processing/{sample}.final.bam'
    output:
        '{sample}.analysis/variants/{sample}.platypus.vcf'
    message: " Call platypus variants for {wildcards.sample}"
    log:
        "logs/{sample}/platypus.log"
    benchmark:
        "benchmarks/{sample}.variantcalls.benchmark.txt"
    conda:
        "../envs/py2tools.yaml"
    params:
        regions = config["bedfile"].replace('.bed', '_regions.txt')
    shell:
        'python ~/programs/Platypus_0.8.1/Platypus.py callVariants --bamFiles={input} --refFile={config[reference_genome]}'
        ' --output={output} --nCPU=15 --minFlank=0 --filterDuplicates=0 --maxVariants=6 --minReads=6'
        ' --regions={params.regions} &>> {log}'
