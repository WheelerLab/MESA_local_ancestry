---
title: 'RNA-seq.md
author: "Ryan Schubert"
output: html_document
---

# Introduction

First we want to identify all samples that we have both RNA-seq and genotyping data for. 
Considerations:

* Tissue Types: Data dict reports PBMCs, Monocytes, and T-cell RNA have been collected. We are interested in collecting data for PBMCs
* Duplicates and multiple time points: Many RNA samples are from the same individual collected at different time points.
* Population: The topmed data does not itself contain information on population of origin. Nor does it provide genotypes for CAU individuals who have been RNA-seq'ed. For this we will need to return to the orignial MESA dbs which report on population

# Collect sample lists

First examine the origninal MESA dbgap files for population and gender data. 

Combine the consent groups into one plink set
```{bash}
plink \
  --bfile /home/ryan/mesa_files/dbgap_files/consent_group_1/consent.set.v6.p3.c1/phg000071.v2.NHLBI_SHARE_MESA.gen \
  --bmerge /home/ryan/mesa_files/dbgap_files/consent_group_2/consent.set.v6.p3.c2/phg000071.v2.NHLBI_SHARE_MESA.ge \
  --make-bed \
  --out SHARE_MESA_combined_consent \
```

Samples are split among different phenotype files. Pull phenotypes and IDs from both consent groups with the following Rscript.
```{r}
Rscript pull_combined_sidno.R #best to run this line by line
```

Next identify what samples in topmed RNA-seq we have topmed or MESA genotypes for
```{r}
Rscript intial_sample_stats.R #best to run this line by line
```
Seems we can only pull CAU from MESA.

# Process topmed vcfs
CHN, HIS, and AFA have already been imputed by topmed. Start by extracting the samples we have RNA-seq data for
```{bash}
/usr/local/bin/bcftools view \
-S /home/ryan/topmed/RNA_files/${pop}/genotypes/${pop}.sample.list.txt \
/home/wheelerlab3/Data/TOPMed/MESA_TOPMED_Imputation/${pop}/chr${chr}.dose.vcf.gz \
-O z \
-o /home/ryan/topmed/RNA_files/${pop}/genotypes/${pop}.chr${chr}.dose.vcf.gz
```
Next parse by maf and R2.

# Process MESA CAU
Meanwhile we will have to prep CAU for preimputation.
Start by extracting the CAU genotypes from the dbgap plink files.
```
plink \
  --bfile /home/ryan/mesa_files/dbgap_files/v6_SHARe_merged_groups/SHARE_MESA_combined_consent \
  --keep ./genotypes/CAU.sample.list.fam \
  --make-bed \
  --out ./genotypes/CAU.combined.consent \
```

Next we will move onto preimputation QC
  
  
