---
icon: bullseye-arrow
---

# \[Essential] Downloading Reference Genome

In many analyses, you need a **reference genome** to align and analyze your sequenced data. A reference genome is a "map" of a species' DNA — it's a representative example of what the genome of that species typically looks like.



## How to download human reference genome

```sh
## Make directory under $HOME/ACFS (Read-only directory on Myriad)
mkdir -p $HOME/ACFS/ref
cd $HOME/ACFS/ref

VERSION=114 ## Adjust it to the latest version 
## Download the files
wget -O GRCh38.fa.gz ftp://ftp.ensembl.org/pub/release-$VERSION/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz
wget -O GRCh38.chr.gtf.gz ftp://ftp.ensembl.org/pub/release-$VERSION/gtf/homo_sapiens/Homo_sapiens.GRCh38.$VERSION.chr.gtf.gz

## Unzip the compressed files
gzip -d GRCh38*.gz
```

#### Exclude scaffolds

Downloaded reference genome contains sequences from scaffolds as well as chromosomes, which is unnecessary. To exclusively obtain chromosome sequences, run the following code.

```bash
## Change file name of GRCh38.fa into tmp.fa
mv GRCh38.fa tmp.fa

## Extract chromosome 1-22, X, Y, and MT from tmp.fa and save into GRCh38.fa
samtools faidx tmp.fa {1..22} X Y MT > GRCh38.fa

## Remove original file with scaffolds
rm tmp.fa
```

#### Generate the version with "chr" in chromosome names&#x20;

```sh
sed s/'^>'/'>chr'/g ~/ACFS/ref/GRCh38.fa > ~/ACFS/ref/GRCh38.chr.fa 
sed s/'^'/'chr'/g ~/ACFS/ref/GRCh38.gtf > ~/ACFS/ref/GRCh38.chr.gtf
```

## How to download mouse reference genome

```sh
## Make directory under $HOME/ACFS (Read-only directory)
mkdir -p $HOME/ACFS/ref
cd $HOME/ACFS/ref

VERSION=114 ## Adjust it to the latest version 
## Download the files
wget -O GRCm39.fa.gz https://ftp.ensembl.org/pub/release-$VERSION/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna_sm.primary_assembly.fa.gz
wget -O GRCm39.chr.gtf.gz https://ftp.ensembl.org/pub/release-$VERSION/gtf/mus_musculus/Mus_musculus.GRCm39.114.chr.gtf.gz

## Unzip the compressed files
gzip -d GRCm39*.gz
```

#### Generate the version with "chr" in chromosome names&#x20;

```sh
sed s/'^>'/'>chr'/g ~/ACFS/ref/GRCm39.fa > ~/ACFS/ref/GRCm39.chr.fa 
sed s/'^'/'chr'/g ~/ACFS/ref/GRCm39.gtf > ~/ACFS/ref/GRCm39.chr.gtf
```

## Indexing the reference genome

For the computer to access big genome data efficiently, the reference genome should be **indexed**.&#x20;

```sh
## Load modules
module load samtools
module load picard-tools

## Index the reference genome
genome="GRCh38" # Or change into "GRCm39" in case of mouse refernce
samtools faidx ${genome}.fa                         ## Create .fai index
picard CreateSequenceDictionary R=${genome}.fa      ## Create .dict index
```



### Downloading reference genome of other species

You can find the list of available species [here (fasta)](https://ftp.ensembl.org/pub/release-114/fasta/) and [here (gtf)](https://ftp.ensembl.org/pub/release-114/gtf/).  Copy the link of the desired files, and simply replace them with the links above.

For example, if you wish to download the reference genome of gibbons, you can run:

```sh
cd $HOME/ACFS/ref
SPECIES="nomascus_leucogenys" ## Set the name of the reference files
wget -O $SPECIES.fa.gz https://ftp.ensembl.org/pub/release-114/fasta/nomascus_leucogenys/dna/Nomascus_leucogenys.Nleu_3.0.dna_sm.toplevel.fa.gz
wget -O $SPECIES.chr.gtf.gz https://ftp.ensembl.org/pub/release-114/gtf/nomascus_leucogenys/Nomascus_leucogenys.Nleu_3.0.114.chr.gtf.gz
```

All set! Now you can find reference genome in `$HOME/ACFS/ref` directory whenever you need it.

