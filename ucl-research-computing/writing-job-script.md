---
icon: subtitles
---

# Writing job script

In the previous session, we learned about the structure of a computing cluster, specifically that of Myriad's.

Here we show you how to write and submit job scripts from a login node to a job scheduler.

## Job scheduler

A **job scheduler** is a software tool that manages how jobs are run on a computing cluster. When you submit a job script from the **login node**, the scheduler decides **when and where** to run it on the **compute nodes**.

It plays a crucial role in allowing **hundreds of users** to share limited resources—like CPUs and RAM—efficiently.

Once you submit a job, the scheduler:

1. **Queues** your job.
2. **Reserves** the resources you requested (CPU, memory, time).
3. **Launches** the job when those resources become available.
4. **Tracks** the job while it runs, logging progress and usage.

Think of the whole process like placing an order at a coffee shop:

| Coffee shop               | Cluster                  |
| ------------------------- | ------------------------ |
| You place a coffee order. | You submit a job script. |
| The cashier queues it.    | Job scheduler queues it. |
| Barista makes coffee.     | Compute node runs job.   |
| You get your drink.       | You get your output.     |



## Job script

A **job script** is just a set of instructions you write in a text file to tell a computer cluster **what kind of resources you need** and **what commands to run**.

### Resources you can ask for:

* CPUs (Up to 36)
* RAM
* Temporary directory size
* Walltime



You can request the resources using this job script template:

<pre class="language-sh"><code class="lang-sh">#!/bin/bash -l

# Request 24 hours of wallclock time (format hours:minutes:seconds).
<strong>#$ -l h_rt=24:0:0
</strong>
# Request 8 gigabyte of RAM for each core/thread 
# (must be an integer followed by M, G, or T)
<strong>#$ -l mem=8G
</strong>
# Request 100 gigabyte of TMPDIR space (default is 10 GB - remove if cluster is diskless)
<strong>#$ -l tmpfs=100G
</strong>
# Set the name of the job.
<strong>#$ -N rnaseq
</strong>
# Request 12 cores.
<strong>#$ -pe smp 12
</strong>
# Set the working directory to somewhere in your scratch space.
# Replace "&#x3C;smgxxxx>" with your UCL user ID
<strong>#$ -wd /home/&#x3C;smgxxxx>/projects/rnaseq
</strong>
# Run the application.
<strong>nextflow pull nf-core/rnaseq
</strong><strong>nextflow run nf-core/rnaseq -profile test
</strong></code></pre>

You can change the resources setting as you wish by using this template.&#x20;

<details>

<summary>How to run GPU jobs</summary>

If your application requires **Graphics Processing Units (GPUs)** instead of standard **CPUs**, you can modify your job script as follows:

<pre class="language-sh"><code class="lang-sh">#!/bin/bash -l

# Request 24 hours of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=24:0:0

# Request 8 gigabyte of RAM for each core/thread 
# (must be an integer followed by M, G, or T)
#$ -l mem=8G

# Request 100 gigabyte of TMPDIR space (default is 10 GB - remove if cluster is diskless)
#$ -l tmpfs=100G

# Set the name of the job.
#$ -N rnaseq

# Request a number of GPU cards, in this case 2 (the maximum)
<strong>#$ -l gpu=2
</strong>
# Set the working directory to somewhere in your scratch space.
# Replace "&#x3C;smgxxxx>" with your UCL user ID
#$ -wd /home/&#x3C;smgxxxx>/projects/gpujob

# load the cuda module (in case you are running a CUDA program)
<strong>module unload compilers mpi
</strong><strong>module load compilers/gnu/4.9.2
</strong><strong>module load cuda/7.5.18/gnu-4.9.2
</strong>
# Change into temporary directory to run work
<strong>cd $TMPDIR
</strong>
# Run the application.
<strong>mygpucode
</strong>
# Preferably, tar-up (archive) all output files onto the shared scratch area
<strong>tar zcvf $HOME/projects/gpujob/files_from_job_$JOB_ID.tar.gz $TMPDIR
</strong>
# Make sure you have given enough time for the copy to complete!
</code></pre>

`$TMPDIR` is a **temporary local disk space physically attached to the compute node**, which provides much **faster input/output (I/O)** than shared network storage. It's ideal for storing large intermediate files or temporary output during your job.

However, this space is **automatically wiped** once the job finishes. Therefore, any important output must be **archived and copied** to your persistent storage area (e.g., `$HOME/Scratch/`) **before the job ends**.

</details>

### qsub

Once you're done setting the resources, you can put the command you wish to run and save this file as a job script - i.e. `jobscript.sh`. This is the format the scheduler accepts. You can send it to the scheduler using `qsub`.

```sh
qsub jobscript.sh
```

### qstat

Once you submit a job, you can monitor it with `qstat`.

```sh
qstat
```

The output will look something like this:

```
job-ID  prior   name       user         state submit/start at     queue                          slots ja-task-ID 
-----------------------------------------------------------------------------------------------------------------
123454 2.00685 DI_m3      smgxxxx      Eqw   10/13/2025 15:29:11                                    12 
123456 2.00685 DI_m3      smgxxxx      r     10/13/2025 15:29:11 Bran@node-b00a-001                 24 
123457 2.00398 DI_m2      smgxxxx      qw    10/12/2025 14:42:12                                    1 
```

This shows you the job ID, the numeric priority the scheduler has assigned to the job, the name you have given the job, your username, the state the job is in, the date and time it was submitted at (or started at, if it has begun), the head node of the job, the number of 'slots' it is taking up, and if it is an array job the last column shows the task ID.

**Job states**

* `qw`: queueing, waiting
* `r`: running
* `Rq`: a pre-job check on a node failed and this job was put back in the queue
* `Rr`: this job was rescheduled but is now running on a new node
* `Eqw`: there was an error in this jobscript. This will not run.
* `t`: this job is being transferred
* `dr`: this job is being deleted

Many jobs cycling between `Rq` and `Rr` generally means there is a dodgy compute node which is failing pre-job checks, but is free so everything tries to run there. In this case, let us know and we will investigate.

If a job stays in `t` or `dr` state for a long time, the node it was on is likely to be unresponsive - again let us know and we'll investigate.

A job in `Eqw` will remain in that state until you delete it - you should first have a look at what the error was with `qexplain`.

```sh
qexplain 123454
```

### qdel

You use `qdel` to delete a job from the queue.

```
qdel 123454
```

You can also delete all your jobs at once:

```
qdel '*'
```



Reference:

[UCL Research Computing: How do I submit a job to the scheduler?](https://www.rc.ucl.ac.uk/docs/howto/#how-do-i-submit-a-job-to-the-scheduler)
