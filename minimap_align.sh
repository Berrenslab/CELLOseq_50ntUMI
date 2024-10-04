#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=long
#SBATCH --time=07-00:00:00
#SBATCH --job-name=celloseq_align
#SBATCH --output=minimap_%A_%a.out
#SBATCH --error=minimap_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --array=1-96%10  # Adjust the percentage to control the number of simultaneous jobs

module load minimap2/2.17

index="/project/CELLOseq/lmcleand/Mus_musculus.GRCm39.transcripts.repeats.fa.mmi"

# Define the folder containing FASTQ files
fastq_folder="/project/CELLOseq/lmcleand/2iE14celloseq24/test_demultpara"

# Get the list of all barcode FASTQ files in the folder
all_fastq_files=("$fastq_folder"/barcode_*.fastq)

# Convert the array index to the corresponding FASTQ file
fastq_file="${all_fastq_files[$SLURM_ARRAY_TASK_ID - 1]}"

# Generate the output SAM file name based on the input FASTQ file
output_sam="${fastq_file%.fastq}.sam"

# Run minimap2 for the specified FASTQ file
minimap2 -ax map-ont "$index" "$fastq_file" > "$output_sam"
