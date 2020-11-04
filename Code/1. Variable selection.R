rm(list=ls())
library(readxl)
library(dplyr)
library(tidyverse)
# POPULATION
data_population = read_excel("August2015.xls", sheet = "Supplemental Data - County")
data_population$FIPS = as.numeric(data_population$FIPS)
data_population <- data_population[,c("FIPS", "State","County","2010 Census Population")]
# ACCESS
data_access = read_excel("August2015.xls", sheet = "ACCESS")
data_access$FIPS = as.numeric(data_access$FIPS)
data_access <- data_access[, c("FIPS", "State","County", "PCT_LACCESS_LOWI10")]
# HEALTH
data_health = read_excel("August2015.xls", sheet = "HEALTH")
data_health$FIPS = as.numeric(data_health$FIPS)
data_health <- data_health[, c("FIPS","State","County","PCT_OBESE_ADULTS10","RECFAC07","NATAMEN", "RECFACPTH07")]
# LOCAL
data_local = read_excel("August2015.xls", sheet = "LOCAL")
data_local$FIPS = as.numeric(data_local$FIPS)
data_local <- data_local[, c("FIPS","State","County","FMRKT09", "FMRKTPTH09")]
# PRICES AND TRAXES
data_prices = read_excel("August2015.xls", sheet = "PRICES_TAXES")
data_prices$FIPS = as.numeric(data_prices$FIPS)
data_prices <- data_prices[, c("FIPS","State","County","MILK_SODA_PRICE10")]
# RESTAURANTS
data_restaurants = read_excel("August2015.xls", sheet = "RESTAURANTS")
data_restaurants$FIPS = as.numeric(data_restaurants$FIPS)
data_restaurants <- data_restaurants[, c("FIPS","State","County","FFR07", "FFRPTH07", "FSRPTH07", "FSR07")]
# STORES
data_stores = read_excel("August2015.xls", sheet = "STORES")
data_stores$FIPS = as.numeric(data_stores$FIPS)
data_stores <- data_stores[,c("FIPS","State","County","GROC07","SUPERC07","CONVS07","SPECS07",
                              "GROCPTH12", "SUPERCPTH07", "CONVSPTH07", "SPECSPTH07")]
# SOCIOECONOMIC
data_sc = read_excel("August2015.xls", sheet = "SOCIOECONOMIC")
data_sc$FIPS = as.numeric(data_sc$FIPS)
data_sc <- data_sc[,c("FIPS","State","County","PCT_NHWHITE10","PCT_HISP10","PCT_NHBLACK10","PCT_NHASIAN10","PCT_NHNA10",
                      "PCT_NHPI10","MEDHHINC10","POVRATE10","METRO13")]
# Merging Categories
mergeCols <- c("FIPS","State","County")
df_final <- Reduce(function(x, y) merge(x, y, by = mergeCols), list(data_population,data_access, data_health, data_prices, data_local,
                                                                    data_prices,data_restaurants, data_stores, data_sc ))
# Gini Index
gini_index = read.csv("GiniIndex.csv")
gini_index <- gini_index[,c("FIPS","Gini.Index")]
# County Commute
commute = read.csv("county_commute.csv")
commute <- commute[,c("FIPS","car.alone","walk", "public.transportation")]
# Education in County
education = read.csv("County_Education.csv")
education <- education[,c("FIPS","Bachelorsorhigher")]

households = read.csv("households.csv")
households <- households[,c("FIPS", "occupied_housing_units")]

# Adding Gini Index and commute data to final dataset
df_final<-merge(df_final,commute, by = "FIPS", all.x = TRUE)
df_final<-merge(df_final,gini_index, by = "FIPS", all.x = TRUE)
df_final <- merge(df_final,education, by = "FIPS", all.x = TRUE)
df_final <- merge(df_final,households, by = "FIPS", all.x = TRUE)
dim(df_final)

rm(data_access,data_health,data_local,data_prices,data_stores,
   data_restaurants, data_sc,gini_index,commute, education)

df_final$MILK_SODA_PRICE10.x <- NULL

na_count <-sapply(df_final, function(y) sum(length(which(is.na(y)))))
na_count <- data.frame(na_count)
na_count
# Missing values of MILK_SODA_PRICE
df_final =  within(df_final, MILK_SODA_PRICE10.y[State == 'AK'] <- mean(df_final[df_final$State == "AL",]$MILK_SODA_PRICE10.y))
df_final =  within(df_final, MILK_SODA_PRICE10.y[State == 'HI'] <- mean(df_final[df_final$State == "AL",]$MILK_SODA_PRICE10.y) + 0.5)
# Farmer's Market
df_final$FMRKT09[is.na(df_final$FMRKT09)] <- 0

# removing missing values
df_final =  df_final[complete.cases(df_final), ]

## Renaming columns
df_final <- df_final %>%
  rename(
    'population_2010'         = '2010 Census Population',
    'fullservice_restaurants' = 'FSR07',
    'fastfood_restaurants'    = 'FFR07',
    'farmers_mrkt'            = 'FMRKT09',
    'conv_stores'             = 'CONVS07',
    'super_center'            = 'SUPERC07',
    'specalized_strs'         = 'SPECS07',
    'grocery_stores'          = 'GROC07',
    'pct_lacess_store'        = 'PCT_LACCESS_LOWI10',
    'obesity_rate'            = 'PCT_OBESE_ADULTS10',
    'natural_amenity'         = 'NATAMEN',
    'milk_soda_price'         = 'MILK_SODA_PRICE10.y',
    'recreation_fac'          = 'RECFAC07',
    'poverty_rate'            = 'POVRATE10',
    'metro_county'            = 'METRO13',
    'median_income'           = 'MEDHHINC10',
    'white'                   = 'PCT_NHWHITE10',
    'black'                   = 'PCT_NHBLACK10',
    'hisp'                    = 'PCT_HISP10',
    'asian'                   = 'PCT_NHASIAN10',
    'alaska'                  = 'PCT_NHNA10',
    'giniindex'               = "Gini.Index",
    'onlycar'                 = "car.alone",
    'hawaiian'                = 'PCT_NHPI10',
     'grocery_per1k' = 'GROCPTH12', 
    'supercenter_per1k' = 'SUPERCPTH07', 
    'convenience_per1k' = 'CONVSPTH07', 
    'speciality_per1k' = 'SPECSPTH07',
    'fastfood_rest_per1k' = 'FFRPTH07',
    'fullservice_rest_per1k' = 'FSRPTH07',
    'farmers_market_per_1k' = 'FMRKTPTH09',
    'recreation_per1k' = 'RECFACPTH07'
  )

write.csv(df_final, "final_data.csv",row.names = FALSE)
