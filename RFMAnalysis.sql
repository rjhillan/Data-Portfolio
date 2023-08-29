# A Recency, Frequency and Monetary (RFM) Analysis can allow you quantitavely rank your customers.
# It's a great way of finding specific customers you may want to target with tailored marketing campaigns.

# For example, you may want to find a customer from a specific time frame (Recency), or the most frequent customer (Frequency), or even the highest paying customer (Monetary).
# The RFM Analysis will allow you to rank customers on the above themes
  # Then, you can give each customer a ranking, from 1 - 10 (low - high), for each of the three themes
  # e.g. Recency - 8, Frquency - 7, Monetary - 3 - they have bought recently, at a high frequency, but spent little money
  
  # You can use this analysis specific customers, or groups of customers, who may benefit from your latest marketing campaign.

# Let's say that you are a Saas B2C company developing a new product. 
# It's a more expensive product than usual, so it would only be relevant to your highest spenders.
# Using the 'AdventureWorksDW2017' data, speficially the "FactInternetSales" dataset, we can demonstrate the RFM Analysis.

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

# You can see the customer IDs of the top ten spending customers in the left hand column.
  # Now we have a general table of the RFM columns, we can demonstrate the RFM ranking process
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
