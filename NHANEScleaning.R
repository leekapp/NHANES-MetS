##NHANES 2017-2018 data
##National Health and Nutrition Examination Survey

library(foreign)
library(tidyverse)

##UIBC = Unsaturated Iron Binding Capacity
##TIBC = Total Iron Binding Capacity

#importing and labeling the data from the original SAS files to eventually output a CSV file below

cbcDat<-read.xport("/Users/leekapp/Desktop/STAT 235/NHANESproject/CBC_J.XPT")
bioproDat<-read.xport("/Users/leekapp/Desktop/STAT 235/NHANESproject/BIOPRO_J.XPT")
ferritinDat<-read.xport("/Users/leekapp/Desktop/STAT 235/NHANESproject/FERTIN_J.XPT")
ironDat<-read.xport("/Users/leekapp/Desktop/STAT 235/NHANESproject/FETIB_J.XPT")
glycatedDat<-read.xport("/Users/leekapp/Desktop/STAT 235/NHANESproject/GHB_J.XPT")
glucoseDat<-read.xport("/Users/leekapp/Desktop/STAT 235/NHANESproject/GLU_J.XPT")
insulinDat<-read.xport("/Users/leekapp/Desktop/STAT 235/NHANESproject/INS_J.XPT")
demoDat<-read.xport("/Users/leekapp/Desktop/STAT 235/NHANESproject/DEMO_J.XPT")
diet1<-read.xport("/Users/leekapp/Desktop/STAT 235/NHANESproject/DR1TOT_J.XPT")
diab<-read.xport("/Users/leekapp/Desktop/STAT 235/NHANESproject/DIQ_J.XPT")
BP<-read.xport("/Users/leekapp/Desktop/STAT 235/NHANESproject/BPX_J.XPT")

colnames(glycatedDat) <- c("Subject", "Glycohemoglobin")
colnames(ferritinDat) <- c("Subject", "Ferritin (ng/ml)", "Ferritin (µg/L)")
colnames(insulinDat) <- c("Subject", "Fasting Subsample", "Insulin (µU/ml)", "Insulin (pmol/L)", "Comment Code")
colnames(glucoseDat) <- c("Subject", "Fasting Subsample", "Fasting Glucose (mg/dL)", "Fasting Glucose (mmol/L)")
colnames(ironDat) <- c("Subject", "Serum Iron (µg/dL)", "Serum Iron (µmol/L)", "UIBC (µg/dL)", "UIBC comment", "UIBC (µmol/L)", "TIBC (µg/dL)", "TIBC (µmol/dL)", "Transferrin Sat (%)")

cbcDat[3:7]<-NULL
cbcDat[16]<-NULL
cbcDat[14]<-NULL
colnames(cbcDat) <- c("Subject", "White Cells (1000 cells/µl)", "Lymphocytes (1000 cells/µl)", "Monocytes (1000 cells/µl)", "Segmented Neutrophils (1000 cells/µl)",
                        "Eosinophils (1000 cells/µl)", "Basophils (1000 cells/µl)", "RBCs (million/µl)", "Hemoglobin (g/dL)", "Hematocrit (%)", "Mean Cell Vol (fL)",
                        "Mean Cell HGB (pg)", " Mean Cell HGB Conc. (g/dL)", "Platelets (1000 cells/µl)", "Nucleated RBC")

bioproDat<-bioproDat[-5]
bioproDat<-bioproDat[-c(7:10)]
bioproDat<-bioproDat[-c(8:13)]
bioproDat<-bioproDat[-c(10:11)]
bioproDat<-bioproDat[-c(11:15)]
bioproDat<-bioproDat[-c(14:15)]
bioproDat<-bioproDat[-17]
bioproDat<-bioproDat[-18]
bioproDat<-bioproDat[-19]
bioproDat<-bioproDat[-15]
colnames(bioproDat) <- c("Subject", "Alanine Aminotransferase (IU/L)", "ALT comment", "Albumin (g/dL)", "Alk Phos (IU/L)", "Aspartate Aminotransferase (IU/L)",
                         "Creatine Phosphokinase (IU/L)", "Gamma glutamyl Transferase (IU/L)", "GGT comment", "Lactate Dehydrogenase (IU/L)", "Total Bilirubin (g/dL)",
                         "Total Bilirubin (µmol/L)", "Tot Bil comment", "Cholesterol (mg/dL)", "Total Protein (g/dL)", "Triglycerides (mg/dL)", "Uric Acid (mg/dL)")
