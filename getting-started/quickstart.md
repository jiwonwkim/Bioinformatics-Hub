---
icon: bullseye-arrow
---

# \[Essential] Conda Installation

Sometimes specific versions of software require different versions of dependent softwares. When the versions doesn't match, programmes would not be run. To deal with this issue, **Conda** could be used to set up virtual environment.&#x20;

**Conda** is a tool that helps you install and manage software and their dependencies (the other software or libraries they need to work) in isolated environments, so that different tools don’t conflict with each other.

## Using Conda on Myriad

[Miniconda3](https://www.anaconda.com/docs/getting-started/miniconda/main), a light version of Conda, is **pre-installed** in Myriad. You can load it as below:

```shell
module load python/miniconda3/24.3.0-0
source $UCL_CONDA_PATH/etc/profile.d/conda.sh 
```

You can test if Conda was loaded properly with the following command:

```shell
conda info
```

If it prints the information about Conda, your load was successful.



If you wish the Conda to be loaded automatically, you can add the loading command to your shell profile.

<details>

<summary>What is a shell profile?</summary>

When you open the **terminal** on Linux or macOS, your computer reads a **"profile" file** (usually `~/.bashrc`) to set things up for you. This file is called a **shell profile**.&#x20;



The shell profile:

* Sets your **PATH** (tells the computer where to find your programs)
* Loads your **aliases** (shortcuts for long commands)
* Sets **environment variables**
* Can activate **conda** or other tools automatically



In this case, shell profile loads conda in automatically every time you log-in to Myriad.

</details>

```sh
echo "module load python/miniconda3/24.3.0-0" >> ~/.bashrc
echo "source $UCL_CONDA_PATH/etc/profile.d/conda.sh" >> ~/.bashrc
```



## Installing Conda on your local server

{% stepper %}
{% step %}
### Downloading and starting Conda installer

We are going to install a light version of Conda, **Miniconda3**.

```sh
mkdir -p ~/software  ## Make a directory(=folder) for software
cd ~/software  ## Move to software directory

## Download the installer
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  
bash Miniconda3-latest-Linux-x86_64.sh  ## Run installer
```
{% endstep %}

{% step %}
### &#x20;Proceeding to installation

<figure><img src="../.gitbook/assets/Screenshot 2025-05-13 at 11.37.27.png" alt=""><figcaption></figcaption></figure>

When the installer shows up, press enter to proceed.
{% endstep %}

{% step %}
### Agreeing to the terms

<figure><img src="../.gitbook/assets/Screenshot 2025-05-13 at 11.37.38.png" alt=""><figcaption></figcaption></figure>

When it asks you to accept the license terms, type `yes` in.
{% endstep %}

{% step %}
### Setting the installation path

<figure><img src="../.gitbook/assets/Screenshot 2025-06-30 at 14.13.15.png" alt=""><figcaption></figcaption></figure>

When the installer asks you where to install miniconda, type `$HOME/software/miniconda3` in.
{% endstep %}

{% step %}
### Updating Shell profile

<figure><img src="../.gitbook/assets/Screenshot 2025-05-13 at 11.40.17.png" alt=""><figcaption></figcaption></figure>

When it asks if you want to update your shell profile, type `yes` in.
{% endstep %}

{% step %}
### Restarting terminal

<figure><img src="../.gitbook/assets/Screenshot 2025-05-13 at 11.42.42.png" alt=""><figcaption></figcaption></figure>

Now Conda is installed. Close and restart terminal to allow your updated shell profile to be effective. You can delete the installer now.

```sh
rm ~/software/Miniconda3-latest-Linux-x86_64.sh 
```


{% endstep %}
{% endstepper %}

Now we move on to installing Nextflow, which enables you to run full pipelines with a single command in the next page.&#x20;
