---
title: 'RNA-seq.md
author: "Ryan Schubert"
output: html_document
---

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
  
  
