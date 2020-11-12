# Food-Environment-Effect-On-Obesity

The obesity epidemic is affecting wealthy and poor countries alike. It's a complex and expensive health problem that needs to be tackled with collective effort. Everybody knows about human risk factors such as diet, physical activity, inactivity, drug use, and genetics. Many key factors in our society include education, skills, food marketing, affordability of healthy foods, physical activity, and food environment.

The food environment plays a major and frequently dominant role in nutrition choice, eating habits, and eventually energy intake. Through this project, we analyze the impact of food environments on adult obesity rates to give the county officials some actionable insights.

We merged sociodemographic, restaurants, food stores, and obesity data from the Food Environment Atlas - United States Department of Agriculture (USDA) and the US Census American Community Survey for all the US counties in the year 2010. We used Ordinary Least Square (OLS) regression to understand the cause and effect.

Our results suggest that active lifestyle, healthier food environment and choices are significant in controlling obesity.

## 1.	Data Source and Preparation 

We used 2010 data from USDA (United States Department of Agriculture, Economic Research Service) Food Atlas. It is a public dataset containing data for 3143 US counties. It has 275 indicators from different segments like Health, Insecurity, local, restaurants, stores, socio-economic data of each county. We also had the Supplemental data like population, meal programs in the USDA dataset. The data was in the form of a single excel file with data sorted in multiple sheets as per the category. 

After carefully understanding each attribute, we shortlisted 40 attributes for our analysis. We merged all the different sheets data by looping through each sheet and selecting the needed attributes using state and county as the primary key. We dropped all the NULL values. We started with a correlation plot and found out that few of the attributes were highly correlated (e.g. grocery stores, supermarkets, recreation facilities). To handle the multicollinearity problem, we converted the relevant attributes to per 1000 population attributes. For example, instead of total grocery stores in a county, we took grocery stores per 1000 population as our attribute. In the end, we were left with 25 attributes.

From the US census bureau, we extracted the county-level data of education attainment and the commuting preferences for residents and merged it with our existing data.

## 2. Variable Choice

We started with initial assumptions and used data to validate these assumptions. The variables we have decided are the economic factors, food availability, stores, education, public services and recreation facilities:

<img src="https://github.com/netisheth/Food-Environment-Effect-On-Obesity/blob/master/pictures/1.jpg" alt="alt text" width="75%" height="75%">

## 3. Exploratory Data Analysis

<img src="https://github.com/netisheth/Food-Environment-Effect-On-Obesity/blob/master/pictures/2.png" alt="alt text" width="80%" height="80%">

Our dependent variable is obesity rate. We can observe from the map above that all states have more than 20% of adults with obesity. The South - East part of the US has more prevalence than the other regions. In at least 12 states, prevalence of obesity was greater than 32%. Colorado has the least obesity rate and Alabama has the highest. 

<img src="https://github.com/netisheth/Food-Environment-Effect-On-Obesity/blob/master/pictures/3.png" alt="alt text" width="50%" height="50%">

The distribution of adult obesity rate is normal and has less spread. The obesity rate ranges from 13.10% to 47.9% with a mean of 30.57%. This suggests that on average, the prevalence of obesity in the United States is 30.57%. 1 out of 3 adults, were found to be obese in 2010.

<img src="https://github.com/netisheth/Food-Environment-Effect-On-Obesity/blob/master/pictures/4.png" alt="alt text" width="50%" height="50%">

From the correlation plot of all the attributes, we can observe that all the attributes are not highly correlated with a few exceptions. The obesity rate is negatively correlated with % of bachelors, natural amenity, recreation facilities per 100, and full-service restaurants per 100 suggesting that these attributes can help lower obesity. The obesity rate is positively correlated with poverty rate which is expected. 

<img src="https://github.com/netisheth/Food-Environment-Effect-On-Obesity/blob/master/pictures/5.png" alt="alt text" width="50%" height="50%">

A higher poverty rate signifies that more people will have lesser means to healthier food and lifestyle, in turn, increases the risk of obesity. From the scatterplot, we can observe the same relationship - obesity increases with poverty.

<img src="https://github.com/netisheth/Food-Environment-Effect-On-Obesity/blob/master/pictures/6.png" alt="alt text" width="50%" height="50%">

Education can increase awareness about the importance of high nutrition diets and the obesity epidemic and prevention. From the scatter plot, we can observe that an increase in the percentage of bachelors, reduces obesity.

<img src="https://github.com/netisheth/Food-Environment-Effect-On-Obesity/blob/master/pictures/7.png" alt="alt text" width="50%" height="50%">

The scatter plot suggests that having more full-service restaurants does not increase obesity. This can be because they have a more balanced and healthier menu. To control obesity, we don’t have to stop eating out. We just have to find healthier alternatives. 

## 4. Statistical Models

The dependent variable obesity rate has a normal distribution, so we implemented a multiple linear regression model to understand the effect of the various factors such as food environment, socio-economic, accessibility, health, and wellness activities on the obesity rate.

Model 1 is the “main effects” model and initial model that explains the effect of individual independent variables on obesity. 

Model 2 considers independent variables that a county administrator can control or take necessary actions to reduce the obesity rate in the county. 

Model 3 contains interactions of the individual variables and explains the collective effect of those interacted variables on the obesity rate.

Among the 3 models. Model 3 is our final model as the coefficients of the estimates are more closely aligned with the real world and the interaction terms provide more explanation on the obesity rate variation across counties. 

<img src="https://github.com/netisheth/Food-Environment-Effect-On-Obesity/blob/master/pictures/8.jpg" alt="alt text" width="65%" height="65%">

#### Understanding Model 3

