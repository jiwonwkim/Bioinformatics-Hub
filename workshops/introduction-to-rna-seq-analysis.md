---
description: April 2026
hidden: true
icon: '1'
---

# Introduction to RNA-seq Analysis

Welcome to the Bioinformatics Hub workshop! In this session, we will explore a typical RNA-seq analysis workflow and set up the computational environment needed to run it.

To run the analysis, we will need an environment for running R code. For this, we will download and install [**Jupyter**](https://jupyter.org/) on your laptops. To begin, please open **Terminal (Mac)** or **PowerShell (Windows)**.

## 1. Jupyter setup

### Install Miniconda

To install JupyterLab, you need `conda`.&#x20;

Conda is a tool that helps you install and manage software and their dependencies in **isolated environments**, so different tools don’t interfere with each other.

Download and install **Miniconda** from the installer from the [Conda documentation](https://docs.conda.io/projects/conda/en/latest/index.html). After installation, restart your terminal (Terminal on macOS or PowerShell on Windows).&#x20;

You should now see `(base)` at the beginning of your command line.&#x20;

<figure><img src="../.gitbook/assets/image (32).png" alt=""><figcaption></figcaption></figure>

This indicates that Conda is installed and the base environment is active.

### Create a new environment for JupyterLab

Instead of installing everything in the base environment, we will create a separate environment named `jupyter` for JupyterLab:

```bash
conda create -n jupyter -c conda-forge \
  python=3.11 \
  jupyterlab \
  r-base \
  r-irkernel \
  r-essentials
```

#### During installation

You may be prompted to confirm the installation.

<figure><img src="../.gitbook/assets/image (33).png" alt=""><figcaption></figcaption></figure>

* Type `a` in and press enter twice to proceed.

<figure><img src="../.gitbook/assets/image (35).png" alt=""><figcaption></figcaption></figure>

* Type `y` and press enter to proceed.

Once the installation is complete, you will see messages like:

<figure><img src="../.gitbook/assets/image (36).png" alt=""><figcaption></figcaption></figure>

Run the following code to actiavate the new environment.

```
conda activate jupyter
```

<figure><img src="../.gitbook/assets/image (37).png" alt=""><figcaption></figcaption></figure>

Now you are in `jupyter` environment, as you can tell from `(jupyter)` at the beginning of the prompt.

Run JupyterLab:

```bash
jupyter lab
```

A browser window should open automatically showing the JupyterLab interface.

If it does not open, check the terminal for a URL (including a port number), for example:

<figure><img src="../.gitbook/assets/image (38).png" alt=""><figcaption></figcaption></figure>

```
http://localhost:8888
```

Then copy and paste this address into your browser.

#### JupyterLab interface

You should now see the JupyterLab home page.

* The **left panel** is the file explorer
* On the **right-hand side**, you can create a new notebook

<figure><img src="../.gitbook/assets/image (39).png" alt=""><figcaption></figcaption></figure>

To start an R notebook, click **R**.

<figure><img src="../.gitbook/assets/image (40).png" alt=""><figcaption></figcaption></figure>

You can type your code into the cells and press **Shift + Enter** to run it.



## 2. RNA-seq analysis: Differential expression

### Count table

### Running DESeq2



## 3. Visualization

### Heatmap

### Volcano plot





