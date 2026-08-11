#Demography data sheet mockups
#turning reproductive phenology data into annual census datasheet
#created Feb 10 2022
#updated Feb 11 2022
#Sarah Ashlock

#install.packages("readxl")
#install.packages("tidyverse")

library(readxl)
library(tidyverse)
library(tidyr)

getwd()
dir()

#loading in most recent reproductive phenology data
repropheno <- read_excel("demography_datasheets/data/TM2_repropheno_survey_20210517.xlsx")

#filtering dataframe to only have living phenology
repropheno.living = filter(repropheno, phenology == "V" | phenology == "B" |phenology == "F"| phenology =="P")

#removing columns not needed for annual census survey
colnames(repropheno.living)
repropheno.livingpt1 = subset(repropheno.living, select = -c(phenology, notes))

#adding annual census variables/columns to match last year's data
names(repropheno.livingpt1)[names(repropheno.livingpt1) == "quad"] <- "quadrat"
names(repropheno.livingpt1)[names(repropheno.livingpt1) == "transect"] <- "transect_plot"
repropheno.livingpt1$band_color = " "
repropheno.livingpt1$band_number = " "
repropheno.livingpt1$pheno = " "
repropheno.livingpt1$X = " "
repropheno.livingpt1$Y = " "

#loading in annual census data from previous year for bird bands
last.year.census <- read_excel("demography_datasheets/data/TM2_AnnualCensus_2020531 .xlsx")

#filtering datframe to only have living bird bands from last year
last.year.censuspt1 = filter(last.year.census, band_number != "NA")
last.year.censuspt2 = filter(last.year.censuspt1, phenology == "V" | phenology == "B" |phenology == "F"| phenology =="P")

#removing, renaming, and adding columns to match repro phenology
last.year.censuspt3 = subset(last.year.censuspt2, select = -c(15:24))
names(last.year.censuspt3)[names(last.year.censuspt3) == "phenology"] <- "pheno"
last.year.censuspt3$pheno = " "
last.year.censuspt3$pick_color = "NA"
last.year.censuspt3$sword_color = "NA"

#combining dataframes vertically
#removing columns not needed
annual.census.total <- rbind(last.year.censuspt3, repropheno.livingpt1)
annual.census.total  = subset(annual.census.total , select = -c(1:4))

#adding remaining annual census variables
annual.census.total$diam_mm = " "
annual.census.total$height_cm = " "
annual.census.total$total_branch = " "
annual.census.total$lngst.leaf.cm = " "
annual.census.total$flws = " "
annual.census.total$fruits = " "
annual.census.total$lngst.fruit.cm = " "
annual.census.total$repro_brnch = " "
annual.census.total$herb_dam = " "
annual.census.total$notes = " "

#if columns need to be reordered, in this case they do not
#annual.census.final <- select(annual.censuspt1, site, transect_plot, quadrat, pick_color,    sword_color, band_color, band_number, pheno, X, Y, diam_mm, height_cm, total_branch, lngst.leaf.cm, flws, fruits, repro_brnch, herb_dam, notes)

#sort final datasheet by site, transect_plot, quad
annual.census.final <- annual.census.total[order(annual.census.total$site, annual.census.total$transect_plot,annual.census.total$quadrat),]

#write dataframe to csv file
write.csv(annual.census.final,"demography_datasheets/prefilled_datasheets/TM2_annualcensus_2021_prefilled.csv", row.names = FALSE)





