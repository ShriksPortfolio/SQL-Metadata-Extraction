-- DEMO 1 - MULTI-VALUED query in the WHERE clause using the IN clause
USE AdventureWorks2016;

SELECT SalesOrderID, SalesOrderDetailID, LineTotal,
		(SELECT SUM(LineTotal)
		 FROM Sales.SalesOrderDetail AS Total)			-- returns only 1 value
FROM Sales.SalesOrderDetail sod
WHERE ProductID IN
		(    
			 SELECT ProductID
			 FROM Production.Product prd
			 JOIN Production.ProductSubcategory prc
			 ON prc.ProductSubcategoryID = prd.ProductSubcategoryID
			 WHERE prc.name = 'Mountain Bikes'
		)

-- Alternative Method
-- Example from Module 4.... sets
USE AdventureworksDW2016;

SELECT * FROM DimProduct
WHERE ProductKey NOT IN 
	(
		SELECT ProductKey
		FROM FactInternetSales
	)