#!/bin/bash

# Path to your data directory
DATA_DIR="$HOME/projects/rnaseq/data/fastq"

# Create samplesheet header
echo "sample,fastq_1,fastq_2,strandedness" > samplesheet.csv

# Get all R1 files from the data directory
for r1_file in $(ls ${DATA_DIR}/*_R1.fastq.gz 2>/dev/null); do
    # Extract basename of the file
    r1_basename=$(basename "$r1_file")
    
    # Extract sample name (remove _R1.fastq.gz)
    sample=$(echo "$r1_basename" | sed 's/_R1\.fastq\.gz//')
    
    # Create corresponding R2 filename
    r2_basename="${sample}_R2.fastq.gz"
    r2_file="${DATA_DIR}/${r2_basename}"
    
    # Verify R2 file exists
    if [[ -f "$r2_file" ]]; then
        # Add to samplesheet
        echo "${sample},${r1_file},${r2_file},auto" >> samplesheet.csv
    else
        echo "Warning: Missing R2 file for sample ${sample}" >&2
        echo "${sample},${r1_file},,auto" >> samplesheet.csv
    fi
done

echo "Samplesheet created as samplesheet.csv"
