### read in topmed sample meta data
library(dplyr)
library(readxl)
library(tidyr)
library(data.table)
#Read in topmed ids
topmed<-read_xlsx("Z:/topmed/MESA_TOPMed_WideID_20190517.xlsx",skip = 2)
names(topmed)
topmed_ids<-dplyr::select(topmed,sidno,tor_id11,tor_ageatexam11,tor_specimen11,tor_id15,tor_ageatexam15,tor_specimen15)

#separate samples by exam 1
tor_exam1<-dplyr::select(topmed,sidno,tor_id11,tor_ageatexam11,tor_specimen11)
tor_exam1$exam<-1
tor_exam1<-tor_exam1[complete.cases(tor_exam1),]
colnames(tor_exam1)<-c("sidno","tor_id","age","tissue","exam")

#separate samples by exam 5 
tor_exam5<-dplyr::select(topmed,sidno,tor_id15,tor_ageatexam15,tor_specimen15)
tor_exam5$exam<-5
tor_exam5<-tor_exam5[complete.cases(tor_exam5),]
colnames(tor_exam5)<-c("sidno","tor_id","age","tissue","exam")

#create one df - each row is unique rna sample
tor_ids<-rbind.data.frame(tor_exam1,tor_exam5)
unique_RNA<-unique(tor_ids$sidno) #how many unique inds do we have
overlap_RNA<-inner_join(tor_exam1,tor_exam5,by="sidno") #how many inds are done at both time points

#Now read in the RNA IDs that are in the rna-seq file
actual_RNA_ids<-read.table("Z:/topmed/rsem_tpm_sample.list.txt") #note: I checked and each rna quant file contains the same samples.

#read in list of AFA genotype ids from topmed genotypes
AFA_genotyped_samples<-read.table("Z:/topmed/topmed_dosages/AFA/topmed_dosages/samples.txt")
AFA_genotyped_with_RNA_exam1<-filter(tor_exam1, sidno %in% AFA_genotyped_samples$V1) %>% filter(tor_id %in% actual_RNA_ids$V1) #how many ids are both genotyped and rna-seq'ed at exam 1
AFA_genotyped_with_RNA_exam5<-filter(tor_exam5, sidno %in% AFA_genotyped_samples$V1) %>% filter(tor_id %in% actual_RNA_ids$V1) %>% filter(tissue != "Mono") #how many ids are both genotyped and rna-seq'ed at exam 5 (Monocytes may be present in exam 5 so remove these)
total_AFA_genotyped_with_RNA<-rbind.data.frame(AFA_genotyped_with_RNA_exam1,AFA_genotyped_with_RNA_exam5)
total_AFA_genotyped_with_RNA$pop<-"AFA"
unique_AFA_RNA<-unique(total_AFA_genotyped_with_RNA$sidno)

#Repeat above for CHN
CHN_genotyped_samples<-read.table("Z:/topmed/topmed_dosages/CHN/topmed_dosages/samples.txt")
CHN_genotyped_with_RNA_exam1<-filter(tor_exam1, sidno %in% CHN_genotyped_samples$V1) %>% filter(tor_id %in% actual_RNA_ids$V1)
CHN_genotyped_with_RNA_exam5<-filter(tor_exam5, sidno %in% CHN_genotyped_samples$V1) %>% filter(tor_id %in% actual_RNA_ids$V1) %>% filter(tissue != "Mono")
total_CHN_genotyped_with_RNA<-rbind.data.frame(CHN_genotyped_with_RNA_exam1,CHN_genotyped_with_RNA_exam5)
total_CHN_genotyped_with_RNA$pop<-"CHN"
unique_CHN_RNA<-unique(total_CHN_genotyped_with_RNA$sidno)

#Repeat above for HIS
HIS_genotyped_samples<-read.table("Z:/topmed/topmed_dosages/HIS/topmed_dosages/samples.txt")
HIS_genotyped_with_RNA_exam1<-filter(tor_exam1, sidno %in% HIS_genotyped_samples$V1) %>% filter(tor_id %in% actual_RNA_ids$V1)
HIS_genotyped_with_RNA_exam5<-filter(tor_exam5, sidno %in% HIS_genotyped_samples$V1) %>% filter(tor_id %in% actual_RNA_ids$V1) %>% filter(tissue != "Mono")
total_HIS_genotyped_with_RNA<-rbind.data.frame(HIS_genotyped_with_RNA_exam1,HIS_genotyped_with_RNA_exam5)
total_HIS_genotyped_with_RNA$pop<-"HIS"
unique_HIS_RNA<-unique(total_HIS_genotyped_with_RNA$sidno)

#check how many RNA-seq samples we've found
accounted_for_RNA_samples<-rbind.data.frame(total_AFA_genotyped_with_RNA,total_CHN_genotyped_with_RNA) %>% rbind.data.frame(total_HIS_genotyped_with_RNA)
unique_RNA_accounted_topmed<-unique(accounted_for_RNA_samples$sidno)
#which RNA-seq samples are not identified
unaccounted_for_RNA_samples<-filter(actual_RNA_ids, !V1 %in% accounted_for_RNA_samples$tor_id)

