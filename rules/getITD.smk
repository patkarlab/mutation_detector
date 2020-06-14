from glob import glob
rule gunzip:
    input:
        r1 = lambda wildcards: glob('sequences/{sample}_S*_L001_R1_001.fastq.gz'.format(sample=wildcards.sample)),
        r2 = lambda wildcards: glob('sequences/{sample}_S*_L001_R2_001.fastq.gz'.format(sample=wildcards.sample))
    output:
        r1=temp('GetITD_sequences/{sample}_R1.fastq'),
        r2=temp('GetITD_sequences/{sample}_R2.fastq')
#put unzipped sequences to different file
    run:
        shell('gunzip -c {input.r1} > {output.r1}')
        shell('gunzip -c {input.r2} > {output.r2}')
#make unzipped sequences as temporarys
rule getITD:
    input:
       r1='GetITD_sequences/{sample}_R1.fastq',
       r2='GetITD_sequences/{sample}_R2.fastq'
    output:
        directory("Final-Output/{sample}/{sample}_getitd")
    message:
        "GetITD for {wildcards.sample}"
    log:
        'logs/{sample}/getITD.log'
    params:
        outdir = 'Final-Output/{sample}/'
    run:
        shell('python ~/programs/getitd/getitd.py {wildcards.sample} {input.r1} {input.r2} -require_indel_free_primers False -nkern {config[cores]} -anno ~/programs/getitd/anno/amplicon_kayser.tsv -reference ~/programs/getitd/anno/amplicon.txt &>> {log}')
        shell('mv {wildcards.sample}_getitd/ {params.outdir}')
