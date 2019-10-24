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
```
python2 /home/ryan/Imputation/topmed.py \
-i /home/ryan/topmed/RNA_files/${pop}/genotypes/vcfs/${pop}. \
-c ${chr} \
--cpos \
--outdir /home/ryan/topmed/RNA_files/${pop}/genotypes/
```
# Process MESA CAU
Meanwhile we will have to prep CAU for preimputation.
Start by extracting the CAU genotypes from the dbgap plink files.

```
plink --bfile /home/ryan/mesa_files/dbgap_files/consent_group_1/consent.set.v6.p3.c1/phg000071.v2.NHLBI_SHARE_MESA.genotype-calls-matrixfmt.c1/SHARE_MESA_c1 --bmerge /home/ryan/mesa_files/dbgap_files/consent_group_2/consent.set.v6.p3.c2/phg000071.v2.NHLBI_SHARE_MESA.genotype-calls-matrixfmt.c2/SHARE_MESA_c2 --make-bed --out SHARE_MESA_combined_consent
plink \
  --bfile /home/ryan/mesa_files/dbgap_files/v6_SHARe_merged_groups/SHARE_MESA_combined_consent \
  --keep ./genotypes/CAU.sample.list.fam \
  --make-bed \
  --out ./genotypes/CAU.combined.consent \
```

## Preimputation QC

First change affy ids to rsids
```
wget http://www.affymetrix.com/Auth/analysis/downloads/na35/genotyping/GenomeWideSNP_6.na35.annot.csv.zip
unzip GenomeWideSNP_6.na35.annot.csv.zip
tail -n +19 GenomeWideSNP_6.na35.annot.csv | cut -f 1-4 -d "," | sed 's/\"//g' | sed 's/,/ /g' | sed '/---/d' > id_map.txt
plink --bfile CAU.combined.consent --update-name /home/ryan/Data/id_map.txt 2 1 1 --make-bed --out CAU.combined.consent.rsid
```

perform liftover on your files
```
#remove duplicate entries from your files
plink --bfile ../CAU.combined.consent.rsid --list-duplicate-vars --out CAU.duplicates
awk '{print $4}' CAU.duplicates.dupvar > CAU.duplicates.dupvar.rsid
plink --autosome --bfile ../CAU.combined.consent.rsid --exclude CAU.duplicates.dupvar.rsid --make-bed --out CAU.remove_dups
#extract genomic coordinates and lift
awk '{print "chr" $1 "\t" $4 "\t" $4 +1 "\t" $2}' CAU.remove_dups.bim > prelifthg18.CAU.txt
liftOver prelifthg18.CAU.txt /home/ryan/Data/liftover/hg18ToHg19.over.chain.gz lifted_hg19.CAU.txt unmapped_hg19.CAU.txt
sed '/#/d' unmapped_hg19.CAU.txt | awk'{print $4}' > hg19.not_present.txt
#update bp and rm snps not present in later build
plink --bfile CAU.remove_dups --exclude hg19.not_present.txt --make-bed --out CAU.combined.consent.rsid.hg19 --update-map lifted_hg19.CAU.txt 2 4
```

next we will run the gwas QC pipeline on our CAU data using the [gwas qc pipeline](https://github.com/WheelerLab/gwasqc_pipeline) (may have to update paths coded in)
```
#!/bin/bash
/home/ryan/gwasqc_pipeline/shellscripts/01MissingnessFiltering \
        -b /home/ryan/topmed/RNA_files/CAU/genotypes/preimputation/CAU.combined.consent.rsid.hg19 \
        -a \
        -o /home/ryan/topmed/RNA_files/CAU/genotypes/preimputation/
/home/ryan/gwasqc_pipeline/shellscripts/02RelatednessFiltering \
        -b /home/ryan/topmed/RNA_files/CAU/genotypes/preimputation/missingness_hwe_steps/05filtered_HWE \
        -o /home/ryan/topmed/RNA_files/CAU/genotypes/preimputation \
        --rel 0.125
/home/ryan/gwasqc_pipeline/shellscripts/03MergeHapMap \
        -b /home/ryan/topmed/RNA_files/CAU/genotypes/preimputation/relatedness_steps/04LD_pruned \
        -h /home/ryan/HAPMAP3_hg18 \
        -o /home/ryan/topmed/RNA_files/CAU/genotypes/preimputation/
```
  