#Read in IDs from MESA, find if any unaccounted IDs are identifiable
old_mesa_AFA_genotyped<-read.table("Z:/mesa_files/dbgap_files/v6_SHARe_merged_groups/combined_consent_AFA.txt")
old_mesa_AFA_genotyped_with_RNA_exam1<-filter(tor_exam1, sidno %in% old_mesa_AFA_genotyped$V1) %>% filter(tor_id %in% actual_RNA_ids$V1)
old_mesa_AFA_genotyped_with_RNA_exam5<-filter(tor_exam5, sidno %in% old_mesa_AFA_genotyped$V1) %>% filter(tor_id %in% actual_RNA_ids$V1) %>% filter(tissue != "Mono")
total_old_mesa_AFA_RNA<-rbind.data.frame(old_mesa_AFA_genotyped_with_RNA_exam1,old_mesa_AFA_genotyped_with_RNA_exam5)
RNA_accounted_by_old_AFA<- filter(total_old_mesa_AFA_RNA, tor_id %in% unaccounted_for_RNA_samples$V1)
RNA_accounted_by_old_AFA$pop<-"AFA"

old_mesa_CAU_genotyped<-read.table("Z:/mesa_files/dbgap_files/v6_SHARe_merged_groups/combined_consent_CAU.txt")
old_mesa_CAU_genotyped_with_RNA_exam1<-filter(tor_exam1, sidno %in% old_mesa_CAU_genotyped$V1) %>% filter(tor_id %in% actual_RNA_ids$V1)
old_mesa_CAU_genotyped_with_RNA_exam5<-filter(tor_exam5, sidno %in% old_mesa_CAU_genotyped$V1) %>% filter(tor_id %in% actual_RNA_ids$V1) %>% filter(tissue != "Mono")
total_old_mesa_CAU_RNA<-rbind.data.frame(old_mesa_CAU_genotyped_with_RNA_exam1,old_mesa_CAU_genotyped_with_RNA_exam5)
length(unique(total_old_mesa_CAU_RNA$sidno))
RNA_accounted_by_old_CAU<- filter(total_old_mesa_CAU_RNA, tor_id %in% unaccounted_for_RNA_samples$V1)
RNA_accounted_by_old_CAU$pop<-"CAU"

old_mesa_HIS_genotyped<-read.table("Z:/mesa_files/dbgap_files/v6_SHARe_merged_groups/combined_consent_HIS.txt")
old_mesa_HIS_genotyped_with_RNA_exam1<-filter(tor_exam1, sidno %in% old_mesa_HIS_genotyped$V1) %>% filter(tor_id %in% actual_RNA_ids$V1)
old_mesa_HIS_genotyped_with_RNA_exam5<-filter(tor_exam5, sidno %in% old_mesa_HIS_genotyped$V1) %>% filter(tor_id %in% actual_RNA_ids$V1) %>% filter(tissue != "Mono")
total_old_mesa_HIS_RNA<-rbind.data.frame(old_mesa_HIS_genotyped_with_RNA_exam1,old_mesa_HIS_genotyped_with_RNA_exam5)
RNA_accounted_by_old_HIS<- filter(total_old_mesa_HIS_RNA, tor_id %in% unaccounted_for_RNA_samples$V1)
RNA_accounted_by_old_HIS$pop<-"HIS"

old_mesa_CHN_genotyped<-read.table("Z:/mesa_files/dbgap_files/v6_SHARe_merged_groups/combined_consent_CHN.txt")
old_mesa_CHN_genotyped_with_RNA_exam1<-filter(tor_exam1, sidno %in% old_mesa_CHN_genotyped$V1) %>% filter(tor_id %in% actual_RNA_ids$V1)
old_mesa_CHN_genotyped_with_RNA_exam5<-filter(tor_exam5, sidno %in% old_mesa_CHN_genotyped$V1) %>% filter(tor_id %in% actual_RNA_ids$V1) %>% filter(tissue != "Mono")
total_old_mesa_CHN_RNA<-rbind.data.frame(old_mesa_CHN_genotyped_with_RNA_exam1,old_mesa_CHN_genotyped_with_RNA_exam5)
RNA_accounted_by_old_CHN<- filter(total_old_mesa_CHN_RNA, tor_id %in% unaccounted_for_RNA_samples$V1)
RNA_accounted_by_old_CHN$pop<-"CHN"

#identify all accounted for RNA-seq samples between topmed and MESA genotypes
total_RNA_accounted_old_mesa<-rbind.data.frame(RNA_accounted_by_old_AFA,RNA_accounted_by_old_HIS) %>% rbind.data.frame(RNA_accounted_by_old_CAU)
accounted_for_RNA_samples$study<-"topmed"
total_RNA_accounted_old_mesa$study<-"mesa"
RNA_accounted_old_new<-rbind.data.frame(accounted_for_RNA_samples,total_RNA_accounted_old_mesa)
fwrite(RNA_accounted_old_new,"Z:/topmed/sample_statistics/Identified_genotyped_topmed_RNA.txt",col.names=T,sep="\t")
unique_accounted_RNA<-unique(RNA_accounted_old_new$sidno)


#write out unaccounted for
unaccounted_for_RNA_samples<-filter(actual_RNA_ids, !V1 %in% RNA_accounted_old_new$tor_id)
fwrite(unaccounted_for_RNA_samples,"Z:/topmed/sample_statistics/unaccounted_for_RNA_samples.txt",col.names = F)
unaccounted_for_topmed <-filter(tor_ids, tor_id %in% unaccounted_for_RNA_samples$V1)
all_old_mesa<-rbind.data.frame(old_mesa_AFA_genotyped,old_mesa_CHN_genotyped) %>% rbind.data.frame(old_mesa_CAU_genotyped) %>% rbind.data.frame(old_mesa_HIS_genotyped)
old_mesa_fam<-fread("Z:/mesa_files/dbgap_files/v6_SHARe_merged_groups/SHARE_MESA_combined_consent.fam")
