#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem=10G
#SBATCH --partition=long
#SBATCH --time=7-00:00:00
#SBATCH --output=flair_correct.out
#SBATCH --error=flair_correct.err

# This script forms the FLAIR pipeline for downstream analysis of CELLO-seq reads.
# For more detail on the pipeline, please see https://github.com/BrooksLabUCSC/flair
# In this script, we will correct misaligned splice site using both genome annotation and short-read splice junctions

species="mouse"
bed_list=$(ls /project/CELLOseq/lmcleand/natprot_CELLO/corrected_cello/2cell_subset_corrected._flair.bed)


species_folder=/project/CELLOseq/lmcleand/mm39_flair/
index_file=/project/CELLOseq/lmcleand/mm39_flair/GRCm39.primary_assembly.genome.fa
annotation_file=/project/CELLOseq/lmcleand/mm39_flair/gencode.vM35.annotation.gtf

echo "Species set to ${species}"
echo "Species folder set to ${species_folder} and reference files set to ${index_file}"
echo "BED files to be processed are ${bed_list}"

simg=/project/CELLOseq/shared/images/flairdev.img

path=/project/CELLOseq/

for bed in ${bed_list}; do
  singularity exec -B $path $simg python3 /usr/local/flair/flair.py correct --genome ${index_file} \
  --query ${bed} --chromsizes ${species_folder}/sizes.genome \
  --gtf ${annotation_file} \
  --output ${bed%bed}_sjs_correct --print_check \
  -j ${annotation_file}_SJs_sorted.tsv
done
