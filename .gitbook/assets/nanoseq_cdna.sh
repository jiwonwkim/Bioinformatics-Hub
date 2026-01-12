#!/bin/bash -l
#$ -N nanoseq
#$ -pe mpi 12        # CPU 
#$ -l mem=7G         # Memory per core (84GB in total) 
#$ -l h_rt=48:0:0    # Run time limit
#$ -l tmpfs=100G     # Temporary directory size
#$ -wd $HOME/projects/nanoseq    # Working directory

# Change into project directory
cd $HOME/projects/nanoseq

# Load conda and activate nextflow environment
module load python/miniconda3/24.3.0-0
source $UCL_CONDA_PATH/etc/profile.d/conda.sh 
conda activate nextflow
conda config --add channels bioconda

# Run nf-core/nanoseq with cDNA protocol
nextflow run nf-core/nanoseq \
    --input samplesheet.csv \
    --protocol cDNA \
    --outdir result  \
    --skip_demultiplexing \
    --skip_qc \
    -profile singularity \
    -c nextflow.config 