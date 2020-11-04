# Food-Environment-Effect-On-Obesity

The obesity epidemic is affecting wealthy and poor countries alike. It's a complex and expensive health problem that needs to be tackled with collective effort. Everybody knows about human risk factors such as diet, physical activity, inactivity, drug use, and genetics. Many key factors in our society include education, skills, food marketing, affordability of healthy foods, physical activity, and food environment.

The food environment plays a major and frequently dominant role in nutrition choice, eating habits, and eventually energy intake. Through this project, we analyze the impact of food environments on adult obesity rates to give the county officials some actionable insights.

We merged sociodemographic, restaurants, food stores, and obesity data from the Food Environment Atlas - United States Department of Agriculture (USDA) and the US Census American Community Survey for all the US counties in the year 2010. We used Ordinary Least Square (OLS) regression to understand the cause and effect.

Our results suggest that active lifestyle, healthier food environment and choices are significant in controlling obesity.

### 1. Prior Literature 

To understand the various factors that affect obesity we have referred to many research papers. Based on our work we have found that obesity rates are higher in low-income households and minority groups. The link between where people live, and their risk of obesity led us to research the link between the food environment and health.  Low-income and racial-ethnic groups are more likely to live close to unhealthy food stores associated with poor diet than the Whites. Also, food outlets considered unhealthy (fast-food restaurants) are also more likely to be located in places with higher ethnic minority populations than whites. To capture the effect of healthy and unhealthy food outlets on obesity the food index is calculated as the ratio of unhealthy food access to healthy food access in a paper published by the US National Library of Medicine. In this study, the food environment was cited as a significant cause of the obesity epidemic. Further findings include increasing access to the stores that should be pursued along with other strategies such as improving diet quality, wellness activities. 

From an article published in PMC we found that Energy balance was also another factor that affects obesity. Ecological models of obesity refer to energy balance as a function of factors “energy in” and “energy out”. The energy out is calculated as the calories burned during physical activities and the physical activities have a negative effect on obesity.

To have a better understanding of obesity, factors and consequences we referred to the data published on CDC website, we found that genetic diseases and family history can also be factors responsible for obesity, but since the county-level data was not available we couldn’t consider these factors. 

## 2.	Data Source and Preparation 

We used 2010 data from USDA (United States Department of Agriculture, Economic Research Service) Food Atlas. It is a public dataset containing data for 3143 US counties. It has 275 indicators from different segments like Health, Insecurity, local, restaurants, stores, socio-economic data of each county. We also had the Supplemental data like population, meal programs in the USDA dataset. The data was in the form of a single excel file with data sorted in multiple sheets as per the category. 

After carefully understanding each attribute, we shortlisted 40 attributes for our analysis. We merged all the different sheets data by looping through each sheet and selecting the needed attributes using state and county as the primary key. We dropped all the NULL values. We started with a correlation plot and found out that few of the attributes were highly correlated (e.g. grocery stores, supermarkets, recreation facilities). To handle the multicollinearity problem, we converted the relevant attributes to per 1000 population attributes. For example, instead of total grocery stores in a county, we took grocery stores per 1000 population as our attribute. In the end, we were left with 25 attributes.

From the US census bureau, we extracted the county-level data of education attainment and the commuting preferences for residents and merged it with our existing data.

## 3. Variable Choice

We started with initial assumptions and used data to validate these assumptions. The variables we have decided are the economic factors, food availability, stores, education, public services and recreation facilities:

<img src="https://github.com/netisheth/Food-Environment-Effect-On-Obesity/blob/master/pictures/1.jpg" alt="alt text" width="50%" height="50%">


