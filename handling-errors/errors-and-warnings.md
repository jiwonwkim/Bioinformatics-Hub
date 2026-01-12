---
icon: triangle-exclamation
---

# Errors and Warnings

There are two types of obstacles you may face during computational analysis: **Errors** and **Warnings**.&#x20;

## 🔴 **Errors**

**Errors** are **critical issues** that prevent the program or script from continuing to run. Execution **stops immediately** when an error is encountered.

* **Examples:**
  *   In Python:

      ```python
      print(undeclared_variable)
      ```

      → `NameError: name 'undeclared_variable' is not defined`
  *   In Bash:

      ```bash
      cd /nonexistent/directory
      ```

      → `bash: cd: /nonexistent/directory: No such file or directory`

Errors **must be fixed** before the code can proceed.



## 🟡 **Warnings**

**Warnings** are **non-critical messages** that alert you to potential problems, but **do not stop execution**. The program continues to run, but something may not work as expected.

* **Examples:**
  *   In R:

      ```r
      log(-1) # Calculating log(-1)
      ```

      → `Warning message: NaNs produced`
  *   In Python (with NumPy):

      ```python
      import numpy as np
      np.sqrt(-1) # Calculating square root of -1
      ```

      → `RuntimeWarning: invalid value encountered in sqrt`

You can usually **keep running the code**, but it’s a good idea to investigate the cause of the warning if the program doesn't work as you expected.



## Fixing errors

There are a few ways to fix errors.&#x20;

### 1. Read the error message carefully

Error messages are often very specific and tell you exactly what and where is wrong.

* **What kind of error is it?**
  * Syntax? File not found? Type mismatch?
* **Where is it happening?**
  * Look for line numbers, file names, and variable names.

### 2. Check for common mistakes

There are examples of common mistakes:

**In Bash:**

* `command not found`: You might have a typo or forgot to install a tool.
* `No such file or directory`: Your file path is wrong or the file doesn’t exist.

**In Python:**

* `NameError`: You used a variable that doesn’t exist.
* `TypeError`: You're using the wrong type (e.g., adding a string to an int).

**In R:**

* `object not found`: You forgot to define a variable or load a package.
* `NA/NaN`: You're operating on missing or invalid values.

### 3. Reproduce the error in a minimal example&#x20;

Strip your code down to the part **where exactly the error happens**. Try running just that part to isolate the issue. This helps you debug faster without being distracted by unrelated code.

### 4. Search the error message

Copy and paste the error message into **Google, Stack Overflow, GitHub issues** (if using a package or tool), etc. It is often the case that someone has had the same error before and solved it.

Copying the error message into a large language model like **ChatGPT**, **Claude**, or others is a very effective way to understand and fix the problem. By explaining **what code you used, which environment you're working on (e.g. Linux, Python, R, etc.), and what error message you got**, you get contextual understanding of the nature of the error. In some cases, they can even provide you with **alternative code** you can use.&#x20;

{% columns %}
{% column %}
{% embed url="https://chatgpt.com/?model=auto" %}


{% endcolumn %}

{% column %}
{% embed url="https://claude.ai/new" %}


{% endcolumn %}
{% endcolumns %}