bioproDat <- bioproDat[-12]

BMIdat<-read.xport("/Users/leekapp/Desktop/STAT 235/NHANESproject/BMX_J.XPT")
BMIdat<-BMIdat[c(1,11)]
colnames(BMIdat) <- c("Subject", "BMI")

demoDat <- demoDat[c(1,4,5,7,8)]
colnames(demoDat) <- c("Subject", "Gender", "Age (years)", "Race/Hispanic Origin", "Race/Hispanic Origin (w. NH Asian)")
demoDat <- demoDat[-4]

diet1 <-diet1 %>% dplyr::select("SEQN", "DBD100", "DRQSPREP", "DR1STY")
colnames(diet1) <-c("Subject", "Table_Salt_Freq", "Cook_w_Salt", "Salt_Yesterday")
diet1 <- diet1 %>% mutate_at(vars(Table_Salt_Freq), list( ~ case_when(. == 1 ~ "Rarely", . == 2 ~ "Occasionally", . == 3 ~ "Very Often", . == 7 ~ "Refused", . == 9 ~ "Don't Know")))
diet1 <- diet1 %>% mutate_at(vars(Cook_w_Salt), list( ~ case_when(. == 1 ~ "Never", . == 2 ~ "Rarely", . == 3 ~ "Occasionally", . == 4 ~ "Very Often", . == 9 ~ "Don't Know")))
diet1 <- diet1 %>% mutate_at(vars(Salt_Yesterday), list( ~ case_when(. == 1 ~ "Yes", . == 2 ~ "No", . == 9 ~ "Don't Know")))

diab<-diab %>% dplyr::select("SEQN", "DIQ010", "DIQ160", "DIQ170", "DIQ180", "DIQ050", "DIQ275", "DIQ280", "DIQ300S", "DIQ300D")
colnames(diab)<-c("Subject", "Told_Have_Diab", "Told_Have_Prediab", "Told_Diab_Risk", "Tested_Past_3yr", "Take_Insulin", "A1C_checked_1yr", "Last_A1C", "Last_SBP", "Last_DBP")
diab <- diab %>% mutate_at(vars(Told_Have_Diab), list( ~ case_when(. == 1 ~ "Yes", . == 2 ~ "No", . == 3 ~ "Borderline", . == 7 ~ "Refused", . == 9 ~ "Don't Know")))
diab <- diab %>% mutate_at(vars(Told_Have_Prediab, Told_Diab_Risk, Tested_Past_3yr, Take_Insulin, Take_Insulin, A1C_checked_1yr), list( ~ case_when(. == 1 ~ "Yes", . == 2 ~ "No", . == 7 ~ "Refused", . == 9 ~ "Don't Know")))
diab$Last_A1C <- ifelse(diab$Last_A1C == 777, NA, diab$Last_A1C)
diab$Last_A1C <- ifelse(diab$Last_A1C == 999, NA, diab$Last_A1C)
diab$Last_SBP <- ifelse(diab$Last_SBP == 7777, NA, diab$Last_SBP)
diab$Last_SBP <- ifelse(diab$Last_SBP == 9999, NA, diab$Last_SBP)
diab$Last_DBP <- ifelse(diab$Last_SBP == 7777, NA, diab$Last_SBP)

BP<-BP %>% dplyr::select("SEQN", "BPXSY1", "BPXDI1")
colnames(BP)<-c("Subject", "Systolic_BP", "Diastolic_BP")

