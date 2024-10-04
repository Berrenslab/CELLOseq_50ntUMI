#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem=2G
#SBATCH --partition=short
#SBATCH --time=24:00:00
#SBATCH --output=TE_isoform_filt.out
#SBATCH --error=TE_isoform_filt.err

module load bedtools2/2.29.2

# MOUSE
# Filter for transposons in flair isoform file
# filter GTF file to not contain simple repeats
grep -v "rich" /project/CELLOseq/lmcleand/mm39_flair/mm39_repeatmasker_ucsc.rmsk_unique.gtf | grep -v "U[0-9]" | grep -v "tRNA" | \
grep -v "rRNA" | grep -v "SRNA" | grep -v "7SL" > /project/CELLOseq/lmcleand/mm39_flair/mm39_repeatmasker_ucsc.rmsk_unique_noRich_noSNRNA_notRNA_norRNA_noSRNA_no7SL.gtf

#filter out ERCCs and filter for genes
grep -v "ERCC" 2cell_subset_corrected._flair._sjs_correct_all_corrected._collapsed.isoforms.gtf \
| grep "exon" > 2cell_subset_flair_corrected_isoforms_noERCC_exon.gtf

# bed intersect genome GTF and flair GTF
bedtools intersect -v -s -b /project/CELLOseq/lmcleand/mm39_flair/gencode.vM35.annotation.gtf \
-a 2cell_subset_flair_corrected_isoforms_noERCC_exon.gtf \
> 2cell_subset_flair_corrected_isoforms_noERCC_exon_woGenome.gtf

# filter against known TEs
grep -v "barcode_[0-9]*[0-9]*_" 2cell_subset_flair_corrected_isoforms_noERCC_exon_woGenome.gtf \
> 2cell_subset_flair_corrected_isoforms_noERCC_exon_woGenome_woknownRepeats.gtf

# intersect filtered flair GTF with repeat GTF
bedtools intersect -wo -b /project/CELLOseq/lmcleand/mm39_flair/mm39_repeatmasker_ucsc.rmsk_unique_noRich_noSNRNA_notRNA_norRNA_noSRNA_no7SL.gtf \
-a 2cell_subset_flair_corrected_isoforms_noERCC_exon_woGenome_woknownRepeats.gtf \
> 2cell_subset_flair_corrected_isoforms_noERCC_exon_woGenome_woknownRepeats_repeats.gtf

# filter for overlap bigger than 100
awk '$27 >= 100' 2cell_subset_flair_corrected_isoforms_noERCC_exon_woGenome_woknownRepeats_repeats.gtf \
> 2cell_subset_flair_corrected_isoforms_noERCC_exon_woGenome_woknownRepeats_repeats_100.gtf

awk '{print $12, $24}' 2cell_subset_flair_corrected_isoforms_noERCC_exon_woGenome_woknownRepeats_repeats_100.gtf | uniq \
> 2cell_subset_repeat_readnames.txt


# Filter for transposons derived isoforms in flair isoform file
# filter for gene IDs, remove transcripts, retain only exons, remove ERCCS
grep ENSMUSG 2cell_subset_corrected._flair._sjs_correct_all_corrected._collapsed.isoforms.gtf \
| grep -v ENSMUST | grep exon | grep -v ERCC \
> 2cell_subset_flair_corrected_isoforms_noTranscript_exons_noERCC_exon.gtf

# intersect filtered flair GTF with repeat GTF
bedtools intersect -s -b /project/CELLOseq/lmcleand/mm39_flair/mm39_repeatmasker_ucsc.rmsk_unique_noRich_noSNRNA_notRNA_norRNA_noSRNA_no7SL.gtf \
-a 2cell_subset_flair_corrected_isoforms_noTranscript_exons_noERCC_exon.gtf -wo \
> 2cell_subset_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms.gtf

# negatively intersect genome GTF
bedtools intersect -v -f 1 -b /project/CELLOseq/lmcleand/mm39_flair/gencode.vM35.annotation_exons.gtf \
-a 2cell_subset_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms.gtf \
> 2cell_subset_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic.gtf

# filter for overlap 
awk '$26 >= 100' 2cell_subset_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic.gtf > 2cell_subset_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic_100.gtf

# replaced nesting section of code
awk '{print $12, $10, $23}' 2cell_subset_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic_100.gtf | uniq \
> 2cell_subset_repeat_isoform_readnames.txt
