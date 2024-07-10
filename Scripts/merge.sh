#!/bin/bash
#BSUB -n 1
#BSUB -W 0:30
#BSUB -J merge
#BSUB -oo logfiles/output_file_merge

module load conda
source /usr/local/apps/miniconda20230420/bin/activate
conda activate /usr/local/usrapps/$GROUP/$USER/metaenv

for file in /share/a/asmcmill/FMT/outputs/humann/*/*_bugs_list.tsv;
do
sgb_to_gtdb_profile.py -i $file -o /share/a/asmcmill/FMT/outputs/humann/$(basename $file .tsv)_gtdb.tsv -d /share/a/asmcmill/FMT/metaphlan/mpa_vOct22_CHOCOPhlAnSGB_202212.pkl ;
done

merge_metaphlan_tables.py /share/a/asmcmill/FMT/outputs/humann/*_bugs_list_gtdb.tsv > /share/a/asmcmill/FMT/outputs/metaphlan_merged_abundance_table_gtdb.tsv --gtdb_profiles
merge_metaphlan_tables.py /share/a/asmcmill/FMT/outputs/humann/*/*_bugs_list.tsv > /share/a/asmcmill/FMT/outputs/metaphlan_merged_abundance_table.tsv

humann_join_tables -i /share/a/asmcmill/FMT/outputs/humann -o /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies.tsv --file_name genefamilies
humann_join_tables -i /share/a/asmcmill/FMT/outputs/humann -o /share/a/asmcmill/FMT/outputs/merge_humann_pathabundance.tsv --file_name pathabundance
humann_join_tables -i /share/a/asmcmill/FMT/outputs/humann -o /share/a/asmcmill/FMT/outputs/merge_humann_pathcoverage.tsv --file_name pathcoverage

humann_renorm_table -i /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies.tsv -o /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm.tsv --units cpm --update-snames
humann_renorm_table -i /share/a/asmcmill/FMT/outputs/merge_humann_pathabundance.tsv -o /share/a/asmcmill/FMT/outputs/merge_humann_pathabundance-cpm.tsv --units cpm --update-snames

humann_regroup_table --i /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm.tsv --o /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm-rxn.tsv --groups uniref90_rxn
humann_regroup_table --i /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm.tsv --o /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm-reko.tsv --groups uniref90_ko
humann_regroup_table --i /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm.tsv --o /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm-rego.tsv --groups uniref90_go

humann_rename_table --i /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm-rxn.tsv --o /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm-metacyc.tsv -n metacyc-rxn
humann_rename_table --i /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm-reko.tsv --o /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm-KO.tsv -n kegg-orthology
humann_rename_table --i /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm-rego.tsv --o /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm-go.tsv -n go
humann_rename_table --i /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm.tsv --o /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm-uniref.tsv -n uniref90

humann_unpack_pathways --input-genes /share/a/asmcmill/FMT/outputs/merge_humann_genefamilies-cpm.tsv --input-pathways /share/a/asmcmill/FMT/outputs/merge_humann_pathabundance-cpm.tsv --output /share/a/asmc$

conda deactivate


