#! /bin/bash
if [ -z "$1" ]; then
    echo "PATH is empty";
    return;
else    
  SAVEPATH="${1}sample_details.csv";
  echo "Saved path: "${SAVEPATH};
fi  
smk
echo "Pipeline start"; 
date 
nohup snakemake --cores 7 --use-conda  -p --configfile $1/config.yaml  &> $1/snakemake.log
echo "Pipeline ends";
date
echo "Generating report";
snakemake --report report.html  --config SAMPLE_DETAILS=$SAVEPATH
#mv  nohup.out $1