write.csv(bioproDat, "/Users/leekapp/Desktop/STAT 235/NHANESproject/chemPanel.csv")
write.csv(BMIdat, "/Users/leekapp/Desktop/STAT 235/NHANESproject/BMIdata.csv")
write.csv(cbcDat, "/Users/leekapp/Desktop/STAT 235/NHANESproject/cbcData.csv")
write.csv(demoDat, "/Users/leekapp/Desktop/STAT 235/NHANESproject/demographics.csv")
write.csv(ferritinDat, "/Users/leekapp/Desktop/STAT 235/NHANESproject/ferritin.csv")
write.csv(glucoseDat, "/Users/leekapp/Desktop/STAT 235/NHANESproject/glucose.csv")
write.csv(glycatedDat, "/Users/leekapp/Desktop/STAT 235/NHANESproject/glycation.csv")
write.csv(insulinDat, "/Users/leekapp/Desktop/STAT 235/NHANESproject/insulin.csv")
write.csv(ironDat, "/Users/leekapp/Desktop/STAT 235/NHANESproject/ironStudies.csv")
write.csv(diet1, "/Users/leekapp/Desktop/STAT 235/NHANESproject/dietQ.csv")
write.csv(diab, "/Users/leekapp/Desktop/STAT 235/NHANESproject/diabetesQ")

NHANESdata<-left_join(demoDat,BMIdat)
NHANESdata<-left_join(NHANESdata, glucoseDat, by = "Subject")
NHANESdata<-left_join(NHANESdata, glycatedDat, by = "Subject")
NHANESdata<-left_join(NHANESdata, insulinDat, by = "Subject")
NHANESdata<-left_join(NHANESdata, ironDat, by = "Subject")
NHANESdata<-left_join(NHANESdata, ferritinDat, by = "Subject")
NHANESdata<-left_join(NHANESdata, cbcDat, by = "Subject")
NHANESdata<-left_join(NHANESdata, bioproDat, by = "Subject")
NHANESdata<-left_join(NHANESdata, diet1, by = "Subject")
NHANESdata<-left_join(NHANESdata, diab, by = "Subject")
NHANESdata<-left_join(NHANESdata, BP, by = "Subject")

data<-NHANESdata
colnames(data) <- c("Subject", "Gender", "Age (years)", "Race", "BMI", "Fasting Subsample", "Fasting Glucose (mg/dL)", "Fasting Glucose (mmol/L)",
                    "Glycohemoglobin", "Fasting Subsample", "Insulin (µU/ml)", "Insulin (pmol/L)", "Comment Code", "Serum Iron (µg/dL)", "Serum Iron (µmol/L)", "UIBC (µg/dL)",
                    "UIBC comment", "UIBC (µmol/L)", "TIBC (µg/dL)", "TIBC (µmol/dL)", "Transferrin Sat (%)", "Ferritin (ng/ml)", "Ferritin (µg/ml)",
                    "White Cells (1000 cells/µl)", "Lymphocytes (1000 cells/µl)", "Monocytes (1000 cells/µl)", "Segmented Neutrophils (1000 cells/µl)",
                    "Eosinophils (1000 cells/µl)", "Basophils (1000 cells/µl)", "RBCs (million/µl)", "Hemoglobin (g/dL)", "Hematocrit (%)", "Mean Cell Vol (fL)",
                    "Mean Cell HGB (pg)", " Mean Cell HGB Conc. (g/dL)", "Platelets (1000 cells/µl)", "Nucleated RBC",
                    "Alanine Aminotransferase (IU/L)", "ALT comment", "Albumin (g/dL)", "Alk Phos (IU/L)", "Aspartate Aminotransferase (IU/L)",
                    "Creatine Phosphokinase (IU/L)", "Gamma glutamyl Transferase (IU/L)", "GGT comment", "Lactate Dehydrogenase (IU/L)", "Total Bilirubin (g/dL)",
                    "Tot Bil comment", "Cholesterol (mg/dL)", "Total Protein (g/dL)", "Triglycerides (mg/dL)", "Uric Acid (mg/dL)", "Table_Salt_Freq", "Cook_w_Salt", "Salt_Yesterday",
                    "Told_Have_Diab", "Told_Have_Prediab", "Told_Diab_Risk", "Tested_Past_3yr", "Take_Insulin", "A1C_checked_1yr", "Last_A1C", "Last_SBP", "Last_DBP",
                    "Systolic_BP", "Diastolic_BP")
