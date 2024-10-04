template.file <- "internal_adaptor_filter_tso100k.Rmd"
template.content <- readLines(template.file)

# Define the file path
file.path <- "/project/CELLOseq/lmcleand/2iE14celloseq24/test_demultpara/"

# List files with the defined file path
sample.list <- list.files(path = file.path, pattern = "\\.fastq$", full.names = TRUE)

for (sample in sample.list) {
  # Ensure the full file path is used in the script and is enclosed in quotes
  sample.quoted <- paste0('"', sample, '"')
  script <- gsub("INDEX", sample.quoted, template.content)
  sample.prefix <- gsub("\\..*", "", gsub(".*_", "", basename(sample)))
  writeLines(text = script, con = paste0("internal_adaptor_filter_tso_", sample.prefix, ".Rmd"))
}
