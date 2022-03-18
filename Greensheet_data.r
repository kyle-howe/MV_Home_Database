library(openxlsx)
library(tidyverse)
library(readxl)

raw_gs_export1 <- read_xls("./gs_exports.zip-2022-3-16 11.56.34/gs_export_1.xls")
raw_gs_export2 <- read_xls("./gs_exports.zip-2022-3-16 11.56.34/gs_export_2.xls")

raw_gs_export1_csv <- read.csv("./gs_exports.zip-2022-3-16 11.56.34/gs_export_1.csv", stringsAsFactors = FALSE)
raw_gs_export2_csv <- read.csv("./gs_exports.zip-2022-3-16 11.56.34/gs_export_2.csv", stringsAsFactors = FALSE)

#the csv files have all the data, so create one master dataset. export 2 is missing
# the BP.ID, so create a dummy one
raw_gs_export2_csv <- raw_gs_export2_csv %>%
                        mutate(BP.ID = NA)

Greensheet_master <- rbind(raw_gs_export1_csv,raw_gs_export2_csv)

write.csv(Greensheet_master, file = "greensheet_all_data.csv", row.names = FALSE)



temp <- Greensheet_master %>%
          filter(PROJECT.TYPE %in% c("residential add/alter","multi-family new","multi-family add/alter","residential new")) %>%
          filter(grepl('heat|heating|gas|pump|furnace', PROJECT.DETAILS))




#gs_export1_top20 <- raw_gs_export1[1:20,]
#gs_export2_top20 <- raw_gs_export2[1:20,]
#
#gs_export1_top20_csv <- raw_gs_export1_csv[1:20,]
#gs_export2_top20_csv <- raw_gs_export2_csv[1:20,] 
#
#write.csv(gs_export1_top20, file = "Top20_gs_export1_xls.csv", row.names = FALSE)
#write.csv(gs_export2_top20, file = "Top20_gs_export2_xls.csv", row.names = FALSE)
#write.csv(gs_export1_top20_csv, file = "Top20_gs_export1_csv.csv", row.names = FALSE)
#write.csv(gs_export2_top20_csv, file = "Top20_gs_export2_csv.csv", row.names = FALSE)
