# FUR Gene Actionability

## Overview
This repository explores therapy actionability for the FUR driver gene set by integrating multiple oncology knowledge bases. The R workflow (`Fur_actionability_Script.R`) filters publicly and collaboratively curated datasets to identify drugs with supporting evidence for the genes of interest.

## Repository Layout
- `Fur_actionability_Script.R` – end-to-end analysis script that reads source data, filters for FUR driver genes, and exports summaries.
- `data/` – input datasets retrieved from OncoKB, Pharos, COSMIC, and Schaffer et al. (2023). The raw files are distributed here for convenience; check the original sources for licensing or more recent releases.
- `*.csv` outputs in the project root – generated tables keyed to the individual data sources (OncoKB, Pharos, Schaffer synthetic lethality screen, COSMIC Actionability).
- `fur_actionability.Rproj`, `renv/`, `renv.lock` – R project configuration and dependency lockfile (R 4.1.2 targeted).

## Prerequisites
1. R >= 4.1.2.
2. Packages: `tidyverse` and `readxl` (managed automatically via `renv`).

### Restore the project library
```r
install.packages("renv")
renv::restore()
```
The command above recreates the locked package versions in a project-local library under `renv/`.

## Running the Analysis
All inputs are assumed to remain in `data/` and the script writes results to the repository root.

From an R console:
```r
source("Fur_actionability_Script.R")
```

From the command line:
```bash
Rscript Fur_actionability_Script.R
```

Re-run the script whenever the driver gene list or any upstream dataset is updated.

## Outputs
Each stage exports a CSV summarizing actionability evidence for the FUR drivers:
- `onkoKB_Fur_List_filter.csv` – OncoKB biomarkers at evidence Levels 1–4 matched to the driver list.
- `pharos_Fur.csv` – Pharos druggability metrics for the driver genes, alongside `Feline_FUR_driver_genes_distinct.csv` (deduplicated list).
- `Schaffer_Fur.csv` – Candidate synthetic lethal partners from Schaffer et al. filtered to the FUR genes.
- `Actionability_Fur.csv` – COSMIC actionability records corresponding to the driver genes.

The script prints a simple overlap check between the driver list and Pharos symbols to highlight missing entries.

## Maintaining the Workflow
- Update `data/FELINE_FUR_DRIVER_GENES_unique_list.xlsx` (or the downstream CSV) when a new driver gene list is released; the script reads the `Gene name` column.
- Refresh the OncoKB, Pharos, COSMIC, and Schaffer source files as new versions become available; keep filenames consistent or adjust the script paths accordingly.
- After editing the script or inputs, commit both the analysis code and regenerated CSV outputs to track provenance.

