rm(list = ls())
library(readxl)
library(stringr)
library(plyr)

data_variables = read_excel("August2015.xls", sheet = "Variable List")
data_variables$Year = str_remove(data_variables$Year, "[*]")

# ACCESS
data_access = read_excel("August2015.xls", sheet = "ACCESS")
data_access$FIPS = as.numeric(data_access$FIPS)
data_access <-
  data_access[, c(
    "FIPS",
    "State",
    "County",
    "PCT_LACCESS_POP10",
    "PCT_LACCESS_LOWI10",
    "PCT_LACCESS_HHNV10"
  )]

# HEALTH
data_health = read_excel("August2015.xls", sheet = "HEALTH")
data_health$FIPS = as.numeric(data_health$FIPS)
data_health <-
  data_health[, c(
    "FIPS",
    "State",
    "County",
    "PCT_OBESE_ADULTS09",
    "PCT_OBESE_ADULTS10",
    "PCT_OBESE_ADULTS13",
    "RECFACPTH07",
    "RECFACPTH12",
    "NATAMEN"
  )]

# LOCAL
data_local = read_excel("August2015.xls", sheet = "LOCAL")
data_local$FIPS = as.numeric(data_local$FIPS)
data_local <-
  data_local[, c("FIPS", "State", "County", "FMRKTPTH09",
                 "FMRKTPTH13")]

# PRICES AND TRAXES
data_prices = read_excel("August2015.xls", sheet = "PRICES_TAXES")
data_prices$FIPS = as.numeric(data_prices$FIPS)
data_prices <-
  data_prices[, c("FIPS", "State", "County", "MILK_SODA_PRICE10")]

# RESTAURANTS
data_restaurants = read_excel("August2015.xls", sheet = "RESTAURANTS")
data_restaurants$FIPS = as.numeric(data_restaurants$FIPS)
data_restaurants <-
  data_restaurants[, c(
    "FIPS",
    "State",
    "County",
    "FFRPTH07",
    "FFRPTH12",
    "FSRPTH07",
    "FSRPTH12",
    "PC_FFRSALES02",
    "PC_FFRSALES07",
    "PC_FSRSALES02",
    'PC_FSRSALES07'
  )]
# STORES
data_stores = read_excel("August2015.xls", sheet = "STORES")
data_stores$FIPS = as.numeric(data_stores$FIPS)
data_stores <- data_stores[, c(
  "FIPS",
  "State",
  "County",
  "GROCPTH07",
  "GROCPTH12",
  "SUPERCPTH07",
  "SUPERCPTH12",
  "CONVSPTH07",
  "CONVSPTH12",
  "SPECSPTH07",
  "SPECSPTH12",
  "SNAPSPTH08",
  "SNAPSPTH12",
  "WICSPTH08",
  "WICSPTH12"
)]

# SOCIOECONOMIC
data_sc = read_excel("August2015.xls", sheet = "SOCIOECONOMIC")
data_sc$FIPS = as.numeric(data_sc$FIPS)
data_sc <-
  data_sc[, c(
    "FIPS",
    "State",
    "County",
    "PCT_NHWHITE10",
    "PCT_HISP10",
    "PCT_NHBLACK10",
    "PCT_NHASIAN10",
    "PCT_NHNA10",
    "PCT_NHPI10",
    "MEDHHINC10",
    "POVRATE10",
    "METRO13",
    "PCT_65OLDER10",
    "PCT_18YOUNGER10"
  )]


# ASSISTANCE
data_ass = read_excel("August2015.xls", sheet = "ASSISTANCE")
data_ass$FIPS = as.numeric(data_ass$FIPS)
data_ass <- data_ass[, c("FIPS",
                        "State",
                        "County",
                        "PCT_SNAP09",
                        "PCT_SNAP14",
                        "PCT_WIC09",
                        "PCT_WIC14")]

# Merging Categories
mergeCols <- c("FIPS","State","County")
df_final <- Reduce(function(x, y) merge(x, y, by = mergeCols), list(data_access, data_health, data_prices, data_local,
                                                                    data_prices,data_restaurants, data_stores, data_sc, data_ass ))

rm(data_access,data_health,data_local,data_prices,data_stores, data_restaurants, data_sc,data_ass)
df_final =  within(df_final, MILK_SODA_PRICE10.y[State == 'AK'] <- mean(df_final[df_final$State == "AL",]$MILK_SODA_PRICE10.y))
df_final =  within(df_final, MILK_SODA_PRICE10.y[State == 'HI'] <- mean(df_final[df_final$State == "AL",]$MILK_SODA_PRICE10.y) + 0.5)
col = data_variables$`Variable Code`
col = append(col, 'FIPS', after = length(col))
col = append(col, 'State', after = length(col))
col = append(col, 'County', after = length(col))

write.csv(df_final, "FoodAtlas.csv",row.names = FALSE)

df_final <- df_final[ which(df_final$State == 'FL'), ]

df_final <- df_final %>% gather(Year, Obesity, PCT_OBESE_ADULTS09:PCT_OBESE_ADULTS13)
df_final <- df_final %>% gather(Year, 'Recreation Facilities', RECFACPTH07:RECFACPTH12)
df_final <- df_final %>% gather(Year, 'Farmers Market', FMRKTPTH09:FMRKTPTH13)
df_final <- df_final %>% gather(Year, 'SNAP Stores', SNAPSPTH08:SNAPSPTH12)
df_final <- df_final %>% gather(Year, 'WIC Stores', WICSPTH08:WICSPTH12)
df_final <- df_final %>% gather(Year, '% SNAP Participants', PCT_SNAP09:PCT_SNAP14)
df_final <- df_final %>% gather(Year, '% WIC Participants', PCT_WIC09:PCT_WIC14)
df_final <- df_final %>% gather(Year, 'Fast Food Restaurants', FFRPTH07:FFRPTH12)
df_final <- df_final %>% gather(Year, 'Full Service Restaurants', FSRPTH07:FSRPTH12)
df_final <- df_final %>% gather(Year, 'Grocery Stores', GROCPTH07:GROCPTH12)
df_final <- df_final %>% gather(Year, 'Super Stores', SUPERCPTH07:SUPERCPTH12)
df_final <- df_final %>% gather(Year, 'Convenience Stores', CONVSPTH07:CONVSPTH12)
df_final <- df_final %>% gather(Year, 'Speciality Stores', SPECSPTH07:SPECSPTH12)

df_final$Year <- mapvalues(df_final$Year, 
                                from=data_variables$`Variable Code`, 
                                to=data_variables$Year)

df_final <- df_final %>% gather(Rest_Year, 'Fast Food Expenditure Per Capita', PC_FFRSALES02:PC_FFRSALES07)
df_final <- df_final %>% gather(Rest_Year, 'Full Service Expenditure Per Capita', PC_FSRSALES02:PC_FSRSALES07)
df_final$Rest_Year <- mapvalues(df_final$Rest_Year, 
                                from=data_variables$`Variable Code`, 
                                to=data_variables$Year)

colnames(df_final)
write.csv(df_final, "FoodAtlas.csv",row.names = FALSE)