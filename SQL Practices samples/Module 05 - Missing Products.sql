/*
	DEMO 1 - In this example we return all products that have never been sold via FactInternet Sales.
	DEMO 2 - Example from Module 4 for performance comparison.
*/
SET STATISTICS TIME ON
SET STATISTICS IO ON 

-- DEMO 1 - LEFT OUTER JOIN
	-- Uses Hash Match operator for Join.
	-- Much lower CPU Time and Logical scans than the next, set based method.

USE AdventureWorksDW2016;

SELECT	DC.ProductKey, fis.CustomerKey
FROM	DimProduct DC
LEFT JOIN FactInternetSales FIS
ON	DC.ProductKey = FIS.ProductKey
WHERE	FIS.CustomerKey IS NULL


-- ALTERNATIVE (Shown in Module 04)
-- Extremely High Logical scan count and CPU Time.
-- Nested Loop is used in the Execution Plan
SELECT ProductKey
FROM DimProduct
	EXCEPT
SELECT ProductKey
FROM FactInternetSales


