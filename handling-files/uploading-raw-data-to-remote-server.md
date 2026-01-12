---
icon: files
---

# Uploading raw data to remote server

Now that you've learned what kinds of information are stored in your raw data, you want to import your data to Myriad for processing and downstream analysis. In this session we present two different ways to upload files from your computer to Myriad filesystem.



## Making a project directory

Before we start, we are going to set up directory structure for efficiency and conveniency.  You can change the name of the project directory as you intend.

```sh
## Make the project directory with a data directory below
mkdir -p ~/projects/[Your Project Name]/data/fastq
## Move to the project directory
## — this is the working directory where we'll be running anlaysis
cd ~/projects/[Your Project Name]
```



## Transferring files to Myriad

### Using command-line&#x20;

If you are storing your raw data on a **remote server (RDSS, e.g.)**, you can use a simple command to transfer files from one server to another.

`scp` allows you to copy files across servers using SSH.&#x20;

```sh
scp [Path to Your Files]/*.fq.gz [Your UCL ID]@myriad.rc.ucl.ac.uk:~/projects/[Your Project Name]/data/fastq
```

The command is long, but it's actually a single command that does the job.

Don't forget to put colon `:` after **myriad.rc.ucl.ac.uk**, as it tells the system you want these files to be stored in the following directory.



### Using Cyberduck

If you have the raw data on your computer or a hard drive, you can upload it via graphical interface using Cyberduck.

1.  Click on **projects** directory.

    <figure><img src="../.gitbook/assets/Screenshot 2025-05-19 at 18.15.41 (1).png" alt=""><figcaption></figcaption></figure>
2.  Go to the fastq directory below your project directory.

    <div><figure><img src="../.gitbook/assets/Screenshot 2025-05-19 at 18.15.54.png" alt=""><figcaption></figcaption></figure> <figure><img src="../.gitbook/assets/Screenshot 2025-05-19 at 18.16.17.png" alt=""><figcaption></figcaption></figure> <figure><img src="../.gitbook/assets/Screenshot 2025-05-19 at 18.16.21 (1).png" alt=""><figcaption></figcaption></figure></div>
3.  Drag and drop your raw fastq files to the directory.

    <figure><img src="../.gitbook/assets/Screenshot 2025-05-12 at 16.45.14.png" alt=""><figcaption></figcaption></figure>
4. Your files are ready, you can use the command `ls` to check the files on terminal.

```sh
## Change into project directory
cd ~/projects/rnaseq
## List all the files in the data/fastq directory
ls -halt data/fastq
```

<figure><img src="../.gitbook/assets/Screenshot 2025-05-19 at 18.21.29.png" alt=""><figcaption></figcaption></figure>

