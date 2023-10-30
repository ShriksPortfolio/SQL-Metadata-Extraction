
-- DEMO 1
-- Return the "last order" per Customer and also return additional info about the Sales Order.
-- What happens with the correlated Subquery method if a customer has two transactions on 
-- one order date and that's the same order date? We would need a tiebreaker, how do we now
-- introduce a tiebreaker? We need an additional correlated subquery.
-- Run both queries with statistics on to show number of scans and CPU time.

SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT CustomerID, OrderDate, SalesOrderID, SalesPersonID, TerritoryID
FROM Sales.SalesOrderHeader	SOH1
WHERE OrderDate =
	(SELECT MAX(OrderDate)
	 FROM Sales.SalesorderHeader SOH2
	 WHERE SOH1.CustomerID = SOH2.CustomerID)
AND SalesOrderID = 
	(SELECT MAX(SalesOrderID)
	 FROM Sales.SalesOrderHeader SOH3
	 WHERE soh3.CustomerID = soh1.CustomerID AND
		   soh3.OrderDate = soh1.OrderDate)


-- OPTIONAL Demo 
-- The query below was used in the Window Functions module to compare performance.
-- in that section we saw that the Window Functions were better for performance than 
-- the correlated subquery method.

-- CORRELATED SUBQUERY - Running Total
SELECT CustomerID, SalesOrderID, OrderDate, TotalDue,
		(SELECT SUM(TotalDue)
		FROM Sales.SalesOrderHeader
		WHERE CustomerID = a.CustomerID AND SalesOrderID <= a.SalesOrderID) AS RunningTotal
FROM Sales.SalesOrderHeader a;