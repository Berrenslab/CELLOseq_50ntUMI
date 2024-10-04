#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem=256G
#SBATCH --partition=long
#SBATCH --time=7-00:00:00
#SBATCH --output=flair_align.out
#SBATCH --error=flair_align.err

# This script forms the FLAIR pipeline for downstream analysis of CELLO-seq reads.
# For more detail on the pipeline, please see https://github.com/BrooksLabUCSC/flair
# In this script, we first align reads to the genome using minimap2

# load python module
module load python-cbrg/current

species=mouse
fastq_list=$(ls /project/CELLOseq/lmcleand/natprot_CELLO/corrected_cello/2cell_subset_corrected.fastq)
index_file="/project/CELLOseq/lmcleand/GRCm39.primary_assembly.genome.fa"

#reference_folder=/project/CELLOseq/shared/reference/sequences/
#if [ "$species" = "human" ]
#then
 # species_folder=human_GRCh38_p13
  #index_file=GRCh38.p13.genome.fa
#elif [ "$species" = "mouse" ]
#then
 # species_folder=mouse_GRCm38_p6
  #index_file=GRCm38.p6.genome.fa
#fi

simg=/project/CELLOseq/shared/images/flairdev.img

echo "Species set to ${species}"
echo "Species folder set to ${species_folder} and reference files set to ${index_file}"
echo "FASTQ files to be processed are ${fastq_list}"

path=/project/CELLOseq/

for fastq in ${fastq_list}; do
  singularity exec -B $path $simg python3 /usr/local/flair/flair.py align -g ${index_file} \
  -r ${fastq} -o ${fastq%fastq}_flair
done



