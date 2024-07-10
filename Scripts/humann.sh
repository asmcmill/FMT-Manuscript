#!/bin/bash
#BSUB -n 16
#BSUB -W 30:30
#BSUB -J humann
#BSUB -oo logfiles/output_file_humann
#BSUB -R "rusage[mem=40]"

module load conda
source /usr/local/apps/miniconda20230420/bin/activate
conda activate /usr/local/usrapps/$GROUP/$USER/metaenv

for file in /share/a/asmcmill/FMT/outputs/trimreads/*_kneaddata.fastq;
do
        humann --input $file --output /share/a/asmcmill/FMT/outputs/humann --memory-use maximum \
        --nucleotide-subject-coverage-threshold 20.0 --translated-subject-coverage-threshold 50.0 \
        --threads 16 --pathways unipathway --metaphlan-options="--offline --bowtie2db /share/a/asmcmill/FMT/metaphlan_db --index mpa_vOct22_CHOCOPhlAnSGB_202212";
done

conda deactivate