**Low Accessibility:**
- If the percentage of the population with low income and low access is increased by 1% then obesity will be increased by 0.003% which is almost 0% - no effect as the standard error is 0.008. 
-	With a 1% increase in population of people in the county with low income and low access to stores, the effect of the additional 1 unit of the grocery stores for 1000 population on obesity decreases by 0.016%.

**Healthy food affordability:** 
-	With every 1% increase in the price of healthy food products (low-fat milk) relative to the unhealthy food products (soda), obesity will increase by 3.45%. With a very low value of standard error (0.49) the attribute is statistically significant.

**Recreation and Fitness Centers:**
-	1 unit increase in the number of recreational centers per 1000 population, reduces obesity by 3.39%. Also, with just 0.6 of standard error, this attribute is statistically significant and has a large coefficient.

**Restaurants:**
-	If the number of fast food restaurants per 1000 population increases by 1, obesity will increase by 0.12%. 
-	If the number of full-service restaurants per 1000 population increases by 1, obesity will reduce by 1.18% which specifies that full-service restaurants serve healthy food. With coefficient of -1.155 and St. Error (0.1), the attribute is statistically significant and highly relevant is vital in modeling
-	As fast-food restaurants per 1000 population increases by 1, 
  -- the effect of the additional 1 unit of the specialized store for 1000 population on obesity increases by 1.9%
  -- the effect of the additional 1 unit of the recreational facilities for 1000 population on obesity rate increases by 0.2%.

**Stores:**
-	The number of grocery stores per 1000 population has a positive impact on the obesity rate. For an increase in each unit of grocery stores the obesity increases by 0.49% but has high 0.53 it is not a statistically significant attribute and can be ignored.
-	For an increase in each supercenter & club store for 1000 population, the obesity will increase by 9.7%. This effect can be because they offer great discounts on bulk packs of unhealthy food items (like chips and soda) in addition to offering healthy food items like fruits and vegetables. 
-	For an increase in each specialized store for 1000 population the obesity will be reduced by 1.35%.
-	Farmer’s market which sells fresh fruits and vegetables makes healthier food available to people.  We expect this field to reduce the obesity but the coefficient here represents that for an increase in every unit of farmer’s market per 1000 population increases the obesity rate by 2%.

**Socio-demographic:**
-	An increase of 1% of the poverty rate of the county, increases obesity by 0.12%.
-	For every 1% increase in the percentage of the people who commute to work by walking will reduce the obesity of the county by 0.06%.
-	For an increase in every unit percentage of the population with a bachelor's degree or higher in the county, the obesity reduces by 0.19%
-	For a 1% increase in the county population that uses public transportation for commuting to work, obesity decreases by 0.12%.

## 5. Quality Checks

As we have implemented Linear regression, we have primarily checked for four basic assumptions:

1.	The dependent and independent attributes have linear relation: In the residual vs Fitted, the passing of the red line along the horizon and no clear pattern of the points suggests that the model is linear. 

<img src="https://github.com/netisheth/Food-Environment-Effect-On-Obesity/blob/master/pictures/9.png" alt="alt text" width="65%" height="65%">

2.	Independence test: This assumption is not applicable to the data as each county’s data is independent to other counties. The Durbin-Watson test reveals that the model suffers from autocorrelation. 

<img src="https://github.com/netisheth/Food-Environment-Effect-On-Obesity/blob/master/pictures/10.png" alt="alt text" width="65%" height="65%">

3.	 Normality - This assumption states that the residuals should confine to normal distribution. From the QQ plot it is relevant that most of the residuals are normally distributed with exception of few extreme points.

<img src="https://github.com/netisheth/Food-Environment-Effect-On-Obesity/blob/master/pictures/11.png" alt="alt text" width="65%" height="65%">

4.	Residuals have constant variance - In an ideal case, the residuals should have equal variance across all the points (Homoscedasticity). But, the Breusch-Pagan test shows that there is Heteroscedasticity in the residuals.

<img src="https://github.com/netisheth/Food-Environment-Effect-On-Obesity/blob/master/pictures/12.png" alt="alt text" width="65%" height="65%">

## 6. Insights

-	Recreational facilities promote healthy and active living and can help to reduce obesity. 1% increase will reduce obesity by 3.39%.
-	Full-service restaurants are a healthier alternative to fast food restaurants as they provide well-cooked nutritious, low-calorie healthy food.
-	The affordability of healthy food items has a great impact on controlling obesity. If the prices are 1% less expensive compared to unhealthy products like soda, obesity will reduce by 3.45%. 
-	Specialized food stores like retail bakeries, meat and seafood markets, dairy stores, and produce markets are popular and often visited by people. Obesity can be reduced by 1.35%, if the number of specialized stores per 1000 population increase by 1. 
-	Even though grocery stores and farmers markets sell healthy food items, they don’t help to reduce obesity. 
-	Though low accessibility to stores is a hurdle for having access to healthy food, it does not have any effect on obesity. 
-	If more people travel to work by public transportation, obesity can be controlled. 1% increase can reduce obesity by 0.12%.
-	Education helps to create more awareness about the importance of healthy and active living and can help to reduce obesity. A 1% increase in bachelor graduates, can reduce obesity by 0.19%.

## 7. Recommendations to County Officials to reduce obesity

-	Make healthy food products more affordable with the help of food assistance programs like SNAP(S) (Supplemental Nutrition Assistance Program). Increase of taxes on unhealthy products and subsidies for healthy ones can also help.
-	Open more recreational facilities for every 1000 population to promote active living.
-	Open more healthy food outlets like full-service restaurants and specialized stores (retail bakeries, meat and seafood markets, dairy stores, and produce markets) for every 1000 population.
-	Control the number of supermarkets and club stores per 1000 population. They make food products like soda, instant and processed food, more convenient and readily available. It increases obesity risk.
