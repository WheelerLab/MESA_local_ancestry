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
