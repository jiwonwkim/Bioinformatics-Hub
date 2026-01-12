---
icon: dna
---

# Ensembl Variant Effect Predictor

**Ensembl VEP (Variant Effect Predictor)** is a tool that takes genetic variants (like SNPs, insertions, deletions) and tells you what they do in the genome. For each variant, VEP tells you:

* Which gene it’s in (or nearby).
* Whether it changes the protein (missense, nonsense, synonymous, etc.).
* If it’s in a regulatory region.
* Known annotations (e.g., from ClinVar, dbSNP).



If your input file has small number of variants, you can consider using [web interface VEP](https://www.ensembl.org/Multi/Tools/VEP). You can paste or upload your input, a VCF file or a list of  rs IDs (i.e. rs12345678) to run the job. Once the run is completed, you'll be able to see the results on the web interface.



For genome-wide variants, which probably have million+ variants in a single VCF file, we recommend using command-line tool. (Web interface would not work on such big VCFs.)

Before we start, we need to set up a Conda environment for VEP.&#x20;

```sh
# Create conda environment and name it vep
conda create -n vep -c conda-forge -c bioconda \
gcc gxx make perl=5.32 perl-archive-zip perl-dbi conda ensembl-vep perl-bio-db-hts -y 
 
# Activate the environment
conda activate vep

# Unload and load modules
module unload -f compilers mpi
module load compilers/gnu/4.9.2

# Try running VEP
# If VEP does not run smoothly, try installing Perl modules. (See below)
# Otherwise, VEP is good to go.
vep --help

# If Perl modules are required, enter the following commands line by line,
# and return to Shell terminal.
perl -MCPAN -e shell
install Archive::Zip DBI Bio::DB::HTS
q
```

<details>

<summary>If Perl modules are required - detailed guide</summary>

<figure><img src="../../.gitbook/assets/image (16).png" alt=""><figcaption></figcaption></figure>

If you see this error when running VEP, you may have to install a few perl modules. First, start a CPAN interactive shell in Perl.

```sh
perl -MCPAN -e shell
```

<figure><img src="../../.gitbook/assets/image (17).png" alt=""><figcaption></figcaption></figure>

You'll see the terminal has changed the format; the command line now says `cpan[1]>`.

<figure><img src="../../.gitbook/assets/image (18).png" alt=""><figcaption></figcaption></figure>

Now type `install Archive::Zip DBI Bio::DB::HTS` in to install required modules.

<figure><img src="../../.gitbook/assets/image (19).png" alt=""><figcaption></figcaption></figure>

Once the installation is complete, type `q` in to exit the CPAN interactive shell and return to bash.

<figure><img src="../../.gitbook/assets/image (21).png" alt=""><figcaption></figcaption></figure>

Try running VEP again. If you see the help message, VEP is ready.&#x20;

</details>



Now let's try running VEP on genomic variants.

{% stepper %}
{% step %}
### Make project directory

```sh
# Make project directory & subdirectories
mkdir -p $HOME/projects/VEP/data/vcf

# Change working directory
cd $HOME/projects/VEP
```
{% endstep %}

{% step %}
### Download and set up the resources required for VEP

In the code below, we are making cache directory and installing human data into the cache directory. If you are using different species, make sure you adjust the code accordingly.

```sh
# Make cache directory
mkdir -p $HOME/.cache/homo_sapiens

# Download & install VEP resources
vep_install -a cf -s homo_sapiens -y GRCh38 -c $HOME/.cache/homo_sapiens
```
{% endstep %}

{% step %}
### Run VEP

Assuming your VCF files are in `data/vcf` directory, run VEP. Adjust the list of samples and names of the files according to your data.

```sh
ref=$HOME"/ACFS/ref/GRCh38.chr.fa"

# Make result directory
mkdir result

# Set a list of samples
samples="AMD1 AMD2 AMD3"
# For each sample,
for sample in ${samples}; do
# Input file path
fp1="../data/vcf/"${sample}"_round_0_hap_mixed_phased.Q30.norm.vcf.gz"
# Output file name
of1="./result/"${sample}"_round_0_hap_mixed_phased.Q30.norm.anno.vep"
# Run VEP with installed cache (GRCh38)
vep -i $fp1 \
    --cache \
    --dir_cache $HOME/.cache/homo_sapiens/ \
    --assembly GRCh38 \
    --offline \
    --fasta $ref \
    --everything \
    --fork 4 \
    -o $of1
done
```
{% endstep %}
{% endstepper %}

