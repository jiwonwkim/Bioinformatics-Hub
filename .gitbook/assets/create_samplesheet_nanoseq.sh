#!/bin/bash

# Path to your data directory
DATA_DIR="$HOME/projects/nanoseq/data/fastq"

fasta=$(realpath ~/ACFS/ref/GRCh38.chr.fa)
gtf=$(realpath ~/ACFS/ref/GRCh38.chr.gtf)

# Create samplesheet header
echo "group,replicate,barcode,input_file,fasta,gtf" > samplesheet.csv

# Get all R1 files from the data directory
for r1_file in $(ls ${DATA_DIR}/*.fastq.gz 2>/dev/null); do
    # Extract basename of the file
    r1_basename=$(basename "$r1_file")
    
    # Extract sample name (remove _R1.fastq.gz)
    sample=$(echo "$r1_basename" | sed 's/\.fastq\.gz//')
    group=$(echo "$sample" | grep -o '^[A-Za-z]*')
    replicate=$(echo "$sample" | grep -o '[0-9]*$')

    # Verify file exists
    if [[ -f "$r1_file" ]]; then
        # Add to samplesheet
        echo "${group},${replicate},,${r1_file},${fasta},${gtf}" >> samplesheet.csv
    else
        echo "Error: Missing fastq file for sample ${sample}" >&2
    fi
done

echo "Samplesheet created as samplesheet.csv"