data<-data[-c(48, 45, 39, 37, 36, 23, 20, 18, 17, 15, 13, 12, 10, 8, 6)]       

data <- data %>% mutate_at(vars(Gender), list( ~ case_when(. == 1 ~ "Male", . == 2 ~ "Female")))
data <- data %>% mutate_at(vars(Race), list( ~ case_when(. == 1 ~ "Mex-American", . == 2 ~ "Other Hisp", . == 3 ~ "White", . == 4 ~ "Black", . == 6 ~ "Asian", . == 7 ~ "Other/Multi")))

###Filtering for Adults (Age >= 18)
data <- data %>% filter(`Age (years)` >= 18)

###Coding the data by lab results
data <- data %>% mutate(HgB_A1C = case_when(
  Glycohemoglobin >= 5.7 & Glycohemoglobin < 6.4 ~ "prediabetes",
  Glycohemoglobin >= 6.4 & Glycohemoglobin < 8 ~ "diabetes",
  Glycohemoglobin >= 8 ~ "poorly controlled diabetes",
  Glycohemoglobin < 5.7 ~ "normal",
  is.na(Glycohemoglobin) ~ "unknown"))

data <- data %>% mutate(Blood_Sugar = case_when(
  `Fasting Glucose (mg/dL)` < 100 ~ "normal",
  `Fasting Glucose (mg/dL)` >= 100 & `Fasting Glucose (mg/dL)` < 125 ~ "prediabetes",
  `Fasting Glucose (mg/dL)` >= 125 ~ "diabetes",
  is.na(`Fasting Glucose (mg/dL)`) ~ "unknown"))

data <- data %>% mutate(Hypercholesterolemia = case_when(
  `Cholesterol (mg/dL)` < 200 ~ "no",
  `Cholesterol (mg/dL)` >= 200 & `Cholesterol (mg/dL)` < 239 ~ "borderline",
  `Cholesterol (mg/dL)` >= 239 ~ "yes",
  is.na(`Cholesterol (mg/dL)`) ~ "unknown"))

data <- data %>% mutate(BMI_Category = case_when(
  BMI < 18.5 ~ "underweight",
  BMI >= 18.5 & BMI < 25 ~ "normal",
  BMI >= 25 & BMI < 30 ~ "overweight",
  BMI >= 30 ~ "obese",
  is.na(BMI) ~ "unknown"))

data <- data %>% mutate(Triglyceride_Level = case_when(
  `Triglycerides (mg/dL)` < 150 ~ "desirable",
  `Triglycerides (mg/dL)` >= 150 & `Triglycerides (mg/dL)` <= 199 ~ "borderline",
  `Triglycerides (mg/dL)` >= 200 & `Triglycerides (mg/dL)` <= 499 ~ "high",
  `Triglycerides (mg/dL)` >= 500 ~ "very high",
  is.na(`Triglycerides (mg/dL)`) ~ "unknown"))

data <- data %>% mutate(Liver_Function = case_when(
  `Alanine Aminotransferase (IU/L)` >= 7 | `Alanine Aminotransferase (IU/L)` <= 55 | 
  `Aspartate Aminotransferase (IU/L)` >= 8 | `Aspartate Aminotransferase (IU/L)` <= 48 |
  `Albumin (g/dL)` >= 3.5 | `Albumin (g/dL)` <= 5.0 |
  `Alk Phos (IU/L)` >= 40 | `Alk Phos (IU/L)` <= 129 |
  `Total Protein (g/dL)` >= 6.3 | `Total Protein (g/dL)` <= 7.9 |
  `Gamma glutamyl Transferase (IU/L)` >= 8 | `Gamma glutamyl Transferase (IU/L)` <= 61 |
  `Lactate Dehydrogenase (IU/L)` >= 122 | `Lactate Dehydrogenase (IU/L)` <= 222 ~ "normal",
  is.na(`Alanine Aminotransferase (IU/L)`) &  
  is.na(`Aspartate Aminotransferase (IU/L)`) &
  is.na(`Albumin (g/dL)`) &
  is.na(`Alk Phos (IU/L)`) &
  is.na(`Total Protein (g/dL)`) &
  is.na(`Gamma glutamyl Transferase (IU/L)`) &
  is.na(`Lactate Dehydrogenase (IU/L)`) ~ "unknown",
  TRUE ~ "abnormal"
  ))

