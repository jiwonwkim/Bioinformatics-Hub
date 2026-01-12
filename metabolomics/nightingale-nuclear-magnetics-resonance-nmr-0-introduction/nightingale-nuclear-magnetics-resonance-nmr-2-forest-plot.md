---
icon: 'n'
---

# Nightingale nuclear magnetics resonance (NMR) #2: Forest plot

This script continues from the previous session.

Now with the imported data, we are going to generate a **forest plot**, which shows **the association between BMI and the biomarker concentration** inferred from linear regression and the confidence intervals of each biomarker.

{% stepper %}
{% step %}
### Estimate sex- and age-adjusted associations

Perform a linear regression analysis to estimate **sex- and age-adjusted associations** between individual metabolites and BMI.

```r

# Estimate sex- and age-adjusted associations of metabolite to BMI
df_assoc_per_biomarker_bmi <-
  ggforestplot::discovery_regression(
    df_long = df_long,
    model = "lm",
    formula =
      formula(
       biomarkervalue ~ BMI + factor(gender) + baseline_age
      ),
    key = biomarkerid,
    predictor = BMI
  ) %>% 
  # Join this dataset with the grouping data in order to choose a different 
  # biomarker naming option
  left_join(
    select(
      df_NG_biomarker_metadata, 
      name,
      biomarkerid = machine_readable_name
    ), 
    by = "biomarkerid")
```
{% endstep %}

{% step %}
### Decide groups of biomarkers to plot

The `ggforestplot` package includes a data frame, called `ggforestplot::df_NG_biomarker_metadata`, with metadata on the Nightingale blood biomarkers. We will select groups of biomarkers and in what order we want to visualize from the data frame.

```r
# Display blood biomarker groups
ggforestplot::df_NG_biomarker_metadata %>% 
  pull(group) %>% 
  unique()

# Alternatively, display blood biomarker subgroups 
# ggforestplot::df_NG_biomarker_metadata %>% 
# pull(subgroup) %>% 
# unique()

# Choose the groups or subgroups you want to plot and
# define the order with which group categories will appear in the plot
group_order <- c(
  "Branched-chain amino acids",
  "Aromatic amino acids",
  "Amino acids",
  "Fluid balance",
  "Inflammation",
  "Fatty acids",
  "Triglycerides",
  "Other lipids",
  "Cholesterol"
)
  
# Extract a subset of the df_NG_biomarker_metadata, with the desired group
# order, to set the order of biomarkers in the forestplot later on
df_with_groups <- 
  ggforestplot::df_NG_biomarker_metadata %>% 
  # Select subset of variables
  select(name = name,
         group) %>% 
  # Filter and arrange for the wanted groups
  filter(group %in% group_order) %>%
  arrange(factor(group, levels = group_order))
```
{% endstep %}

{% step %}
### Calculate adjusted P-value for multiple testing

We are going to add a correction for multiple testing of 250 biomarkers. To do this, we are going to calculate the number of principal components that accounts for 99% of the variance of the data and divide the significant threshold 0.05 with the number. (See the bottom of the page to learn more about multiple testing.)

First, we are going to perform principal component analysis using `df_full_data`.

```r
# Perform principal component analysis on metabolic data
df_pca <- 
  df_full_data %>% 
  select(tidyselect::all_of(nmr_biomarkers)) %>% 
  nest(data = dplyr::everything()) %>% 
  mutate(
    # Perform PCA on the data above, after scaling and centering to 0 
    pca = map(data, ~ stats::prcomp(.x, center = TRUE, scale = TRUE)),
    # Augment the original data with columns containing each observation's 
    # projection into the PCA space. Each PCA-space dimension is signified 
    # with the .fitted prefix in its name 
    pca_aug = map2(pca, data, ~broom::augment(.x, data = .y))
  )
  
# Estimate amount of variance explained by each principal component
df_pca_variance <- 
  df_pca %>% 
  unnest(pca_aug) %>% 
  # Estimate variance for the PCA projected variables
  summarize_at(.vars = vars(starts_with(".fittedPC")), .funs = ~ var(.x)) %>% 
  # Gather data in a long format 
  gather(key = PC, value = variance) %>% 
  # Estimate cumulative normalized variance
  mutate(cumvar = cumsum(variance / sum(variance)),
         PC = str_replace(PC, ".fitted", ""))

```

And now we are going to find the number of PCs that explain 99% of the variance.

```r
# Find number of principal components that explain 99% 
pc_99 <- 
  df_pca_variance %>% 
  filter(cumvar <= 0.99) %>% 
  nrow()

## Print the number of PCs
print(pc_99)
```

Finally, calculate the corrected significance threshold.

```r
# Corrected significance threshold
psignif <- signif(0.05 / pc_99, 1)
```
{% endstep %}

{% step %}
### Forest plot

We are going to join `df_assoc_per_biomarker_bmi` with group data for `forestplot()` function.

```r
# Join the association data frame with group data
df_to_plot <-
  df_assoc_per_biomarker_bmi %>%
  # use right_join, with df_grouping on the right, to preserve the order of 
  # biomarkers it specifies. 
  dplyr::right_join(., df_with_groups, by = "name") %>%
  dplyr::mutate(
    group = factor(.data$group, levels = group_order)
  ) %>%
  tidyr::drop_na(.data$estimate)
```

Now we visualize the plot.

```r
# Draw a forestplot of cross-sectional, linear associations.
forestplot(
  df = df_to_plot,
  pvalue = pvalue,
  psignif = psignif,
  xlab = "1-SD increment in biomarker concentration\nper unit increment in BMI"
) +
  ggforce::facet_col(
    facets = ~group,
    scales = "free_y",
    space = "free"
  )
```
{% endstep %}

{% step %}
### Forestplot for all biomarkers

We can also get a collection of forestplots for all 250 biomarkers using a function `plot_all_NG_biomarkers()`.

```r
# Plot in all biomarkers in a two-page pdf file
plot_all_NG_biomarkers(
  df = df_assoc_per_biomarker_bmi, 
  machine_readable_name = biomarkerid,
  name = name, 
  estimate = estimate, 
  se = se, 
  pvalue = pvalue, 
  xlab = "1-SD increment in biomarker concentration\nper unit increment in BMI",
  filename = "all_ng_associations_bmi.pdf"
)
```

You can find the collection of all biomarkers in `all_ng_associations_bmi.pdf` file.&#x20;
{% endstep %}
{% endstepper %}

<details>

<summary>Learn more about multiple testing correction</summary>

When comparing 250 biomarkers, applying Bonferroni correction directly to the conventional significance threshold would lead to a very stringent threshold of&#x20;

**α = 0.05 / 250 ≈ 0.0002**,&#x20;

under the assumption that all tests are independent. However, many biomarkers are biologically correalated, which violates the independence assumption and makes the correction overly conservative.

To address this issue, we use **the number of principal components (PCs) that explain 99% of the variance** in the data as a proxy for the effective number of independent tests. This approach leads to a more appropriate multiple testing correction while accounting for the correlation structure present in the data.

</details>

