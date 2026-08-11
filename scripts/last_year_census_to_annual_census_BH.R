#Demography data sheet mockups
#turning reproductive phenology data into annual census datasheet
#created from a copy of Sarah Ashlock's "repropheno_last_year_census_to_annual_census.R
#updated 5/9/2024
#Jenny Gremer

#install.packages("readxl")
#install.packages("tidyverse")

library(readxl)
library(tidyverse)
library(tidyr)

getwd()
dir()

#loading in last year's census data 
last.year.census <- read_excel("C:/Users/jrgremer/Box/Gremer Lab/Streptanthus project/Demography/Ben Hur Road/2023/BH_annualcensus_2023_finished.xlsx")
summary(last.year.census)
head(last.year.census)
dim(last.year.census)
#filtering datframe to only plants that were banded last year 
#some may not have X and Y coordinates, particularly at TM2 and BH, where we did extra sampling off the transects/plots 
last.year.censuspt1 = filter(last.year.census, band_color != "NA")
dim(last.year.censuspt1)
table(last.year.censuspt1$transect_plot, last.year.censuspt1$band_color) #

last.year.censuspt2 = filter(last.year.censuspt1, pheno %in% c("V", "B", "F", "P")) #this is all but X
dim(last.year.censuspt2)
table(last.year.censuspt2$pheno)
table(last.year.censuspt2$transect_plot, last.year.censuspt2$band_color) #

#removing, renaming, and adding columns make datasheets
names(last.year.censuspt2)

#for specific order of transects, like at TM2
unique(last.year.censuspt2$transect_plot)
#transect_order = c("upper", "lower", "seep", "outcrop")

fatesdatasheet = last.year.censuspt2 %>%
                      mutate(quad = as.numeric(quad)) %>%
                      #select columns to carry over from last year
                      select(transect = transect_plot, quad = quad, band_col = band_color, band_num, X, Y) %>%
                      #add remaining columns for annual census measurements
                      mutate(pheno = "", diam_mm = " ", height_cm = " ", total_branch = " ",
                             lngst.leaf.cm = " ", flws = " ", fruits = " ", lngst.fruit.cm = " ", 
                             repro_brnch = " ", herb_dam = " ", notes = " ") %>%
                      #arrange(transect, quad) %>%
                      #for specific order, like TM2
                      arrange(factor(transect),
                              quad) 

#write dataframe to csv file
write.csv(fatesdatasheet,"demography_datasheets/prefilled_datasheets/BH_annualcensus_2024_prefilled.csv", row.names = FALSE)


#create datasheet for new data at the quad level, which we are taking for 2024 (limited sampling)
trans1 = expand.grid(transect = "1", quad = seq(0,10,0.5)) #transect 1 is 10m
trans2 = expand.grid(transect = "2", quad = seq(0,5,0.5))  #transect 2 is 5m

newdatasheet = rbind.data.frame(trans1, trans2) %>%
               mutate(num_V = "", num_B = "", num_F = "", num_P= "", notes = "")

write.csv(newdatasheet,"demography_datasheets/prefilled_datasheets/BH_annualcensus_2024_quadlevel.csv", row.names = FALSE)

