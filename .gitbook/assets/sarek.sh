#!/bin/bash -l
#$ -N sarek
#$ -l h_rt=48:0:0
#$ -l mem=6G
#$ -pe mpi 12
cd $HOME/projects/sarek
module load python/miniconda3/24.3.0-0
source $UCL_CONDA_PATH/etc/profile.d/conda.sh

conda activate nextflow
conda config --add channels bioconda
nextflow run nf-core/sarek \
-profile singularity \
-c nextflow.config \
--input samplesheet.csv \
--outdir result \
--gtf $HOME/ACFS/ref/GRCh38.chr.gtf \
--fasta $HOME/ACFS/ref/GRCh38.chr.fa 