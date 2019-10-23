library(dplyr)
library(data.table)

##consent_group_1
c1fam<-fread("Z:/mesa_files/dbgap_files/v6_SHARe_merged_groups/SHARE_MESA_combined_consent.fam")
c1AirNRExamMain<-fread("Z:/mesa_files/dbgap_files/consent_group_1/pheno_files/phs000209.v13.pht001111.v4.p3.c1.MESA_AirNRExamMain.HMB.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,race1c,gender1)
c1FamilyExamMain<-fread("Z:/mesa_files/dbgap_files/consent_group_1/pheno_files/phs000209.v13.pht001121.v3.p3.c1.MESA_FamilyExamMain.HMB.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,racefc,genderf)
colnames(c1FamilyExamMain)<-c("dbGaP_Subject_ID","sidno","race1c","gender1")
c1AirNRExam5Main<-fread("Z:/mesa_files/dbgap_files/consent_group_1/pheno_files/phs000209.v13.pht003086.v3.p3.c1.MESA_AirNRExam5Main.HMB.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,race1c,gender1)

c1Exam1Main<-fread("Z:/mesa_files/dbgap_files/consent_group_1/pheno_files/phs000209.v13.pht001116.v10.p3.c1.MESA_Exam1Main.HMB.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,race1c,gender1)
c1Exam2Main<-fread("Z:/mesa_files/dbgap_files/consent_group_1/pheno_files/phs000209.v13.pht001118.v8.p3.c1.MESA_Exam2Main.HMB.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,race1c,gender1)
c1Exam3Main<-fread("Z:/mesa_files/dbgap_files/consent_group_1/pheno_files/phs000209.v13.pht001119.v8.p3.c1.MESA_Exam3Main.HMB.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,race1c,gender1)
c1Exam4Main<-fread("Z:/mesa_files/dbgap_files/consent_group_1/pheno_files/phs000209.v13.pht001120.v10.p3.c1.MESA_Exam4Main.HMB.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,race1c,gender1)
c1Exam5Main<-fread("Z:/mesa_files/dbgap_files/consent_group_1/pheno_files/phs000209.v13.pht003091.v3.p3.c1.MESA_Exam5Main.HMB.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,race1c,gender1)

sum(is.na(c1Exam2Main))/2

c1_Exam_summary<- rbind.data.frame(c1Exam1Main,c1Exam2Main) %>% 
  rbind.data.frame(c1Exam3Main) %>% 
  rbind.data.frame(c1Exam4Main) %>% 
  rbind.data.frame(c1Exam5Main) %>% 
  rbind.data.frame(c1AirNRExamMain) %>%
  rbind.data.frame(c1FamilyExamMain) %>%
  rbind.data.frame(c1AirNRExam5Main) %>%
  group_by(sidno) %>% 
  summarise_all(funs(.[!is.na(.)][1])) %>%
  mutate(pop = if_else(race1c == 1, "CAU", if_else(race1c==2, "CHN",if_else(race1c == 3,"AFA","HIS"))))
sum(is.na(c1_Exam_summary))/2
geno_sidno<-c1fam$V2

geno_c1_summary<-filter(c1_Exam_summary,sidno %in% geno_sidno)

###consent_group_2
c2fam<-fread("Z:/mesa_files/dbgap_files/v6_SHARe_merged_groups/SHARE_MESA_combined_consent.fam")
c2AirNRExamMain<-fread("Z:/mesa_files/dbgap_files/consent_group_2/pheno_files/phs000209.v13.pht001111.v4.p3.c2.MESA_AirNRExamMain.HMB-NPU.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,race1c,gender1)
c2FamilyExamMain<-fread("Z:/mesa_files/dbgap_files/consent_group_2/pheno_files/phs000209.v13.pht001121.v3.p3.c2.MESA_FamilyExamMain.HMB-NPU.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,racefc,genderf)
colnames(c2FamilyExamMain)<-c("dbGaP_Subject_ID","sidno","race1c","gender1")
c2AirNRExam5Main<-fread("Z:/mesa_files/dbgap_files/consent_group_2/pheno_files/phs000209.v13.pht003086.v3.p3.c2.MESA_AirNRExam5Main.HMB-NPU.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,race1c,gender1)

c2Exam1Main<-fread("Z:/mesa_files/dbgap_files/consent_group_2/pheno_files/phs000209.v13.pht001116.v10.p3.c2.MESA_Exam1Main.HMB-NPU.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,race1c,gender1)
c2Exam2Main<-fread("Z:/mesa_files/dbgap_files/consent_group_2/pheno_files/phs000209.v13.pht001118.v8.p3.c2.MESA_Exam2Main.HMB-NPU.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,race1c,gender1)
c2Exam3Main<-fread("Z:/mesa_files/dbgap_files/consent_group_2/pheno_files/phs000209.v13.pht001119.v8.p3.c2.MESA_Exam3Main.HMB-NPU.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,race1c,gender1)
c2Exam4Main<-fread("Z:/mesa_files/dbgap_files/consent_group_2/pheno_files/phs000209.v13.pht001120.v10.p3.c2.MESA_Exam4Main.HMB-NPU.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,race1c,gender1)
c2Exam5Main<-fread("Z:/mesa_files/dbgap_files/consent_group_2/pheno_files/phs000209.v13.pht003091.v3.p3.c2.MESA_Exam5Main.HMB-NPU.txt",skip=10) %>% select(dbGaP_Subject_ID,sidno,race1c,gender1)

sum(is.na(c2Exam2Main))/2

c2_Exam_summary<- rbind.data.frame(c2Exam1Main,c2Exam2Main) %>% 
  rbind.data.frame(c2Exam3Main) %>% 
  rbind.data.frame(c2Exam4Main) %>% 
  rbind.data.frame(c2Exam5Main) %>% 
  rbind.data.frame(c2AirNRExamMain) %>%
  rbind.data.frame(c2FamilyExamMain) %>%
  rbind.data.frame(c2AirNRExam5Main) %>%
  group_by(sidno) %>% 
  summarise_all(funs(.[!is.na(.)][1])) %>%
  mutate(pop = if_else(race1c == 1, "CAU", if_else(race1c==2, "CHN",if_else(race1c == 3,"AFA","HIS"))))
sum(is.na(c2_Exam_summary))/2
geno_sidno<-c2fam$V2

geno_c2_summary<-filter(c2_Exam_summary,sidno %in% geno_sidno)
combined_consent_summary<-rbind.data.frame(geno_c1_summary,geno_c2_summary) %>%
  group_by(sidno) %>% 
  summarise_all(funs(.[!is.na(.)][1]))
colnames(combined_consent_summary)<-c("sidno","dbGaP_Subject_ID","pop_code","gender_coide","pop")
fwrite(combined_consent_summary,"Z:/mesa_files/dbgap_files/v6_SHARe_merged_groups/combined_consent_basic_pop_codes.txt",col.names = T,sep="\t")
