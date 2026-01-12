---
icon: server
---

# Understanding Myriad Structure

In a lot of examples on Bioinformatics Hub, you will be using **Myriad**. Myriad is a **computing cluster service** provided by **UCL Advanced Research Computing Centre**.&#x20;

## Computing cluster

A **computing cluster** is a group of connected computers (called **nodes**) that work together to do large or complex tasks—often faster and more efficiently than a single computer could.

<figure><img src="../.gitbook/assets/Myriad structure (3).png" alt=""><figcaption></figcaption></figure>

In a typical cluster, there are two main types of nodes:

### Login nodes

**Login nodes** are the computer you connect to. You write your code, manage your files, and **submit jobs to compute nodes to run**. Login nodes are not meant for running heavy computations, such as bioinformatics. They are shared among all users and have strict resource limits—typically 6 CPUs and 30 GB of memory. Exceeding these limits may result in penalties, including reduced access to resources for a period of time.

Myriad has two login nodes: `login12.myriad.rc.ucl.ac.uk` and `login13.myriad.rc.ucl.ac.uk`. There are no difference between the two nodes. When facing slowering in one login node due to bottleneck, you can use another login node by using `ssh`.

```sh
# Connect to login12 node
ssh smgxxxx@login12.myriad.rc.ucl.ac.uk
# Connect to login13 node
ssh smgxxxx@login13.myriad.rc.ucl.ac.uk
```

If you don't specify a specific node, you will be **randomly** connected to one of the login nodes.&#x20;

```sh
## Connect to random login node
ssh smgxxxx@myriad.rc.ucl.ac.uk
```

### Compute nodes

Compute nodes are those actually run your jobs. You don't have to connect to them directly. Instead, you **submit your job from the login node**, and the cluster decide which compute nodes to use. These nodes are powerful enough to process large data and perform complicated calculations.&#x20;

To submit jobs to the computing nodes, you have to [write a job script](writing-job-script.md) and submit it using `qsub`from a login node.

```sh
qsub myscript.sh
```

Once you submit your job, your job scheduler will find available compute nodes and run the script once the nodes are ready. You can check the status of the run using `qstat`.

```sh
qstat
```

```
$ qstat
job-ID  prior   name       user         state submit/start at     queue                          slots ja-task-ID 
-----------------------------------------------------------------------------------------------------------------
  98663 3.50000 test1      sejjimf      r     07/29/2025 03:45:52 Bran@node-b00a-003                36        
 103210 2.70361 test2      sejjimf      qw    07/29/2025 13:42:02                                   36    
```

You can also connect directly to compute nodes using `qrsh`; this is known as an [interactive session](interactive-sessions.md).



### Disks (Storages)

Disks are not computing nodes, they are for storing data. In a computing cluster, there are usually multiple types of disks, each with different purposes, speeds, and access rules.

#### Home directory (`/home/smgxxxx` , `~`, `$HOME`)

Home directory is the directory you are in when you log in. You can make directories below home directory for different purposes:

* Project directory `/home/smgxxxx/projects` to allocate a directory per each project
* Software directory `/home/smgxxxx/software` to download and install software

#### Scratch space (`/home/smgxxxx/Scratch`)

In many clusters, Scratch space has separate file system and faster input/output speed for optimal software run. Hence, they are optimal for project directories. However on Myriad, Scratch space is no different from home directory, as it sits under the home directory.

#### Temporary storage for jobs (`$TMPDIR`)

While compute nodes begin your job, `$TMPDIR` is created on the compute node and deleted when it ends.   You can adjust the size of temporary storage with your job script.&#x20;

#### ARC Cluster File Systems (ACFS; `/acfs/users/smgxxxx/`)

Unlike home directory, ACFS is available from multiple ARC systems and backed up.&#x20;

The ACFS is read-only from a compute node, meaning the compute nodes can't write the output files on ACFS. It is ideal for important data backup or storing reference genome data, as they are only meant to be read, not modified.



Reference:

[UCL Research Computing Documentation](https://www.rc.ucl.ac.uk/docs/)

