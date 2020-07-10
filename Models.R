setwd("/Users/harikagillela/Course Work/SDM/Project")
library(DataExplorer)
library(car)
library(dplyr)
library(corrplot)
library(stargazer)
rm(list=ls())
df = read.csv("final_data.csv")

df$metro_county = as.factor(df$metro_county)
df$metro_county = relevel(df$metro_county, 1)
# Obesity Count 
df$obesity <- (df$obesity_rate / 100) * df$population_2010
# Log transformation
df$log_obesity <- log(df$obesity)
attach(df)

# check correlation
check_cor = df[,c("pct_lacess_store","recreation_fac", "natural_amenity","milk_soda_price", "white", 
               "poverty_rate","Bachelorsorhigher", "food_index1", "food_index2", "food_index3", 
               "obesity_rate")]
plot_correlation(check_cor)
cor_df = cor(check_cor)
corrplot(cor_df)


#' OLS models with obesity count and log transformation
#' Interaction on recreation facilities and natural amenities
#' food_index1 values are positive but Low income & low access to store is negative
m1 <- lm(obesity_rate ~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price 
         + white + poverty_rate + metro_county+ Bachelorsorhigher + food_index1, data = df)
m2 <- lm(obesity_rate ~ pct_lacess_store  + recreation_fac*natural_amenity + milk_soda_price 
         + white + poverty_rate + metro_county + Bachelorsorhigher + food_index2, data = df)
m3 <- lm(obesity_rate ~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price 
         + white + poverty_rate + metro_county+ Bachelorsorhigher + food_index3, data = df)
stargazer(m1,m2, m3, type="text", title = "OLS models of obesity rate")


#' endogeneity
#' correlation plot for choosing IV
#' occupied housing units is the IV
cor_end <- df[,c("fastfood_restaurants", "grocery_stores", "farmers_mrkt", "super_center",
                 "conv_stores", "specalized_strs", "occupied_housing_units", "obesity_rate",
                  "poverty_rate","pct_lacess_store", "recreation_fac", "natural_amenity")]
cor_df = cor(cor_end[sapply(cor_end, is.numeric)])
corrplot(cor_df)


# 2SLS
# Stage 1
tsls_st1 <- lm(food_index1~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price + white  + poverty_rate 
               + metro_county + Bachelorsorhigher + occupied_housing_units, data = df)
foodindex_f1 <- fitted(tsls_st1)
# Stage 2
en_tsls1 <- lm(obesity_rate ~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price + white  + poverty_rate 
               + metro_county + Bachelorsorhigher + foodindex_f1, data = df)
stargazer(m1,en_tsls1, type="text", title = "Food Index 2: OLS and 2SLS")

# 2SLS
# Stage 1
tsls_st2 <- lm(food_index2~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price + white  + poverty_rate 
               + metro_county + Bachelorsorhigher + occupied_housing_units, data = df)
foodindex_f2 <- fitted(tsls_st2)
# Stage 2
en_tsls2 <- lm(obesity_rate ~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price + white  + poverty_rate 
           + metro_county + Bachelorsorhigher + foodindex_f2, data = df)
stargazer(m2,en_tsls2, type="text", title = "Food Index 2: OLS and 2SLS")

# 2SLS
# Stage 1
tsls_st3 <- lm(food_index3~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price + white  + poverty_rate 
               + metro_county + Bachelorsorhigher + occupied_housing_units, data = df)
foodindex_f3 <- fitted(tsls_st3)
# Stage 2
en_tsls3 <- lm(obesity_rate ~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price + white  + poverty_rate 
               + metro_county + Bachelorsorhigher + foodindex_f3, data = df)
stargazer(m3,en_tsls3, type="text")

stargazer(en_tsls1, en_tsls2, en_tsls3, type = "text")
rm(m1,m2,m3)
rm(en_tsls1, en_tsls2, en_tsls3)
rm(tsls_st1,tsls_st2,tsls_st3)

# Hausman test for tranditional food_index1
coef_diff <- coef(en_tsls1) - coef(m1)
vcov_diff <- vcov(en_tsls1) - vcov(m1)
x2_diff <- as.vector(t(coef_diff) %*% solve(vcov_diff) %*% coef_diff)
pchisq(x2_diff, df =2, lower.tail = FALSE) 
# 0.006761271 < 0.05 Reject Null hypothesis : We have endogeneity in the OLS Model

# Hasuman test for expanded food_index2
coef_diff <- coef(en_tsls2) - coef(m2)
vcov_diff <- vcov(en_tsls2) - vcov(m2)
x2_diff <- as.vector(t(coef_diff) %*% solve(vcov_diff) %*% coef_diff)
pchisq(x2_diff, df =2, lower.tail = FALSE)
# 0.00583943 < 0.05 Reject Null hypothesis : We have endogeneity in the OLS Model 

# Hasuman test for expanded food_index3
coef_diff <- coef(en_tsls3) - coef(m3)
vcov_diff <- vcov(en_tsls3) - vcov(m3)
x2_diff <- as.vector(t(coef_diff) %*% solve(vcov_diff) %*% coef_diff)
pchisq(x2_diff, df =2, lower.tail = FALSE)
# 0.005840718 < 0.05 Reject Null hypothesis : We have endogeneity in the OLS Model


