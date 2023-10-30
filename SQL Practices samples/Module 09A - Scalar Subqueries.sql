
-- DEMO 1 - SUBQUERY IN SELECT LIST
USE AdventureWorks2016;

SELECT SalesOrderID, SalesOrderDetailID, LineTotal,
		(SELECT SUM(LineTotal)
		 FROM Sales.SalesOrderDetail AS Total)			-- returns only 1 value for all rows
FROM Sales.SalesOrderDetail sod;

-- DEMO 2 - Subquery in WHERE Clause.
-- SHOW SUBQUERY IN WHERE Clause.
-- This example will fail because the subquery returns multiple results.
-- Self Contained subqueries are easier to troubleshoot. -- Run the query independently.
SELECT SalesOrderID, SalesOrderDetailID, LineTotal,
	(SELECT SUM(LineTotal)
	 FROM Sales.SalesOrderDetail AS Total) TotalSales 
FROM Sales.SalesOrderDetail sod
WHERE SalesOrderID = (SELECT SalesOrderID 
					  FROM Sales.SalesOrderDetail 
					  WHERE UnitPrice = '2024.994')   -- Returns Multiple Values

-- DEMO 3 - TOP 
-- USE TOP CLAUSE TO LIMIT THE RESULT SET.
-- MAX/MIN AND OTHER EXAMPLES COULD HAVE BEEN USED HERE AS WELL AS PASSING IN A PARAMETER.

SELECT SalesOrderID, SalesOrderDetailID, LineTotal,
	(SELECT SUM(LineTotal)
	 FROM Sales.SalesOrderDetail AS Total) TotalSales 
FROM Sales.SalesOrderDetail sod
WHERE SalesOrderID = (SELECT TOP (1) SalesOrderID 
					  FROM Sales.SalesOrderDetail 
					  WHERE UnitPrice = '2024.994')		-- Returns a single value now.