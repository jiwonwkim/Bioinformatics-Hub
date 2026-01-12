#!/bin/bash -l
#$ -N scrnaseq
#$ -l h_rt=48:0:0
#$ -l mem=6G
#$ -pe mpi 12

cd $HOME/projects/scrnaseq

module load python/miniconda3/24.3.0-0
source $UCL_CONDA_PATH/etc/profile.d/conda.sh 
conda activate nextflow
source ~/.bashrc
conda config --add channels bioconda

export TOWER_ACCESS_TOKEN=eyJ0aWQiOiAxMDk1Nn0uMzI1YjJhZWY1ODEzODVmY2FjZTFiZjRjYzFlZGQ5NGZjNDE1MGI1MQ==

nextflow run nf-core/scrnaseq \
	-profile singularity \
	-c nextflow.config \
	--input samplesheet.csv \
	--outdir result2 \
	--protocol 10XV3 \
	--aligner cellranger \
	--gtf $HOME/ACFS/ref/GRCm39.chr.gtf \
	--fasta $HOME/ACFS/ref/GRCm39.fa \
	-with-tower