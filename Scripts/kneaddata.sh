#!/bin/bash 
#BSUB -n 16 
#BSUB -W 180 
#BSUB -J kndata 
#BSUB -oo logfiles/output_file_kneaddata

module load java 
module load conda 
source /usr/local/apps/miniconda20230420/bin/activate 
conda activate /usr/local/usrapps/$GROUP/$USER/metaenv 

for file in /share/a/asmcmill/FMT/fastq/*; 
do 
kneaddata --unpaired $file -db /share/a/asmcmill/FMT/kneaddata_db \
 -o /share/a/asmcmill/FMT/outputs/trimreads \
 --trimmomatic /usr/local/usrapps/$GROUP/$USER/Trimmomatic-0.39 \
 --fastqc /usr/local/usrapps/$GROUP/$USER/FastQC/fastqc \
 --run-trim-repetitive ; 
done 

python --version 
kneaddata --version
java -version

conda deactivate
