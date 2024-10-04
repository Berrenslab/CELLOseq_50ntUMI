#!/bin/sh
#SBATCH --ntasks=1
#SBATCH --mem=10G
#SBATCH --partition=long
#SBATCH --time=7-00:00:00
#SBATCH --output=flair_collapse.out
#SBATCH --error=flair_collapse.err

# This script forms the FLAIR pipeline for downstream analysis of CELLO-seq reads.
# For more detail on the pipeline, please see https://github.com/BrooksLabUCSC/flair
# In this script, we define high-confidence isoforms from all of the corrected reads

combined_psl_file=/project/CELLOseq/lmcleand/natprot_CELLO/corrected_cello/2cell_subset_corrected._flair._sjs_correct_all_corrected.psl
combined_fastq_file=/project/CELLOseq/lmcleand/natprot_CELLO/corrected_cello/2cell_subset_corrected.fastq

species="mouse"

species_folder=/project/CELLOseq/lmcleand/mm39_flair/
index_file=/project/CELLOseq/lmcleand/mm39_flair/GRCm39.primary_assembly.genome.fa
annotation_file=/project/CELLOseq/lmcleand/mm39_flair/gencode.vM35.annotation.gtf

echo "Species set to ${species}"
echo "Species folder set to ${species_folder} and reference files set to ${index_file}"

simg=/project/CELLOseq/shared/images/flairdev.img
path=/project/CELLOseq/


singularity exec -B $path $simg python3 /usr/local/flair/flair.py collapse --reads ${combined_fastq_file} --query ${combined_psl_file} \
--gtf ${annotation_file} \
--genome ${index_file} \
--salmon /usr/local/salmon-latest_linux_x86_64/bin/salmon \
--output ${combined_psl_file%psl}_collapsed

