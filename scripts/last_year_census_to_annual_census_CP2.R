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
last.year.census <- read_excel("C:/Users/jrgremer/Box/Gremer Lab/Streptanthus project/Demography/Wrights Lake_Carson Pass/Annual Census - WL & CP/Annual Census 2023/CP2_annualcensus_2023_finished.xlsx")
summary(last.year.census)
head(last.year.census)
dim(last.year.census)
#filtering datframe to only plants that were banded last year 
#some may not have X and Y coordinates, particularly at TM2 and BH, where we did extra sampling off the transects/plots 
last.year.censuspt1 = filter(last.year.census, band_color != "NA")
dim(last.year.censuspt1)
table(last.year.censuspt1$transect_plot, last.year.censuspt1$band_color) #
table(last.year.censuspt1$pheno, last.year.censuspt1$band_color) #

last.year.censuspt2 = filter(last.year.censuspt1, pheno %in% c("V", "B", "F", "P")) #this is all but X
dim(last.year.censuspt2)
table(last.year.censuspt2$pheno)
table(last.year.censuspt2$transect_plot, last.year.censuspt2$band_color) #

#removing, renaming, and adding columns make datasheets
names(last.year.censuspt2)

unique(last.year.censuspt2$transect_plot)

#for specific order of transects, like at TM2
#transect_order = c("upper", "lower", "seep", "outcrop")


fatesdatasheet = last.year.censuspt2 %>%
                     # mutate(quad = as.numeric(quad)) %>%
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
write.csv(fatesdatasheet,"C:/Users/jrgremer/Box/Gremer Lab/Streptanthus project/Demography/Blank demog datasheets/Annual census data sheets/CP2_annualcensus_2024_prefilled_notformatted.csv", row.names = FALSE)


#create datasheet for new data at the quad level, which at CP2 is just the unique plots 
plots = unique(last.year.census$transect_plot)

newdatasheet = data.frame(transect = c(plots), quad = NA) %>%
               mutate( num_V = "", num_B = "", num_F = "", num_P= "", notes = "") %>%
               arrange(plots)
              

write.csv(newdatasheet,"C:/Users/jrgremer/Box/Gremer Lab/Streptanthus project/Demography/Blank demog datasheets/Annual census data sheets/CP2_annualcensus_2024_quadlevel_notformatted.csv", row.names = FALSE)

