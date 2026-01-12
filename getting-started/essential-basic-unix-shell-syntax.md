---
icon: bullseye-arrow
---

# \[Essential] Basic UNIX Shell Syntax

There are a few things you **must** remember to use the command-line interface of UNIX Shell.



## 0. Understanding Command-Line Structure

In the terminal, **the first word you type is always the command** — it tells the computer **what action to perform**. Until you hit the **enter** button, you can type the **command line** in as long as you want.&#x20;

### Basic Structure of a Command Line:

```sh
command [options] [arguments]
```

#### Example:

```
head -n 2 file1.txt
```

`head` ⇒ **command**: print top 10 lines of a file

`-n 2` ⇒ **option**: change the number of lines to be printed into 2

`file1.txt` ⇒ **argument**: the file to be printed

* Options typically start with a dash (`-`), and you can use multiple options in a single command.
* You can also provide **multiple arguments** (e.g., several files).



## 1. Spaces Matter

**Spaces** separate commands and arguments.

For example:

```sh
cp file1.txt directory/
```

means "copy `file1.txt` to a folder called `directory`"

If you write `cp file 1.txt`  with a space in between, Linux thinks you're referring to two different things: `file` and `1.txt` .  If you need a space in your filename, use underscore: `cp file_1.txt`. If your file or folder name already has spaces, wrap it in quotes:`cp "file 1.txt"`



## 2. Shell is Case-Sensitive

`file.txt` ≠ `File.txt` — they are different files!



## 3. Navigating Paths

When you first log in, you'll be in your `$HOME` directory. You can navigate around directories from here.

There are two types of paths in Linux: Absolute and Relative.

1. **Absolute Path**: Full path from the root `/` , starts with /

```sh
cd /acfs/users/sejjimf/projects/rnaseq
```

2. **Relative path**: Based on your **current** directory&#x20;

```sh
cd ../nanoseq
```

* Move up one directory (parent directory): `cd ..`
* Move up two directories: `cd ../..`
* Go directly to a subdirectory: `cd ../`
* Go to current directory (no change): `cd .`&#x20;
* Go to your home directory: `cd ~`

Check where you are with `pwd`  and what's in there with `ls`.

```sh
pwd  ## Shows your current location
ls   ## Lists files and folders in the current directory
```



## 4. Learning Commands

Use `man` to learn about a command you haven't used before.&#x20;

```shell
man head  ## Shows description page of the command 'head'
```

The function, usage, and options will be described.

```
HEAD(1)                                                                         User Commands                                                                        HEAD(1)

NAME
       head - output the first part of files

SYNOPSIS
       head [OPTION]... [FILE]...

DESCRIPTION
       Print  the  first 10 lines of each FILE to standard output.  With more than one FILE, precede each with a header giving the file name.  With no FILE, or when FILE is
       -, read standard input.

       Mandatory arguments to long options are mandatory for short options too.

       -c, --bytes=[-]K
              print the first K bytes of each file; with the leading '-', print all but the last K bytes of each file

       -n, --lines=[-]K
              print the first K lines instead of the first 10; with the leading '-', print all but the last K lines of each file

       -q, --quiet, --silent
              never print headers giving file names

       -v, --verbose
              always print headers giving file names

       --help display this help and exit

       --version
              output version information and exit

       K may have a multiplier suffix: b 512, kB 1000, K 1024, MB 1000*1000, M 1024*1024, GB 1000*1000*1000, G 1024*1024*1024, and so on for T, P, E, Z, Y.

       GNU coreutils online help: <http://www.gnu.org/software/coreutils/> Report head translation bugs to <http://translationproject.org/team/>

AUTHOR
       Written by David MacKenzie and Jim Meyering.

COPYRIGHT
       Copyright © 2013 Free Software Foundation, Inc.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
       This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law.

SEE ALSO
       The full documentation for head is maintained as a Texinfo manual.  If the info and head programs are properly installed at your site, the command

              info coreutils 'head invocation'
 Manual page head(1) line 1 (press h for help or q to quit)
```

## 5. Comments

Anything written after a hash symbol (`#`) is treated as a comment and ignored by the computer.

For example, if you run the following two commands,&#x20;

```sh
echo Hello, World! 
echo Hello, # World! 
```

The output will be:

```
Hello, World! 
Hello,
```

The part after the `#` is considered a comment and is not executed.\
You can use comments to explain your code, which is especially helpful for others reading it—or for yourself when you come back to it later.

On this website, many code explanations are provided using comments, so keep an eye out for lines starting with `#` if you're looking for more context or information.



There are many other rules for using Linux commands, you can find more basic commands here:

{% embed url="https://github-pages.ucl.ac.uk/RCPSTrainingMaterials/HPCandHTCusingLegion/2_intro_to_shell.html" %}
UCL - Introduction to the UNIX shell (Overview)
{% endembed %}

{% embed url="https://linuxjourney.com/lesson/the-shell" %}
Linux Journey - Basic commands
{% endembed %}

{% embed url="https://linuxjourney.com/lesson/stdout-standard-out-redirect" %}
Linux Journey - Handling text data
{% endembed %}



## 💡 Using Language Models

If you are not sure about the accuracy of your command, we highly recommend using **language models such as** [**ChatGPT**](https://chatgpt.com/?model=auto) **or** [**Claude**](https://claude.ai/new) to catch mistakes that aren't easy to spot.

<figure><img src="../.gitbook/assets/Screenshot 2025-05-19 at 16.40.37.png" alt=""><figcaption></figcaption></figure>
