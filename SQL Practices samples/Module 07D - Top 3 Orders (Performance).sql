/*
	RETRIEVE THE LAST 3 ORDERS PER CUSTOMER
*/

-- SHOW CUSTOMER

USE AdventureWorks2016;

SELECT 
	*
FROM Sales.SalesOrderHeader

-- TOP 1 ORDER PER CUSTOMER
SELECT TOP(1) CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader


-- RETURN THE LAST ORDER PER CUSTOMER (Correlated Subquery)
-- Take a look at the number of Logical Scans and Scan Count
-- Take a look at the Execution Plan and no index on SalesorderHeader.
-- 1 seek is occurring per order not customer.
SET STATISTICS IO ON
SET STATISTICS TIME ON

-- 19,820 customers in Sales.Customer
-- 31,465 records in Sales.SalesOrderHeader table
-- 19,119 distinct customers in Sales.SalesOrderHeader table

-- Scan count 31470, logical reads 67193,
-- CPU time = 251 ms,  elapsed time = 373 ms.

SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader soh
WHERE SalesOrderID = 
	(SELECT TOP(1) SalesOrderID
	 FROM Sales.SalesOrderHeader SOH2
	 WHERE soh.CustomerID = soh2.CustomerID
	 ORDER BY SalesOrderID desc)			

-- TOP 3 ORDERS PER CUSTOMER
-- Performance is about the same here.
SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader soh
WHERE SalesOrderID IN 
	(SELECT TOP(3) SalesOrderID
	 FROM Sales.SalesOrderHeader SOH2
	 WHERE soh.CustomerID = soh2.CustomerID
	 ORDER BY SalesOrderID desc)			


-- The performance here is better but you can't do top 3 or top 5 orders here because
-- we are using a scalar subquery.
SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT soh2.CustomerID, soh2.SalesOrderID, OrderDate
FROM (SELECT CustomerID ,
			 (SELECT TOP(1) SalesOrderID
			  FROM Sales.SalesOrderHeader soh
			  WHERE soh.CustomerID = cus.CustomerID) AS SalesOrderID
	  FROM Sales.Customer cus) AS X
JOIN Sales.SalesOrderHeader soh2
ON soh2.SalesOrderID = x.SalesOrderID

-- USING APPLY OPERATOR FOR PERFORMANCE
SELECT 
	cus.CustomerID, soh.SalesOrderID, soh.OrderDate
FROM Sales.Customer cus
CROSS APPLY
	(SELECT TOP(3) CustomerID, SalesOrderID, OrderDate
	 FROM Sales.SalesOrderHeader SOH
	 WHERE cus.CustomerID = soh.CustomerID
	 ORDER BY SalesOrderID DESC) soh
--ORDER BY CustomerID;

-- ROW NUMBER
SELECT CustomerID, SalesOrderID, OrderDate
FROM 
	(SELECT CustomerID, SalesOrderID, OrderDate,
			ROW_NUMBER() OVER (Partition By CustomerID ORDER BY SalesOrderID) RN -- DESC vs. ASC vs. Order by ORDERDATE
	 FROM Sales.SalesOrderHeader soh) AS X
WHERE
	RN <= 3



