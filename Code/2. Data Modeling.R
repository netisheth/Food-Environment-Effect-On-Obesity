library(DataExplorer)
library(car)
library(dplyr)
library(corrplot)
library(stargazer)
library(MASS)
rm(list=ls())
df = read.csv("final_data.csv")

# Correcting data type
df$metro_county = as.factor(df$metro_county)
df$metro_county = relevel(df$metro_county, 1)

# Removing unncecessary variables
df$FIPS <- NULL
df$State <- NULL
df$County <- NULL
df$black <- NULL
df$hisp <- NULL
df$asian <- NULL
df$alaska <- NULL
df$hawaiian <- NULL
df$median_income <- NULL
# df$walk <- NULL
df$giniindex <- NULL
df$onlycar <- NULL
df$total_stores <- NULL
df$log_occupied_housing <- NULL
df$farmers_mrkt <- NULL
df$fastfood_restaurants <- NULL
df$fullservice_restaurants <- NULL
df$grocery_stores <- NULL
df$super_center <- NULL
df$conv_stores <- NULL
df$specalized_strs <- NULL
df$occupied_housing_units <- NULL

df$recreation_fac <- NULL

# May be needed later
df$population_2010 <- NULL
df$convenience_per1k <-NULL

attach(df)

# Plot correlation plot
plotCorrelation <- function(data ){
  cor_df = cor(data[sapply(data, is.numeric)])
  corrplot(cor_df, title="Correlation Plot")
}

plotHistogram <- function(df) {
  for (i in colnames(df)){
  print(i)
  hist(df[,i],main=paste("histogram curve of column:",i))
  }
}

library(ggplot2)
plotScatterPlot <- function(df) {
  for (i in colnames(df)){
    plot(df[,i], df$obesity_rate, main=paste("Scatter plot of:", i))
  }
}

plotCorrelation(df)
plotHistogram(df)
plotScatterPlot(df)

colnames(df)
attach(df)


# Basic OLS model
ols1 <- lm(obesity_rate ~ pct_lacess_store + natural_amenity + recreation_per1k +
            milk_soda_price + metro_county + fastfood_rest_per1k +
            fullservice_rest_per1k + grocery_per1k + supercenter_per1k + speciality_per1k + 
            farmers_market_per_1k + white + poverty_rate  + walk +
            Bachelorsorhigher + public.transportation, data = df)
# vif(ols1)

# OLS model with only control variables
ols2 <- lm(obesity_rate ~ pct_lacess_store + recreation_per1k +
             milk_soda_price + fastfood_rest_per1k + fullservice_rest_per1k +
             grocery_per1k + supercenter_per1k + speciality_per1k + walk + 
             farmers_market_per_1k + poverty_rate  +
             Bachelorsorhigher + public.transportation, data = df)
# vif(ols2)

# OLS model with control variables and interaction terms
ols3 <- lm(obesity_rate ~ pct_lacess_store + milk_soda_price  + fullservice_rest_per1k +
             farmers_market_per_1k + walk + poverty_rate  + grocery_per1k +
             Bachelorsorhigher + public.transportation + supercenter_per1k +
             fastfood_rest_per1k*speciality_per1k +
             recreation_per1k*fastfood_rest_per1k +
             grocery_per1k*pct_lacess_store, data = df)
plot(ols3)
stargazer(ols1, ols2, ols3, type="text", title = "Comparision Models", out="output.doc")


hist(ols3$res)
qqnorm(ols3$res) 
qqline(ols3$res, col="red")
shapiro.test(ols3$res)               # Residuals not MV normal


plot(ols3$res ~ ols3$fit)
bartlett.test(list(ols3$res, ols3$fit))
norm <- rnorm(630)
bartlett.test(list(ols3$res, norm))  # Residuals heteroskedastic


library("car")
vif(ols3)                            # No multicollinearity in data