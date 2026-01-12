---
icon: play
---

# Resuming a pipeline run

When running **nf-core pipelines**, you may encounter situations where the pipeline does not finish and instead aborts due to an error in one of the processes. After [fixing the error,](../handling-errors/errors-and-warnings.md) you will likely want to re-run the pipeline. However, if you simply execute:

```sh
nextflow run nf-core/<pipeline>
```

the pipeline will restart from the very beginning. This means that processes which already completed successfully in the previous run will be executed again, wasting both time and resources.

To avoid this, Nextflow provides the **`-resume`** option. This allows you to restart a pipeline without re-running tasks that were previously completed successfully. Nextflow stores intermediate results for each process in the `./work/` directory. If the same task has already been executed with the same script, inputs, and parameters, Nextflow will reuse the cached outputs instead of recomputing them. Only tasks that have changed—or tasks downstream of those changes—will be re-executed.

To use this option, simply add `-resume` to your Nextflow command:

```sh
nextflow run nf-core/nanoseq \  
    --input samplesheet.csv \  
    --protocol cDNA \           
    --outdir result \
    -profile singularity \
    -c nextflow.config \
    -resume                   // option to reuse the cached results
```

{% hint style="info" %}
Unlike pipeline-specific options (which often use `--`), Nextflow runtime options such as `-resume` use a **single dash**.
{% endhint %}

