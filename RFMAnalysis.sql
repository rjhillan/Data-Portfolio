# A Recency, Frequency and Monetary (RFM) Analysis can allow you quantitavely rank your customers
# It's a great way of finding specific customers you may want to target with tailored marketing campaigns

# For example, you may want to find a customer from a specific time frame (Recency), or the most frequent customer (Frequency), or even the highest paying customer (Monetary)
# The RFM Analysis will allow you to rank customers on the above themes
  # Then, you can give each customer a ranking, from 1 - 10 (low - high), for each of the three themes
  # e.g. Recency - 8, Frquency - 7, Monetary - 3 - they have bought recently, at a high frequency, but spent little money
  
  # You can use this analysis specific customers, or groups of customers, who may benefit from your latest marketing campaign

# Let's say that you are a Saas B2C company developing a new product
# It's a more expensive product than usual, so it would only be relevant to your highest spenders
# For the purpose of this exercise, we're not interested in the Recency data, so will focuse on Frequency and Monetary
  
# Using the 'AdventureWorksDW2017' data, speficially the "FactInternetSales" dataset, we can demonstrate the RFM Analysis
# (If you're unfamiliar with SQL coding, don't worry too much about the code itself, focus more so on the outputs and notes)

# This code allows us to see a specific aspect of our dataset
# Specifically, it groups together all customer orders by customer
# So in stead of one customer who made 15 orders popping up 15 times, it links all those 15 orders to that one customer
  
WITH CustomerSalesOrders AS 
(
SELECT FIS.CustomerKey,
FIS.SalesOrderNumber,
SUM(SalesAmount) AS SalesAmount
  FROM FactInternetSales FIS
  GROUP BY FIS.CustomerKey, FIS.SalesORderNumber
  )
  SELECT CSO.CustomerKey,
  COUNT(*) AS SalesAmount,
  SUM(CSO.SalesAmount) AS SalesAmount
  FROM CustomerSalesOrders CSO
  GROUP BY CSO.CustomerKey
  ORDER BY CSO.CustomerKey


# Here we can use Common Table Expressions (CTEs) to simplify the data sourcing by creating a temporary table from our large dataset
# Below you can see a CTE query that pulls some useful information for us to understand who the biggest spender in our customer base is 

WITH CustomerSalesOrders AS 
(
SELECT FIS.CustomerKey,
FIS.SalesOrderNumber,
SUM(SalesAmount) AS SalesAmount
  FROM FactInternetSales FIS
  GROUP BY FIS.CustomerKey, FIS.SalesORderNumber
  ),
 CustomerSalesOrderHistory AS
 (
SELECT CSO.CustomerKey,
COUNT(*) AS SalesOrderCount,
SUM(CSO.SalesAmount) AS SalesAmount
  FROM CustomerSalesOrders CSO
  GROUP BY CSO.CustomerKey
  )
  SELECT *
  FROM CustomerSalesOrderHistory CSOH
  ORDER BY CSOH.SalesAmount DESC
  
# output:

CustomerKey	SalesOrderCount	SalesAmount
11000	3	8248.99
11001	3	6383.88
11002	3	8114.04
11003	3	8139.29
11004	3	8196.01
11005	3	8121.33
11006	3	8119.03
11007	3	8211.00
11008	3	8106.31
11009	3	8091.33

# You can see the customer IDs of the top ten spending customers in the left hand column
  # Now we have a general table of the F ('SalesOderCount') and M ('SalesAmount') columns, we can demonstrate the RFM ranking process
  # We can use the 'NTILE' function to rank customers for RFM

    WITH CustomerSalesOrders AS 
(
SELECT FIS.CustomerKey,
FIS.SalesOrderNumber,
SUM(SalesAmount) AS SalesAmount
  FROM FactInternetSales FIS
  GROUP BY FIS.CustomerKey, FIS.SalesORderNumber
  ),
 CustomerSalesOrderHistory AS
 (
SELECT CSO.CustomerKey,
COUNT(*) AS SalesOrderCount,
SUM(CSO.SalesAmount) AS SalesAmount
  FROM CustomerSalesOrders CSO
  GROUP BY CSO.CustomerKey
  )
  SELECT CSOH.CustomerKey
  ,NTILE(10) OVER (ORDER BY CSOH.SalesOrderCount ASC) AS FrequencyScore
  ,NTILE(10) OVER (ORDER BY CSOH.SalesAmount ASC) AS MonetaryScore
  FROM CustomerSalesOrderHistory CSOH
  ORDER BY CSOH.CustomerKey

# Below is a section of the above query highlight the RFM rankings

  
  CustomerKey	FrequencyScore	MonetaryScore
11012	9	4
11013	8	5
11014	8	5
11015	1	8
11016	3	8
11017	10	10
11018	10	10
11019	10	6
11020	7	7
11021	2	8

# We can see how well each customer performs for number of purchases ('FrequencyScore') and cost of purchases ('MonetaryScore')
# Because we are looking to sell a new product which has a high price tag, we only want to target those who have made high-cost purchases
# We can see these specific customers by using the 'WHERE' function, searching only the high paying customers

  WITH CustomerSalesOrders AS 
(
SELECT FIS.CustomerKey,
FIS.SalesOrderNumber,
SUM(SalesAmount) AS SalesAmount
  FROM FactInternetSales FIS
  GROUP BY FIS.CustomerKey, FIS.SalesORderNumber
  ),
 CustomerSalesOrderHistory AS
 (
SELECT CSO.CustomerKey,
COUNT(*) AS SalesOrderCount,
SUM(CSO.SalesAmount) AS SalesAmount
  FROM CustomerSalesOrders CSO
  GROUP BY CSO.CustomerKey
  ), 
  RFM AS
  ( 
  SELECT CSOH.CustomerKey
  ,NTILE(10) OVER (ORDER BY CSOH.SalesOrderCount ASC) AS FrequencyScore
  ,NTILE(10) OVER (ORDER BY CSOH.SalesAmount ASC) AS MonetaryScore
  FROM CustomerSalesOrderHistory CSOH
)
SELECT *
FROM RFM FM
WHERE FM.FrequencyScore = 10 AND FM.MonetaryScore = 10
ORDER BY FM.CustomerKey

 - - Output:

CustomerKey	FrequencyScore	MonetaryScore
11000	10	10
11001	10	10
11002	10	10
11003	10	10
11004	10	10
11005	10	10
11006	10	10
11007	10	10
11008	10	10
11009	10	10

# Taking the top 10 customers ranked by 'CustomerKey', we can see that the data has pulled only customers with an F AND M score of 10
# These customers are more likely to be interested in and purchase your new product
# You can now create an email marketing campaign addressed to these specific users
# You can also use their broader information (role, copmany, industry, etc) to further target customers and non-customers with similar profiles

# I hope this has been a useful demonstration of the RFM analysis!
