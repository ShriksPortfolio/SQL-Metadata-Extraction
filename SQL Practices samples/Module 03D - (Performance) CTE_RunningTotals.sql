/*
	===== PERFORMANCE TUNING =====

	1) Show how to get running totals using WINDOW Function.
	2) Show how to get running totals using correlated subquery.
	3) Show how to get running totals using Self join

	Purpose:
		Demo that in this example window function is the cleanest/easiest code to write and
		also the best performing.

*/

USE AdventureWorks2016;

SET STATISTICS IO ON

-- Running Total
SELECT CustomerId, SalesOrderID, OrderDate, TotalDue,
	SUM(TotalDue) 
	OVER(PARTITION BY CustomerID ORDER By SalesOrderID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal	--  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
FROM	Sales.SalesOrderHeader;

-- CORRELATED SUBQUERY - Running Total Comparison
-- Do not explain the code here, we will explain these examples again in their related sections.
SELECT CustomerID, SalesOrderID, OrderDate, TotalDue,
		(SELECT SUM(TotalDue)
		FROM Sales.SalesOrderHeader
		WHERE CustomerID = a.CustomerID AND SalesOrderID <= a.SalesOrderID) AS RunningTotal
FROM Sales.SalesOrderHeader a;

-- SELF JOIN
-- Do not explain the code here, we will explain these examples again in their related sections.
SELECT a.CustomerID, a.SalesOrderID, a.OrderDate, a.TotalDue,
	SUM(b.TotalDue) AS RunningTotal
FROM Sales.SalesOrderHeader a
JOIN Sales.SalesOrderHeader b 
	on a.CustomerID = b.CustomerID AND
	   a.SalesOrderID >= b.SalesOrderID
GROUP BY a.CustomerID, a.SalesOrderID, a.OrderDate, a.TotalDue
ORDER BY CustomerID, SalesOrderID;