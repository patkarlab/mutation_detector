rule merge_output:
    input:
        #'{sample}.analysis/Annovar_Modified/{sample}.platypus.csv',
        #'{sample}.analysis/Annovar_Modified/{sample}.freebayes.csv',
        '{sample}.analysis/Annovar_Modified/{sample}.somaticseq.csv',
        '{sample}.analysis/Annovar_Modified/{sample}.combined.csv',
        'Coverview/{sample}/{sample}.coverview_regions.csv',
        '{sample}.analysis/CAVA/{sample}_CAVA.csv'
    output:
        report('Final-Output/{sample}/{sample}.xlsx', caption='../report/variants.rst', category='Variants Excel')
    message: " Merge output for {wildcards.sample}"
    script:
        '../scripts/merge-csv.py'


rule final_output:
    input:
        '{sample}.analysis/coverage/{sample}.Low_Coverage.png',
        '{sample}.analysis/qualimap_results/{sample}.qc_report.pdf',
        '{sample}.analysis/gatk38_processing/{sample}.final.bam',
        '{sample}.analysis/gatk38_processing/{sample}.final.bam.bai'
    output:
        report('Final-Output/{sample}/{sample}.Low_Coverage.png', caption='../report/coverage.rst', category='Coverage Plot'),
        report('Final-Output/{sample}/{sample}.qc_report.pdf', caption='../report/qc.rst', category='Quality check'),
        'Final-Output/{sample}/{sample}.final.bam',
        'Final-Output/{sample}/{sample}.final.bam.bai'
    run:
        shell('mv {input[0]} {output[0]}')
        shell('mv {input[1]} {output[1]}')
        shell('cp {input[2]} {output[2]}')
        shell('cp {input[3]} {output[3]}')

rule copy_s3:
        input:
            'Final-Output/{sample}/{sample}.xlsx',
            'Final-Output/{sample}/{sample}.Low_Coverage.png',
            'Final-Output/{sample}/{sample}.qc_report.pdf',
            'Final-Output/{sample}/{sample}.final.bam',
            'Final-Output/{sample}/{sample}.final.bam.bai',
        output:
            S3.remote(S3PATH+'Final-Output/{sample}/{sample}.xlsx'),
            S3.remote(S3PATH+'Final-Output/{sample}/{sample}.Low_Coverage.png'),
            S3.remote(S3PATH+'Final-Output/{sample}/{sample}.qc_report.pdf'),
            S3.remote(S3PATH+'Final-Output/{sample}/{sample}.final.bam'),
            S3.remote(S3PATH+'Final-Output/{sample}/{sample}.final.bam.bai'),
        run:
            shell('cp {input[0]} {output[0]}')
            shell('cp {input[1]} {output[1]}')
            shell('cp {input[2]} {output[2]}')
            shell('cp {input[3]} {output[3]}')
            shell('cp {input[4]} {output[4]}')
            
rule write_bamfiles:
    input:
        expand('Final-Output/{sample}/{sample}.final.bam',sample=SAMPLES)
    output:
        'DECON/bamfiles.txt'
    shell:
        "realpath -e {input} >> {output}"
