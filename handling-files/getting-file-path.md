---
icon: folder
---

# Getting file path

A **path** is like an **address** for a file. To work with files, you need to know their path so the computer can locate them precisely.

## Path Structure

Path structures differ depending on your operating system.

{% tabs %}
{% tab title="UNIX" %}
* **Root Directory**: `/`
  * Everything begins from the root (`/`).
* **Standard Directories**:
  * `/home`: user home directories (e.g., `/home/alice`)
  * `/tmp`: temporary files
  * `/myriadfs` : File system on Myriad
* **Path Separator**: `/`
* **Case Sensitivity**: **Case-sensitive**
* **Absolute vs. Relative Paths**:
  * Absolute: `/etc/passwd`
  * Relative: `../Documents`
{% endtab %}

{% tab title="macOS" %}
* **Root Directory**: `/` (Same as UNIX, since macOS is UNIX-based)
* **Standard Directories**:
  * `/Users`: user home directories (e.g., `/Users/john`)
  * `/Volumes`: mounted volumes (external drives, network shares)
* **Path Separator**: `/`
* **Case Sensitivity**: **Usually case-insensitive**, but depends on filesystem formatting (HFS+ vs APFS)
* **Absolute vs. Relative Paths**:
  * Absolute: `/Users/john/Documents`
  * Relative: `Documents/notes.txt`
{% endtab %}

{% tab title="Windows" %}
* **Root Structure**: Drive letters (e.g., `C:\`, `D:\`)
  * Each partition or device has its own namespace.
* **Standard Directories**:
  * `C:\Windows`: core OS files
  * `C:\Program Files` and `C:\Program Files (x86)`: installed applications
  * `C:\Users`: user profiles (e.g., `C:\Users\Alice`)
  * `C:\Temp` or `%TEMP%`: temporary files
* **Path Separator**: `\` (Backslash)
  * If you are using **R** on Windows, the Path Separator is `\\`.&#x20;
  * Example: `C:\\Users\\Alice\\Documents\\file.txt`
* **Case Sensitivity**: **Case-insensitive** by default (but NTFS is case-preserving)
* **Absolute vs. Relative Paths**:
  * Absolute: `C:\Users\Alice\Documents\file.txt`
  * Relative: `..\Documents\file.txt`
{% endtab %}
{% endtabs %}



## Getting full path of files/directories

{% tabs %}
{% tab title="UNIX" %}
1.  If you're already in the directory:

    ```bash
    realpath file.txt
    ```
2.  Or specify the relative path:

    ```sh
    realpath ../file.txt
    ```
3. Shell will return the path of the file.

```
/myriadfs/home/sejjimf/file.txt
```
{% endtab %}

{% tab title="macOS" %}
**Using Finder**

1. Open **finder** and select your file with a single click.
2. Press **Option ⌥** to reveal the Path Bar on the bottom of the window.&#x20;
3.  Control click on the name of the file and click **Copy \[filename] as Pathname**.

    <figure><img src="../.gitbook/assets/image (14).png" alt=""><figcaption></figcaption></figure>
4. Paste it anywhere (Terminal, text editor) to see the full path.



**Using Terminal**

You can also use **Terminal** on Mac.&#x20;

Navigate to file’s directory or reference it directly:

```bash
realpath file.txt
```

(macOS might need `brew install coreutils` for GNU `realpath`.)
{% endtab %}

{% tab title="Windows" %}
1. Open **File Explorer** and select your file with a single click.
2. Right-click and click **Copy as path**.
3. Paste it anywhere (Terminal, text editor) to see the full path.

For more information: [https://www.sony.com/electronics/support/articles/00015251](https://www.sony.com/electronics/support/articles/00015251)
{% endtab %}
{% endtabs %}

Remember, you can also get the path to directories. Now paste the file path into your code so the computer can locate the file.

