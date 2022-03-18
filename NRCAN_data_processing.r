library(tidyverse)

DEF_data_raw <- read.csv("metro_vancouver_def_all_tsv.csv", stringsAsFactors = FALSE)
ABC_data_raw <- read.csv("NEW_metro_vancouver_abc_all_tsv.csv", stringsAsFactors = FALSE)
NH_data_raw <- read.csv("metro_vancouver_nh evaluations_all_tsv.csv", stringsAsFactors = FALSE, skip = 1, header = TRUE)

#The first columns name needs to be updated
names(DEF_data_raw)[1] <- "EVAL_ID"
###########################################
#DEF Data
###########################################
#Data have a challenging structure, appear to be some kind of legacy XML/XLS format
#each home gets a unique ID and the data are broken into sections by ID
#The section breaks have blank data, so we can use this to eliminate these rows. Make
#the assumption that if CLIENTCITY and POSTALCODE are blank, it is a secton break
###########################################

DEF_data <- DEF_data_raw %>%
              filter(CLIENTCITY != "" & POSTALCODE != "") #%>%
              #pivot_longer(4:339, names_to = "Parameter")

raw_city_list <- unique(DEF_data$CLIENTCITY)

write.csv(DEF_data, file = "DEF_step1_TABLEAU.csv", row.names = FALSE)
write.csv(raw_city_list, file = "raw_city_list_DEF.csv", row.names = FALSE)  

CLEAN_city_names <- read.csv("CLEAN_city_list_DEF.csv", stringsAsFactors = FALSE)

DEF_data_cleaned <- DEF_data %>%
                      left_join(CLEAN_city_names, by = c("CLIENTCITY" = "Raw.Name")) %>%
                      #filter(MVRD == "Y") %>%
                      mutate(CLIENTCITY = Corrected.Name) %>%
                      mutate(EVAL_ID = as.numeric(gsub(",", "", EVAL_ID)))

write.csv(DEF_data_cleaned, file = "DEF_step1_TABLEAU.csv", row.names = FALSE)


###########################################
#NH Data
###########################################
#This is a little different than DEF, the sections are 3 digit FSA
#Search the Eval_ID for the first character and if it is a V, filter it out
###########################################
NH_data <- NH_data_raw %>%
            filter(substr(EVAL_ID,1,1) != "V")

raw_city_list_NH <- unique(NH_data$CLIENTCITY)
write.csv(raw_city_list_NH, file = "raw_city_list_NH.csv", row.names = FALSE) 

CLEAN_city_names_NH <- read.csv("CLEAN_city_list_NH.csv", stringsAsFactors = FALSE)

NH_data_cleaned <- NH_data %>%
                      left_join(CLEAN_city_names_NH, by = c("CLIENTCITY" = "Raw.Name")) %>%
                      mutate(CLIENTCITY = Corrected.Name) %>%
                      mutate(EVAL_ID = as.numeric(gsub(",", "", EVAL_ID)))

write.csv(NH_data_cleaned, file = "NH_step1_TABLEAU.csv", row.names = FALSE)

###########################################
#ABC Data
###########################################
#Again, different format than the other files
#This is grouped by both the 3 digit PCode and the Evaluation ID
#Use a hybrid of the DEF and NH approach to remove blank rows
###########################################

ABC_data <- ABC_data_raw %>%
              filter(substr(EVAL_ID,1,1) != "V") %>%
              filter(CLIENTCITY != "" & CLIENTPCODE != "") 


raw_city_list_ABC <- unique(ABC_data$CLIENTCITY)
write.csv(raw_city_list_ABC, file = "raw_city_list_ABC.csv", row.names = FALSE) 

CLEAN_city_names_ABC <- read.csv("CLEAN_city_list_ABC.csv", stringsAsFactors = FALSE)

ABC_data_cleaned <- ABC_data %>%
  left_join(CLEAN_city_names_ABC, by = c("CLIENTCITY" = "Raw.Name")) %>%
  mutate(CLIENTCITY = Corrected.Name) %>%
  mutate(EVAL_ID = as.numeric(gsub(",", "", EVAL_ID)))

write.csv(NH_data_cleaned, file = "ABC_step1_TABLEAU.csv", row.names = FALSE)
