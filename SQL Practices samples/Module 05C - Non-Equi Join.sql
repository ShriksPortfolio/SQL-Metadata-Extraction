	
-- DEMO 1 - USE A SELF (NON-EQUI) JOIN to return a row number for each row in SalesOrderHeader.
-- If you add more columns here like CustomerID and so on this can get more complex and perform 
-- significantly worse than it already does.
	USE AdventureWorks2016;

	SET STATISTICS IO ON

	SELECT soh.CustomerID, soh.SalesOrderID, COUNT(*) RN
	FROM	[Sales].[SalesOrderHeader] SOH
	JOIN	[Sales].[SalesOrderHeader] SOH2
	ON		soh.SalesOrderID >= soh2.SalesOrderID
	GROUP BY soh.CustomerID, soh.SalesOrderID 	
	ORDER BY soh.SalesOrderID

-- DEMO 1A -- Explain how this works.
-- 43659 is >= only 1 record which is 43659 so it will receive a row number value of 1 and so on.

	SELECT SalesOrderID FROM Sales.SalesOrderHeader ORDER BY SalesOrderID

-- DEMO 2 -- DEMO An easier method using Window Functions.
-- ALTERNATIVE METHOD
	SELECT CustomerID, SalesOrderID, ROW_NUMBER() OVER (ORDER BY SalesOrderID) RN
	FROM [Sales].[SalesOrderHeader] soh
	ORDER BY SalesOrderID
