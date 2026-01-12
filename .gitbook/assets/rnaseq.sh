#!/bin/bash -l
#$ -N rnaseq2
#$ -l h_rt=48:0:0
#$ -l mem=6G
#$ -pe smp 12

cd $HOME/projects/rnaseq

module load python/miniconda3/24.3.0-0
source $UCL_CONDA_PATH/etc/profile.d/conda.sh 
conda activate nextflow
source ~/.bashrc
conda config --add channels bioconda

export TOWER_ACCESS_TOKEN=eyJ0aWQiOiAxMDk1Nn0uMzI1YjJhZWY1ODEzODVmY2FjZTFiZjRjYzFlZGQ5NGZjNDE1MGI1MQ==

nextflow run nf-core/rnaseq \
	-r dev \
	-profile conda \
	-c nextflow2.config \
	--input samplesheet.csv \
	--outdir result2 \
	--gtf $HOME/ACFS/ref/GRCh38.gtf \
	--fasta $HOME/ACFS/ref/GRCh38.fa \
	-with-tower 
