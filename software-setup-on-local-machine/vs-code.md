---
icon: display-code
---

# VS Code

**Visual Studio Code** is a versatile editor that can connect to remote servers and facilitate file transfer between the server and your local device. You can't use VS Code on Myriad, but you can use it on **Kathleen** or your **local servers**.

Here's how to set VS Code up for your research.

{% stepper %}
{% step %}
### Install VS code

Download VS Code [here](https://code.visualstudio.com/) and install the version for your operating system.
{% endstep %}

{% step %}
### Install Extensions

<figure><img src="../.gitbook/assets/Untitled 2 (2).png" alt=""><figcaption></figcaption></figure>

Open VS Code and go to the **Extensions** view on left sidebar.

Search for Remote-SSH and click install.
{% endstep %}

{% step %}
### Connect to Kathleen vis SSH

<figure><img src="../.gitbook/assets/image (26).png" alt=""><figcaption></figcaption></figure>

Click on the Remote-SSH Extension on the sidebar, click the New Remote button next to SSH tab, and type the ssh command into the command window.

```sh
ssh -J [Your UCL ID]@ssh-gateway.ucl.ac.uk [Your UCL ID]@login21.kathleen.rc.ucl.ac.uk
```



{% hint style="info" %}
**-J** stands for proxy jump, it allows you to access UCL computers outside of UCL network.
{% endhint %}

<figure><img src="../.gitbook/assets/Untitled 3.png" alt=""><figcaption></figcaption></figure>

If it asks you for the SSH configuration file, you can press enter to choose the first one.

<div><figure><img src="../.gitbook/assets/Screenshot 2025-09-08 at 14.15.02 (1).png" alt=""><figcaption></figcaption></figure> <figure><img src="../.gitbook/assets/hostaddeed.png" alt=""><figcaption></figcaption></figure></div>

You'll be able to see **login21.kathleen.rc.ucl.ac.uk** on your SSH host list.

You can also use **login22.kathleen.rc.ucl.ac.uk** but not the other login nodes of Kathleen.
{% endstep %}

{% step %}
### Use the SSH Terminal

<figure><img src="../.gitbook/assets/image (30).png" alt=""><figcaption></figcaption></figure>

Click the rignt arrow next to **login21.kathleen.rc.ucl.ac.uk** to start a new Kathleen session.

<figure><img src="../.gitbook/assets/Screenshot 2025-09-08 at 14.49.08.png" alt=""><figcaption></figcaption></figure>

Enter your UCL password and wait until VS Code is set up on Kathleen. It may take a few minutes. When the connection is complete but you don't see the terminal, try `` control + ` `` or click `View > Terminal` from the top bar.

<figure><img src="../.gitbook/assets/Screenshot 2025-09-08 at 15.21.29.png" alt=""><figcaption></figcaption></figure>

Now you will see the terminal on the bottom panel.
{% endstep %}

{% step %}
### Transfer Files

You can exchange files with Kathleen directly using VS Code.&#x20;

<figure><img src="../.gitbook/assets/Screenshot 2025-09-08 at 15.25.10 (1).png" alt=""><figcaption></figcaption></figure>

Click on the Explorer icon on VS Code and click **Open Folder**.&#x20;

<figure><img src="../.gitbook/assets/Screenshot 2025-09-08 at 15.27.24.png" alt=""><figcaption></figcaption></figure>

Select the directory you want to open on the explorer. If you are not sure, set it to `/home/smgxxxx/`.&#x20;

<figure><img src="../.gitbook/assets/Screenshot 2025-09-08 at 15.41.17.png" alt=""><figcaption></figcaption></figure>

You now can explore your files and directories on VS Code. You can also edit and save files on Kathleen directly from VS Code using the editor on the top panel.&#x20;
{% endstep %}
{% endstepper %}