data <- data %>% mutate(Ferritin_Level = case_when(
  `Ferritin (ng/ml)` >= 24 & `Ferritin (ng/ml)` <= 336 & Gender == "Male"  ~ "normal",
  `Ferritin (ng/ml)` >= 11 & `Ferritin (ng/ml)` <= 307 & Gender == "Female"  ~ "normal",
  `Ferritin (ng/ml)` < 24 & Gender == "Male" ~ "low",
  `Ferritin (ng/ml)` < 11 & Gender == "Female" ~ "low",
  `Ferritin (ng/ml)` > 336 & Gender == "Male" ~ "high",
  `Ferritin (ng/ml)` > 307 & Gender == "Female" ~ "high",
  is.na(`Ferritin (ng/ml)`) ~ "unknown"))

data <- data %>% mutate(Iron_Level = case_when(
  `Serum Iron (µg/dL)` >= 59 & `Serum Iron (µg/dL)` <= 158 & Gender == "Male"  ~ "normal",
  `Serum Iron (µg/dL)` >= 37 & `Serum Iron (µg/dL)` <= 145 & Gender == "Female"  ~ "normal",
  `Serum Iron (µg/dL)` < 59 & Gender == "Male"  ~ "low",
  `Serum Iron (µg/dL)` < 37 & Gender == "Female"  ~ "low",
  `Serum Iron (µg/dL)` > 158 & Gender == "Male"  ~ "high",
  `Serum Iron (µg/dL)` > 145 & Gender == "Female"  ~ "high",
  is.na(`Serum Iron (µg/dL)`) ~ "unknown"))

data <- data %>% mutate(Iron_Saturation = case_when(
  `Transferrin Sat (%)` >= 20 & `Transferrin Sat (%)` <= 50 & Gender == "Male"  ~ "normal",
  `Transferrin Sat (%)` >= 15 & `Transferrin Sat (%)` <= 50 & Gender == "Female"  ~ "normal",
  `Transferrin Sat (%)` < 20 | `Transferrin Sat (%)` > 50 & Gender == "Male"  ~ "abnormal",
  `Transferrin Sat (%)` < 15 | `Transferrin Sat (%)` > 50 & Gender == "Female"  ~ "abnormal",
  is.na(`Transferrin Sat (%)`)  ~ "unknown"))

data <- data %>% mutate(Iron_Binding = case_when(
  `TIBC (µg/dL)` >= 250 & `TIBC (µg/dL)` <= 425 ~ "normal",
  `TIBC (µg/dL)` < 250  ~ "low",
  `TIBC (µg/dL)` > 425 ~ "high",
  is.na(`TIBC (µg/dL)`)  ~ "unknown"))

data <- data %>% mutate_at(vars(Gender, Race, HgB_A1C, Blood_Sugar, Hypercholesterolemia, BMI_Category, Triglyceride_Level, 
                                Liver_Function, Ferritin_Level, Iron_Level, Iron_Saturation, Iron_Binding, Table_Salt_Freq, Cook_w_Salt, 
                                Salt_Yesterday, Told_Have_Diab, Told_Have_Prediab, Told_Diab_Risk, Tested_Past_3yr, Take_Insulin, 
                                A1C_checked_1yr ), list(factor))

write.csv(data, "/Users/leekapp/Desktop/STAT 235/NHANESproject/NHANESdata.csv")
