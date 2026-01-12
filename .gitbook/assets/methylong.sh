#!/bin/bash -l
#$ -N methylong
#$ -l h_rt=48:0:0
#$ -l mem=12G
#$ -pe smp 36
#$ -l tmpfs=100G
#$ -cwd

cd $HOME/projects/methylong

module load python/miniconda3/24.3.0-0
module load apptainer
source $UCL_CONDA_PATH/etc/profile.d/conda.sh 

conda activate nextflow
conda config --add channels bioconda

# Create a build directory to build your own containers.
mkdir -p $XDG_RUNTIME_DIR/$USER_apptainerbuild
export APPTAINERENV_TMPDIR=$XDG_RUNTIME_DIR/$USER_apptainerbuild

# Create a .apptainer directory in your Scratch
mkdir $HOME/Scratch/.apptainer
export APPTAINERENV_CACHEDIR=$HOME/Scratch/.apptainer

nextflow run nf-core/methylong \
    -r 1.0.0 \
    -c nextflow.config \
    --input samplesheet.csv \
    --outdir result  \
    -profile singularity -resume
