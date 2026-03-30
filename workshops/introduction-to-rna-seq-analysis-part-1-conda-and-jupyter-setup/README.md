---
description: April 2026
icon: '1'
---

# Introduction to RNA-seq Analysis Part 1: Conda & Jupyter setup

Welcome to the Bioinformatics Hub workshop! In this session, we will explore a typical RNA-seq analysis workflow and set up the computational environment needed to run it.

To run the analysis, we will need an environment for running R code. For this, we will download and install [Jupyter](https://jupyter.org/) on your laptops. To begin, please open **Terminal (Mac)** or **PowerShell (Windows)**.&#x20;

For Windows users, we will use Ubuntu via Windows Subsystem for Linux (WSL). Please run the following commands in PowerShell:

```powershell
# Install Ubuntu with WSL
wsl --install -d Ubuntu-22.04
```

Once the installation is complete, restart your system.

After restarting, launch Ubuntu by running:

```powershell
# Launch Ubuntu
wsl 
```

For more information, please refer to the following video: [YouTube link](https://www.youtube.com/watch?v=xsdsceJYcXo).

## 1. Jupyter setup

### Install Miniconda

To install JupyterLab, you need `conda`.&#x20;

Conda is a tool that helps you install and manage software and their dependencies in **isolated environments**, so different tools don’t interfere with each other.

Download **Miniconda** from the installer below.&#x20;

* macOS: [arm64](https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh) / [intel](https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh)
* WSL: [Linux x86](https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh)
* Find more distributions [here](https://www.anaconda.com/docs/getting-started/advanced-install/old-os#miniconda).

<details>

<summary>Miniconda installation for macOS (arm64)</summary>

1. Change into `Downloads` directory.

```bash
cd ~/Downloads
```

2. Download the installer.

```bash
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh
```

3. Make the script executable.

```bash
# Change permisson
chmod +x Miniconda3-latest-MacOSX-arm64.sh
```

4. Run the script.

```bash
# Run the script
./Miniconda3-latest-MacOSX-arm64.sh
```

5. Type `yes` to agree to the license terms.

```
Do you accept the license terms? [yes|no]
>>> yes
```

6. Press ENTER to install miniconda on the default location.

```
Miniconda3 will now be installed into this location:
/Users/jiwonkim/miniconda3

  - Press ENTER to confirm the location
  - Press CTRL-C to abort the installation
  - Or specify a different location below

[/Users/jiwonkim/miniconda3] >>> 
```

7. After the installation, type `yes` in to initialize conda.

```
Proceed with initialization? [yes|no]
[yes] >>> yes
no change     /Users/jiwonkim/miniconda3/condabin/conda
no change     /Users/jiwonkim/miniconda3/bin/conda
no change     /Users/jiwonkim/miniconda3/bin/conda-env
no change     /Users/jiwonkim/miniconda3/bin/activate
no change     /Users/jiwonkim/miniconda3/bin/deactivate
no change     /Users/jiwonkim/miniconda3/etc/profile.d/conda.sh
no change     /Users/jiwonkim/miniconda3/etc/fish/conf.d/conda.fish
no change     /Users/jiwonkim/miniconda3/shell/condabin/Conda.psm1
no change     /Users/jiwonkim/miniconda3/shell/condabin/conda-hook.ps1
no change     /Users/jiwonkim/miniconda3/lib/python3.13/site-packages/xontrib/conda.xsh
no change     /Users/jiwonkim/miniconda3/etc/profile.d/conda.csh
modified      /Users/jiwonkim/.bash_profile

==> For changes to take effect, close and re-open your current shell. <==

Thank you for installing Miniconda3!
```

8. The installation is complete. Delete the installer script.

```bash
rm Miniconda3-latest-MacOSX-arm64.sh
```

</details>

<details>

<summary>Miniconda installation for Windows (WSL)</summary>

1. Change the directory into `/mnt/c/Users/<username>/Downloads` to change current directory to where the installation script (`.sh`) is located. Change `<username>` into your username on your computer.

```bash
# Change directory
cd /mnt/c/Users/<username>/Downloads
```

2. Download the installer.

```bash
# Download the installer
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```

3. Make the script executable.

```bash
# Change permisson
chmod +x Miniconda3-latest-Linux-x86_64.sh
```

4. Run the script to install Miniconda3.

<pre class="language-bash"><code class="lang-bash"><strong># Run the installation script
</strong>./Miniconda3-latest-Linux-x86_64.sh
</code></pre>

5. Type `yes` to agree to the license terms.

```
Do you accept the license terms? [yes|no]
>>> yes
```

6. Press ENTER to install miniconda on the default location.

```
Miniconda3 will now be installed into this location:
/Users/jiwonkim/miniconda3

  - Press ENTER to confirm the location
  - Press CTRL-C to abort the installation
  - Or specify a different location below

[/Users/jiwonkim/miniconda3] >>> 
```

7. After the installation, type `yes` in to initialize conda.

```
Proceed with initialization? [yes|no]
[yes] >>> yes
no change     /Users/jiwonkim/miniconda3/condabin/conda
no change     /Users/jiwonkim/miniconda3/bin/conda
no change     /Users/jiwonkim/miniconda3/bin/conda-env
no change     /Users/jiwonkim/miniconda3/bin/activate
no change     /Users/jiwonkim/miniconda3/bin/deactivate
no change     /Users/jiwonkim/miniconda3/etc/profile.d/conda.sh
no change     /Users/jiwonkim/miniconda3/etc/fish/conf.d/conda.fish
no change     /Users/jiwonkim/miniconda3/shell/condabin/Conda.psm1
no change     /Users/jiwonkim/miniconda3/shell/condabin/conda-hook.ps1
no change     /Users/jiwonkim/miniconda3/lib/python3.13/site-packages/xontrib/conda.xsh
no change     /Users/jiwonkim/miniconda3/etc/profile.d/conda.csh
modified      /Users/jiwonkim/.bash_profile

==> For changes to take effect, close and re-open your current shell. <==

Thank you for installing Miniconda3!
```

8. The installation is complete. Delete the installer script.

```bash
rm Miniconda3-latest-Linux-x86_64.sh
```

</details>



After installation, **restart** your terminal (Terminal on macOS or WSL on Windows).&#x20;

You should now see `(base)` at the beginning of your command line.&#x20;

<figure><img src="../../.gitbook/assets/image (32).png" alt=""><figcaption></figcaption></figure>

This indicates that Conda is installed and the base environment is active.

### Create a new environment for JupyterLab

Instead of installing everything in the base environment, we will create a separate environment named `jupyter` for JupyterLab:

```bash
conda create -n jupyter -c conda-forge -c bioconda \
  python=3.11 \
  jupyterlab \
  r-base \
  r-irkernel \
  r-essentials \
  r-locfit \
  bioconductor-org.hs.eg.db \
  bioconductor-annotationdbi \
  bioconductor-keggrest -y
```

#### During installation

You may be prompted to confirm the installation.

<figure><img src="../../.gitbook/assets/image (33).png" alt=""><figcaption></figcaption></figure>

* Type `a` in and press enter twice to proceed.

Once the installation is complete, you will see messages like:

<figure><img src="../../.gitbook/assets/image (36).png" alt=""><figcaption></figcaption></figure>

Run the following code to activate the new environment.

```bash
conda activate jupyter
```

<figure><img src="../../.gitbook/assets/image (37).png" alt=""><figcaption></figcaption></figure>

Now you are in `jupyter` environment, as you can tell from `(jupyter)` at the beginning of the prompt.

Run JupyterLab:

```bash
jupyter lab
```

A browser window should open automatically showing the JupyterLab interface.

If it does not open, check the terminal for a URL (including a port number), for example:

<figure><img src="../../.gitbook/assets/image (38).png" alt=""><figcaption></figcaption></figure>

```
http://localhost:8888
```

Then copy and paste this address into your browser.

#### JupyterLab interface

You should now see the JupyterLab home page.

* The **left panel** is the file explorer
* On the **right-hand side**, you can create a new notebook

<figure><img src="../../.gitbook/assets/image (39).png" alt=""><figcaption></figcaption></figure>

To start a terminal, click **Terminal**.

<figure><img src="../../.gitbook/assets/image (41).png" alt=""><figcaption></figcaption></figure>

To start an R notebook, click **R**.

<figure><img src="../../.gitbook/assets/image (40).png" alt=""><figcaption></figcaption></figure>

You can type your code into the cells and press **Shift + Enter** to run it.

**Additional keys**

* **`Esc`** → enter command mode / stop editing&#x20;
* **`Enter`** → edit the cell
* `a` → add cell above&#x20;
* **`b`** → add cell below&#x20;
* `d` `d` → delete cell&#x20;
* `z` → undo cell deletion&#x20;
* **`Shift + Enter`** → run cell and move to next
* **`Ctrl + Enter`** → run cell (stay in place)
* `m` → convert cell to Markdown&#x20;
* `y` → convert cell to code
* `x` → cut cell
* `c` → copy cell
* `v` → paste below
