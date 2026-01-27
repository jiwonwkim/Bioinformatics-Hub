---
icon: 'n'
---

# Nightingale nuclear magnetics resonance (NMR) #1: Load data

Below is an example of using `tidyverse` and `ggforestplot` to interpretate Nightingale NMR data. You can find the original tutorial document [here](https://nightingalehealth.github.io/ggforestplot/articles/nmr-data-analysis-tutorial.html).



{% stepper %}
{% step %}
### Install and load packages

You need to install  R packages `tidyverse` and `ggforestplot` if they are not already installed on your R.

```r
# Set working directory
setwd("/Users/john/Documents/Projects/Nightingale")

# Install packages
install.packages("tidyverse")
install.packages("devtools")
devtools::install_github("NightingaleHealth/ggforestplot")")

# Load packages
library(tidyverse)
library(ggforestplot)
```
{% endstep %}

{% step %}
### Import NMR result file

Import your result file and save the data into `df_nmr_results`.

<pre class="language-r"><code class="lang-r"># Read the biomarker concentration file
df_nmr_results &#x3C;- readr::read_csv(
<strong>  ##################################################
</strong><strong>  # Enter the correct location for your file below #
</strong><strong>  ##################################################
</strong><strong>  file = "Projects/Nightingale/metabolomics_data/12345-Results.csv", 
</strong>  # Set not only NA but TAG string as &#x3C;NA> 
  na = c("NA", "TAG"), 
  col_types = cols(.default = col_double(), 
                   Sample_id = col_character())
)
</code></pre>

{% hint style="info" %}
Please provide the correct location for your **NMR result** file. If you are unaware of how to find the file path, click [here](https://ucl-ioo-bioinformatics-hub.gitbook.io/ioo-bioinformatics-hub/handling-files/getting-file-path).
{% endhint %}
{% endstep %}

{% step %}
### Rename alternative biomarker names

Try checking the names of the biomarkers in your data frame.

```r
# Print the names of metabolites in df_nmr_results
names(df_nmr_results)
```

If your biomarkers names aren't recognizable, you may want to rename the metabolites in your data frame. Even when it is already recognizable, you can run the following code to ensure smooth run of following steps.

```r
# Assume that your data frame, containing alternative biomarker names, 
# is called df_nmr_results_alt_names

alt_names <- 
  names(df_nmr_results)

new_names <- 
  alt_names %>% 
  purrr::map_chr(function(id) {
    # Look through the alternative_ids
    hits <-
      purrr::map_lgl(
        df_NG_biomarker_metadata$alternative_names,
        ~ id %in% .
      )

    # If one unambiguous hit, return it.
    if (sum(hits) == 1L) {
      return(df_NG_biomarker_metadata$machine_readable_name[hits])
      # If not found, give a warning and pass through the input.
    } else {
      warning("Biomarker not found: ", id, call. = FALSE)
      return(id)
    } 
  })

# Name the vector with the new names  
names(alt_names) <- new_names

# Rename your result data frame with machine_readable_names 
df_nmr_results_alt_names <- 
  df_nmr_results %>% 
  rename(!!alt_names)
  
```
{% endstep %}

{% step %}
### Read clinical data

Here you are providing the clinical data of your samples. The data is saved into `df_clinical_data`.

<pre class="language-r"><code class="lang-r"># Read the clinical_data.csv data file
df_clinical_data &#x3C;- readr::read_csv( 
<strong>  ##################################################
</strong><strong>  # Enter the correct location for your file below #
</strong><strong>  ##################################################
</strong><strong>  file = "Projects/Nightingale/metabolomics_data/clinical_data.csv") %>%
</strong>  # Rename the identifier column to Sample_id as in the NMR result file
  rename(Sample_id = identifier) %>% 
  # Harmonize the id entries in clinical data with the ids in the NMR data 
  mutate(Sample_id = paste0(
    "ResearchInstitutionProjectLabId_", 
    as.numeric(Sample_id)
  ))
</code></pre>

{% hint style="info" %}
Please provide the correct location for your **clinical data** file. If you are unaware of how to find the file path, click [here](https://ucl-ioo-bioinformatics-hub.gitbook.io/ioo-bioinformatics-hub/handling-files/getting-file-path).
{% endhint %}

The example clinical data `clinical_data.csv` has the following structure.

<figure><img src="../../.gitbook/assets/image (6).png" alt=""><figcaption></figcaption></figure>
{% endstep %}

{% step %}
### Join biomarker data with clinical data

Join the NMR data and the clinical data and save it into `df_full_data`.

```r
# Join NMR result file with the clinical data using column "Sample_id"
df_full_data <- dplyr::left_join(
  x = df_nmr_results,
  y = df_clinical_data,
  by = "Sample_id"
)
```
{% endstep %}

{% step %}
### Extract biomarkers

Extract the names of biomarkers, and check if there are 250 of them. (There should be.)

```r
# Extract names of NMR biomarkers
nmr_biomarkers <- dplyr::intersect(
  ggforestplot::df_NG_biomarker_metadata$machine_readable_name,
  colnames(df_nmr_results)
)

# NMR biomarkers here should be 250
stopifnot(length(nmr_biomarkers) == 250)
```

Extract the variables to be used from the clinical data and collapse into `df_long`.&#x20;

```r
# Select only variables to be used for the model 
# and collapse to a long data format df_long
df_long <-
  df_full_data %>%
  # Select only model variables
  dplyr::select(tidyselect::all_of(nmr_biomarkers), gender, baseline_age, BMI) %>%
  # Log-transform and scale biomarkers
  dplyr::mutate_at(
    .vars = dplyr::vars(tidyselect::all_of(nmr_biomarkers)),
    .funs = ~ .x %>% log1p() %>% scale %>% as.numeric()
  ) %>%
  # Collapse to a long format
  tidyr::gather(
    key = biomarkerid,
    value = biomarkervalue,
    tidyselect::all_of(nmr_biomarkers)
  )
```
{% endstep %}
{% endstepper %}



