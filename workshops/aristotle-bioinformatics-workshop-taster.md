---
description: This taster workshop is for IoO Lates mini workshop on 29th January 2026.
icon: '0'
---

# Aristotle: Bioinformatics workshop taster

## Welcome to bioinformatics taster session!

In this session, we are going to learn:

1. What is a remote server
2. How to access a remote server (Aristotle)
3. How to open R/Python on a remote server
4. How to run a code on a remote server



## What is a remote server?

A **remote server** is a powerful computer located elsewhere that you can access over the internet. It has lots of storage and processing power, so it can handle big bioinformatics tasks like analyzing genomes, aligning sequences, and more.

You can connect to a remote server from your own computer (desktop or laptop) using tools like **SSH**, a secure login method. Once connected, you can run commands and programs on the server. In most cases, interacting with a remote server is done through the **command-line interface (CLI)**, which means there are no graphical icons—everything is typed as commands. (Don't panic!)



## UCL Aristotle

**UCL Aristotle** is a Linux-based compute service for practicing the command-line interface. Anyone with a UCL user ID and within the UCL institutional firewall can access Aristotle with the following command on **Terminal (macOS)** or **Powershell (Windows)**:

```bash
ssh smgxxxx@aristotle.rc.ucl.ac.uk
```

`smgxxxx` is your UCL ID.

After running the command, you'll be asked to enter your password:

```
smgxxxx@aristotle.rc.ucl.ac.uk's password: 
```

Type your UCL password in. Nothing will appear on the screen while typing—this is normal. Just type it and press Enter.

If you enter it incorrectly, you’ll see:

```
Permission denied, please try again.
smgxxxx@aristotle.rc.ucl.ac.uk's password:
```

and you can try again.

Once the correct password is entered, you will now see the **bash prompt**, which usually starts with `bash-4.2$`:

<pre><code>Last failed login: Mon Jan 12 15:22:57 GMT 2026 from xx.xx.x.x on ssh:notty
There were 1 failed login attempts since the last successful login.
Last login: Thu Jan  8 13:33:07 2026 from xx.xx.x.x
-bash-4.2<a data-footnote-ref href="#user-content-fn-1">$</a> 
</code></pre>

This means you are now logged into Aristotle and can run commands on the remote server.

<details>

<summary>If you’re unsure whether you’re using <code>bash</code></summary>

`bash` might not be the default shell on Aristotle. To check which shell you’re currently using, type:

```bash
 echo $0
```

This will display your current shell, for example: `sh`, `csh`, or `bash`.

To switch to Bash, simply type:

```bash
bash
```

and press **Enter**. Your prompt will now be in Bash.

</details>



## How to open Python/R on Aristotle

### Python

To open Python prompt, you have to load the python module first.

```bash
module load gcc-libs python3/recommended
python3
```

```
Python 3.9.10 (main, Feb  9 2022, 13:29:07) 
[GCC 4.9.2] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
```

If you see `>>>`, this means you're now on python prompt, and the commands must be in Python syntax.&#x20;

For example, if you wish to print a string "Hello!", you now have to type `print("Hello!")` instead of `echo "Hello!"`, which is a bash syntax.

If you wish to exit the prompt:

```python
>>> quit()
```

will take you back to the bash prompt.

### R

Opening R prompt is similar to opening a Python one, you need to load the r module first.

```bash
module load r/recommended
R
```

```
R version 4.2.0 (2022-04-22) -- "Vigorous Calisthenics"
Copyright (C) 2022 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> 
```

If you see `>`, this means you're now on R prompt. Again, the syntax now has to be adjusted to R.&#x20;

If you wish to exit the prompt, type the following command:

```r
q()
```

```
Save workspace image? [y/n/c]: 
```

and type `n` in not to save workspace image.&#x20;



## Downloading reference genome

[^1]: Bash prompt
