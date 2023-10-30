/*
	===== PERFORMANCE TUNING =====

	1) Show how to get totals using WINDOW Function.
	2) Show how to get totals using CTE Method.
	3) Show how to get totals using correlated subquery.

	Purpose:
		Generally window functions will yield the best performance but in this example RANGE the
		default frame delimiter is used and therefore work is done on Disk. CTEs will perform the 
		best because the work will be done in memory.

*/

USE AdventureWorks2016;

SET STATISTICS IO ON
SET STATISTICS TIME ON

-- WINDOW AGGREGATE FUNCTION Method
-- What happens to performance when I add additional aggregates?
-- Impact is minimal as long as I am using the same Over Clause (Same window)
SELECT
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	SUM(LineTotal) OVER(Partition By SalesOrderID) AS TransactionTotal
	--,MIN(LineTotal) OVER(Partition By SalesOrderID) MinTotal
	--,MAX(LineTotal) OVER(Partition By SalesOrderID)MaxTotal
FROM	
	Sales.SalesOrderDetail

-- CTE Method
-- Do not explain the code here, we will explain these examples again in their related sections.
-- 2) How is performance affected if we add additional aggregates?

;WITH TOTALS AS
(
	SELECT SalesOrderID, SUM(LineTotal) AS Total-- , MIN(LineTotal) MinTotal, MAX(LineTotal) MaxTotal
	FROM Sales.SalesOrderDetail
	GROUP BY SalesOrderID
)
SELECT soh.SalesOrderDetailID, soh.SalesOrderID, soh.LineTotal, t.Total
FROM Sales.SalesOrderDetail soh
JOIN Totals t
	ON t.SalesOrderID = soh.SalesOrderID

-- WHAT ABOUT ALL SALES WITH CTE?
-- 1) WE COULD JUST REMOVE THE GROUP BY IN THE CTE, BUT NOW WE GET AN ERROR. 

;WITH TOTALS AS
(
	SELECT SalesOrderID, SUM(LineTotal) AS Total 
	FROM Sales.SalesOrderDetail
	GROUP BY SalesOrderID
)
SELECT soh.SalesOrderDetailID, soh.SalesOrderID, soh.LineTotal, t.Total
FROM Sales.SalesOrderDetail soh
JOIN Totals t
	ON t.SalesOrderID = soh.SalesOrderID

-- 2) WE COULD JUST USE CROSS APPLY
-- REMOVE SalesOrderID from the select and remove the Group by in the CTE
-- REPLACE THE JOIN WITH CROSS APPLY AND REMOVE THE ON CONDITION.

;WITH TOTALS AS
(
	SELECT SUM(LineTotal) AS Total
	FROM Sales.SalesOrderDetail
)
SELECT soh.SalesOrderDetailID, soh.SalesOrderID, soh.LineTotal, t.Total
FROM Sales.SalesOrderDetail soh
CROSS APPLY Totals t

-- Correlated sub-query 
-- Do not explain the code here, we will explain these examples again in their related sections.
-- DEMO 1 - This will return the value per SalesOrderID.
-- DEMO 1B - Performance will go down as additional aggregations are added here. Table will need to be scanned additional times
-- proportionate to the number of aggregates added.

SELECT SalesOrderID, SalesOrderDetailID, LineTotal,
	(SELECT SUM(LineTotal)
	FROM Sales.SalesOrderDetail
	WHERE SalesOrderID = sod.SalesOrderID)	AS Total
	,(SELECT MAX(LineTotal)
	FROM Sales.SalesOrderDetail
	WHERE SalesOrderID = sod.SalesOrderID)	AS MinTotal
	,(SELECT MIN(LineTotal)
	FROM Sales.SalesOrderDetail
	WHERE SalesOrderID = sod.SalesOrderID)	AS MaxTotal
FROM Sales.SalesOrderDetail sod;

-- Sub-query - DEMO 2
-- Return total for all sales

SELECT SalesOrderID, SalesOrderDetailID, LineTotal,
	(SELECT SUM(LineTotal)
	 FROM Sales.SalesOrderDetail AS Total)
FROM Sales.SalesOrderDetail sod;


