---
icon: window
---

# Interactive sessions

Instead of submitting job scripts to the scheduler, you can **directly connect to compute nodes** through **interactive sessions**. This approach is more suitable for running software applications that require immediate feedback based on their output.

To start an interactive session, connect to the compute nodes using `qrsh` from the login node.

For example:

```sh
qrsh -pe mpi 8 -l mem=512M,h_rt=2:00:00 -now no
```

This command requests **8** CPUs, **512 MB** of RAM per core, and **two hours** of wall time. You can adjust these parameters as needed.

<figure><img src="../.gitbook/assets/image (23).png" alt=""><figcaption></figcaption></figure>

After entering the command, there may be a delay before you are connected to the compute node and the terminal responds, as the request must wait to be scheduled—just like batch jobs. To cancel the request while it is waiting, press **Ctrl+C**.

<figure><img src="../.gitbook/assets/image (25).png" alt=""><figcaption></figcaption></figure>

The  `-now no` option is added for the time when the cluster is busy. By default, `qrsh` will run on the next scheduling cycle or give up. The `-now no` allows your job to wait until it gets scheduled.



<figure><img src="../.gitbook/assets/image (22).png" alt=""><figcaption></figcaption></figure>

Once connected to a compute node, you can confirm it by checking the prompt in your console.\
On a login node, it will look something like either:

{% columns %}
{% column %}
```
[smgxxxx@login12 ~]$  
```
{% endcolumn %}

{% column %}
```
[smgxxxx@login13 ~]$  
```
{% endcolumn %}
{% endcolumns %}

On a compute node, it will instead display the node’s name, for example:

```
[smgxxxx@node-d00a-128 ~]$  
```

You will have access to the same file system as on the login node. However, note that **ACFS is unwritable** from compute nodes.

When the requested wall time expires, the session will automatically close. You can start a new session at any time, but make sure to request enough time for your process to complete—otherwise, any unsaved progress will be lost.



#### Reference

[UCL Research Computing: Interactive Job Sessions](https://www.rc.ucl.ac.uk/docs/Interactive_Jobs/)
