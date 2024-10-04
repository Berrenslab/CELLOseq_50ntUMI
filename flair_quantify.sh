#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem=10G
#SBATCH --partition=long
#SBATCH --time=7-00:00:00
#SBATCH --output=flair_quant.out
#SBATCH --error=flair_quant.err

# This script forms the FLAIR pipeline for downstream analysis of CELLO-seq reads.
# For more detail on the pipeline, please see https://github.com/BrooksLabUCSC/flair
# In this script, we quantify FLAIR isoform usage across samples using minimap2.

collapsed_isoform_file=/project/CELLOseq/lmcleand/natprot_CELLO/corrected_cello/2cell_subset_corrected._flair._sjs_correct_all_corrected._collapsed.isoforms.fa
manifest_file=/project/CELLOseq/lmcleand/natprot_CELLO/corrected_cello/reads_manifest.tsv
output=/project/CELLOseq/lmcleand/natprot_CELLO/corrected_cello/

simg=/project/CELLOseq/shared/images/flairdev.img
path=/project/CELLOseq/

singularity exec -B $path $simg python3 /usr/local/flair/flair.py quantify -r ${manifest_file} -i ${collapsed_isoform_file} \
--salmon /usr/local/salmon-latest_linux_x86_64/bin/salmon \
--output ${output}/flair_quantify_out
