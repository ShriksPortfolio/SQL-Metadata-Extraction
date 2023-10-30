
-- RETURNS TOP 3 ORDERS PER CUSTOMER. This solves a more complex problem that is explained more in the
-- In the video I show how to just join to a Table Expression but this table expression could have been stored
-- using the following function.

USE AdventureWorks2016;
GO

IF OBJECT_ID ('dbo.Top3Orders') IS NOT NULL 
DROP FUNCTION dbo.Top3Orders;
GO

CREATE FUNCTION dbo.Top3Orders (@CustomerID int)
RETURNS TABLE
AS
RETURN
(
	SELECT TOP(3) CustomerID, SalesOrderID, OrderDate
		 FROM Sales.SalesOrderHeader 
		 WHERE CustomerID = @CustomerID
	UNION ALL
	SELECT TOP(1) CustomerID, SalesOrderID, OrderDate
	FROM  Sales.SalesOrderHeader 
	ORDER BY SalesOrderID DESC
	)
GO

SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT cus.CustomerID, SalesOrderID, OrderDate
FROM Sales.Customer cus
	CROSS APPLY
		dbo.Top3Orders (cus.CustomerID)
-- WHERE cus.CustomerID = 11000