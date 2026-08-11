#Demography data sheet mockups
#turning mortality/germination data into reproductive phenology datasheet
#created Jan 1 2022
#updated Feb 10 2022
#Sarah Ashlock

install.packages("readxl")
install.packages("tidyverse")

library(readxl)
library(tidyverse)

getwd()
dir()

#loading in most recent mortality data
mort <- read_excel("demography_datasheets/data/TM2_mortality_2022_survey2_finished (1).xlsx")

#keeping track of living colors/germ cohorts in mort dataset
colnames(mort) #red, yellow, blue

#making data frames of individual livings plants by pick color

#adding rows for the individual living plants 
#adding column of corresponding pick color
#renaming living color with plant_count to match up dataframes later with names()
  #note plant_count will help us keep track of how many plants of each color
#taking out columns not needed with subset()
living.red <- mort[rep(row.names(mort), mort$red_living), 1:ncol(mort)]
living.red$pick_color = "red"
names(living.red)[names(living.red) == "red_living"] <- "plant_count"
living.red = subset(living.red, select = -c(red_dead, yellow_living, yellow_dead, blue_living, blue_dead))

living.yellow <- mort[rep(row.names(mort), mort$yellow_living), 1:ncol(mort)]
living.yellow$pick_color = "yellow"
names(living.yellow)[names(living.yellow) == "yellow_living"] <-   "plant_count"
living.yellow = subset(living.yellow, select = -c(red_living, red_dead, yellow_dead, blue_living, blue_dead))

living.blue <- mort[rep(row.names(mort), mort$blue_living), 1:ncol(mort)]
living.blue$pick_color = "blue"
names(living.blue)[names(living.blue) == "blue_living"] <- "plant_count"
living.blue = subset(living.blue, select = -c(red_living, red_dead, yellow_living, yellow_dead, blue_dead))

#loading in most recent germination data
#note most recent cohort, here "orange", wouldn't have been accounted for in simultaneous mortality survey
germ <- read_excel("demography_datasheets/data/TM2_germinationsurvey_2022_set1_finished.xlsx")

#filtering by most recent germ cohort, in this case "orange"
germ_orange <- filter(germ, pick_color == "orange")

#expanding orange cohort living plants into individual rows
#don't need to add pick_color as already in entered data!
#note orange cohort only germinated on lower transect
living.orange <- germ_orange[rep(row.names(germ_orange), germ_orange$number_germ), 1:ncol(germ_orange)]
names(living.orange)[names(living.orange) == "number_germ"] <- "plant_count"

#combining all dataframes vertically
living.total <- rbind(living.red, living.yellow, living.blue, living.orange)

#checking column names to remove extra columns
#removing columns not needed in datasheet
colnames(living.total)
repropheno.pt1 = subset(living.total, select = -c(date_entered, entered_by, survey_year, survey_date, notes))

#adding repro pheno columns
repropheno.pt1$phenology = " "
repropheno.pt1$sword_color = " "
repropheno.pt1$notes = " "

#sorting by transect then by quadrat number
repropheno.final <-repropheno.pt1[order(repropheno.pt1$transect_plot,repropheno.pt1$quadrat),]

#write dataframe to csv file
write.csv(repropheno.final,"demography_datasheets/prefilled_datasheets/TM2_repropheno_datasheet_2022_prefilled.csv", row.names = FALSE)




