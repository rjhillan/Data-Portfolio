# A Recency, Frequency and Monetary (RFM) Analysis can allow you quantitavely rank your customers.
# It's a great way of finding specific customers you may want to target with tailored marketing campaigns.

# For example, you may want to find a customer from a specific time frame (Recency), or the most frequent customer (Frequency), or even the highest paying customer (Monetary).
# You can even combine the three to find very specific customers, or groups of customers, who may benefit from your latest marketing campaign.

# Let's say that you are a Saas B2C company developing a new product. 
# It's a more expensive product than usual, so it would only be relevant to your highest spenders.
# Using the 'AdventureWorksDW2017' data, speficially the "FactInternetSales" dataset, we can demonstrate the above.

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

  


