---
description: April 2026
icon: '1'
---

# Introduction to RNA-seq Analysis Part 1: Conda & Jupyter setup

Welcome to the Bioinformatics Hub workshop! In this session, we will explore a typical RNA-seq analysis workflow and set up the computational environment needed to run it.

To run the analysis, we will need an environment for running R code. For this, we will download and install [Jupyter](https://jupyter.org/) on your UCL JupyterHub.&#x20;

To begin, please access UCL JupyterHub with the following URL:

[https://jupyter.data-science.rc.ucl.ac.uk/](https://jupyter.data-science.rc.ucl.ac.uk/)

<figure><img src="../../.gitbook/assets/image (47).png" alt=""><figcaption></figcaption></figure>

You will be asked to log in - Please use your UCL ID and password to log in.

<figure><img src="../../.gitbook/assets/image (49).png" alt=""><figcaption></figcaption></figure>

Once you're successfully logged in, you will see Files tab as default.

Click New and select Terminal to open a new terminal, where we'll be working on today.

<figure><img src="../../.gitbook/assets/image (50).png" alt=""><figcaption></figcaption></figure>

This is the terminal, where we are going to type the commands to install and run conda on.

Please remember you can't use the mouse on this screen - anything you typed in can only be navigated/edited using the keyboard. Importantly, if you need to cancel any operation you've typed in, use Ctrl+C to halt (for both mac and windows).&#x20;

Now, let's begin installation on this screen.

## 1. Jupyter setup



### Install Miniconda

To install JupyterLab, you need `conda`.&#x20;

Conda is a tool that helps you install and manage software and their dependencies in **isolated environments**, so different tools don’t interfere with each other.

Download **Miniconda** from the installer below.&#x20;

```shellscript
# 1.1 Download miniconda installer
curl -O https://repo.anaconda.com/miniconda/Miniconda3-py310_25.1.1-0-Linux-x86_64.sh
```

Once the installation is complete, make the `.sh` file executable.

```bash
# 1.2 Change the permission of the installer
chmod +x Miniconda3-py310_25.1.1-0-Linux-x86_64.sh
```

Now, launch the installer.

```bash
# 1.3 Launch the installer
./Miniconda3-py310_25.1.1-0-Linux-x86_64.sh
```

<figure><img src="../../.gitbook/assets/image (51).png" alt=""><figcaption></figcaption></figure>

The installer is running. To continue, press `ENTER`.

<figure><img src="../../.gitbook/assets/image (52).png" alt=""><figcaption></figcaption></figure>

When you see this ToS, press `q` to quit.

<figure><img src="../../.gitbook/assets/image (53).png" alt=""><figcaption></figcaption></figure>

Then type `yes` and `ENTER`  to agree to the license terms.

<figure><img src="../../.gitbook/assets/image (54).png" alt=""><figcaption></figcaption></figure>

Press `ENTER` to confirm the installation location.

<figure><img src="../../.gitbook/assets/image (55).png" alt=""><figcaption></figcaption></figure>

Type `yes` and `ENTER` to automatically activate Conda when logging in.

<figure><img src="../../.gitbook/assets/image (56).png" alt=""><figcaption></figcaption></figure>

The installation is complete. Run the following code to apply changes.

```bash
# 1.4 Run .bashrc to apply changes
source ~/.bashrc
```

You should now see `(base)` at the beginning of your command line. This indicates that Conda is installed and the base environment is active.

When you are done with installation, delete the installer file.

```bash
# 1.5 Delete the installer
rm Miniconda3-py310_25.1.1-0-Linux-x86_64.sh
```



#### Installing miniconda on laptops

<details>

<summary>Miniconda installation for macOS (arm64)</summary>

1. Change into home directory.

```bash
cd ~
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

1. Change the directory into `/mnt/c/Users/<username>` to change current directory to the home directory. Change `<username>` into your username on your computer.

```bash
# Change directory
cd /mnt/c/Users/<username>
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



### Create a new environment for DESeq2

Instead of installing everything in the base environment, we will create a separate environment named `DESeq2` for JupyterLab.

Before we start, upload the environment file to duplicate the DESeq2 environment on your server.

{% file src="../../.gitbook/assets/deseq2.txt" %}



```bash
# 1.6 Create a new conda environment for DESeq2
conda create --name deseq2 --file deseq2.txt
```



<figure><img src="../../.gitbook/assets/image (58).png" alt=""><figcaption></figcaption></figure>

Once the installation is complete, go back to Files tab and you'll see the R kernel added.

### JupyterHub interface

<figure><img src="../../.gitbook/assets/image (59).png" alt=""><figcaption></figcaption></figure>

You will now see the R kernel alongside your file explorer. Click on **R \[conda env:miniconda3-deseq2]** to open an R notebook.

<figure><img src="../../.gitbook/assets/image (60).png" alt=""><figcaption></figcaption></figure>

This is the R notebook where we'll be running R codes.

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



#### JupyterLab interface

You should now see the JupyterLab home page.

* The **left panel** is the file explorer
* On the **right-hand side**, you can create a new notebook

<figure><img src="../../.gitbook/assets/image (39).png" alt=""><figcaption></figcaption></figure>

To start a terminal, click **Terminal**.

<figure><img src="../../.gitbook/assets/image (41).png" alt=""><figcaption></figcaption></figure>

To start an R notebook, click **R**.

<figure><img src="../../.gitbook/assets/image (40).png" alt=""><figcaption></figcaption></figure>

