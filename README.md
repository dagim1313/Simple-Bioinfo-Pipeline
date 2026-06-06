# Simple Bioinformatics QC Pipeline in R
## Overview
This portfolio project demonstrates a simple bioinformatics quality-control (QC) workflow using R.

The pipeline performs:

- FASTQ quality control
- VCF variant quality control
- Basic summary statistics
- QC visualizations
---

## Features

### FASTQ QC
- Total read count
- Read length statistics
- Read length distribution plot
- Mean base quality per position

### VCF QC
- Total variant count
- QUAL score statistics
- Read depth statistics
- QUAL distribution plot
- Depth distribution plot

---

## Required Package 
The script automatically installs missing packages.

Main libraries:
- ShortRead
- VariantAnnotation
- ggplot2
- dplyr

---

## Example Usage

```r
source("bioinformatics_qc_pipeline.R")

# FASTQ QC
run_fastq_qc("sample.fastq.gz")

# VCF QC
run_vcf_qc("sample.vcf.gz")
```

---

## Output

The pipeline generates:
- CSV summary reports
- PNG QC plots

Folders created automatically:
- fastq_qc_results/
- vcf_qc_results/

---