df$hawaiian <- NULL
df$asian <- NULL
df$black <- NULL
df$hisp <- NULL
df$alaska <- NULL

# Poisson Regression

# Traditional 
glm_fi1 <- glm(obesity ~ pct_lacess_store + recreation_fac + natural_amenity + milk_soda_price +
                     poverty_rate + metro_county + white + Bachelorsorhigher +
              food_index1 +offset(log(population_2010)), data = df,family = poisson(link=log))
# Expanded - 1
glm_fi2 <- glm(obesity ~ pct_lacess_store + recreation_fac + natural_amenity + milk_soda_price +
                  poverty_rate + metro_county + white + Bachelorsorhigher +
                  food_index2 +offset(log(population_2010)), data = df,family = poisson(link=log))
# Expanded - 2
glm_fi3 <- glm(obesity ~ pct_lacess_store + recreation_fac + natural_amenity + milk_soda_price +
                   poverty_rate + metro_county + white + Bachelorsorhigher +
                   food_index3 +offset(log(population_2010)), data = df,family = poisson(link=log))
stargazer(glm_fi1, glm_fi2, glm_fi3, type = "text", title = "Poisson Regression")

# quasipoisson

# Traditional 
glm_qp1 <- glm(obesity ~ pct_lacess_store + recreation_fac + natural_amenity + milk_soda_price +
                  poverty_rate + metro_county + white + Bachelorsorhigher +
                  food_index1 +offset(log(population_2010)), data = df,family = quasipoisson (link=log))
# Expanded - 1
glm_qp2 <- glm(obesity ~ pct_lacess_store + recreation_fac + natural_amenity + milk_soda_price +
                   poverty_rate + metro_county + white + Bachelorsorhigher +
                   food_index2 +offset(log(population_2010)), data = df,family = quasipoisson (link=log))
# Expanded - 2
glm_qp3 <- glm(obesity ~ pct_lacess_store + recreation_fac + natural_amenity + milk_soda_price +
                   poverty_rate + metro_county + white + Bachelorsorhigher +
                   food_index3 +offset(log(population_2010)), data = df,family = quasipoisson (link=log))
stargazer(glm_qp1, glm_qp2, glm_qp3, type = "text", title = "Poisson Regression")

stargazer(glm_fi2, glm_qp2, type = "text", title = "Food Index 2: Poisson and QuasiPoisson")
df_giniindex1 = subset(df, df$giniindex < 0.43)
df_giniindex2 = subset(df, df$giniindex > 0.43)

# Gini Index is greater than 0.45
# stage 1
st1_gini1 <- lm(food_index1~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price + white  + poverty_rate 
               + metro_county + Bachelorsorhigher + occupied_housing_units, data = df_giniindex1)
foodindex_hat <- fitted(st1_gini1)
# Stage 2
st2_gini1 <- lm(obesity_rate ~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price + white  + poverty_rate 
               + metro_county + Bachelorsorhigher + foodindex_hat, data = df_giniindex1)
summary(st2_gini1)

# Gini Index is less than 0.45
# stage 1
st1_gini2 <- lm(food_index1~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price + white  + poverty_rate 
                + metro_county + Bachelorsorhigher + occupied_housing_units, data = df_giniindex2)
foodindex_hat <- fitted(st1_gini2)
# Stage 2
st2_gini2 <- lm(obesity_rate ~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price + white  + poverty_rate 
                + metro_county + Bachelorsorhigher + foodindex_hat, data = df_giniindex2)
summary(st2_gini2)

stargazer(st2_gini1,st2_gini2, type = "text", title = "Models based on Income Inequality")

df$commute_vehicle = df$onlycar + df$public.transportation
df_transport1 = subset(df, df$commute_vehicle < 82)
df_transport2 = subset(df, df$commute_vehicle > 82)

# commute by public transportation and car < 80
# stage 1
st1_t1 <- lm(food_index2~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price + white  + poverty_rate 
                + metro_county + Bachelorsorhigher + occupied_housing_units, data = df_transport1)
foodindex_hat <- fitted(st1_t1)
# Stage 2
st2_t1 <- lm(obesity_rate ~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price + white  + poverty_rate 
                + metro_county + Bachelorsorhigher + foodindex_hat, data = df_transport1)

# Gini Index is less than 0.45
# stage 1
st1_t2 <- lm(food_index2~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price + white  + poverty_rate 
                + metro_county + Bachelorsorhigher + occupied_housing_units, data = df_transport2)
foodindex_hat <- fitted(st1_t2)
# Stage 2
st2_t2 <- lm(obesity_rate ~ pct_lacess_store + recreation_fac*natural_amenity + milk_soda_price + white  + poverty_rate 
                + metro_county + Bachelorsorhigher + foodindex_hat, data = df_transport2)
stargazer(st2_t1,st2_t2, type = "text", title = "Models based on transportation")


