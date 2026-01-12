---
icon: bullseye-arrow
---

# \[Essential] Nextflow Installation

**Nextflow** is a pipeline management tool that helps you organize, automate, and run complex bioinformatics analyses step by step, so you don’t have to do everything manually.

Think of it like a bread-making machine. If you were to bake bread from scratch, you’d need to gather the ingredients, preheat the oven, mix everything in the correct order and proportions, knead the dough, and bake it—all by yourself. Now imagine an **all-in-one bread maker**: once you load the right ingredients, the machine takes care of everything—mixing, kneading, proofing, and baking—delivering a perfect loaf with minimal effort.\
**Nextflow** works the same way. Once you provide the correct input, it automates the entire workflow for you.

Let's start installing Nextflow.

{% stepper %}
{% step %}
### Creating Conda environment for Nextflow

We are going to create an independent environment named "nextflow" as Nextflow requires specific version of Java.

```sh
## Create a conda environment named "nextflow" with java version 11
conda create -n nextflow conda-forge::openjdk -y 
```

Once the environment is created, you can activate the environment.

```sh
conda activate nextflow
```
{% endstep %}

{% step %}
### Installing Nextflow

Installing Nextflow is not very different from installing Conda.

```sh
cd $HOME/software  ## Move to software directory
curl -s https://get.nextflow.io | bash  ## Download and run the installer
chmod +x nextflow  ## Make the software executable
## Add software directory to executable path
echo "export PATH=\"$HOME/software:\$PATH\"" >> $HOME/.bashrc
```

Please restart the terminal. If the installation was successful, you should be able to run the following command.

```
nextflow info
```
{% endstep %}
{% endstepper %}

Now we are ready to run nf-core pipelines in Nextflow!
