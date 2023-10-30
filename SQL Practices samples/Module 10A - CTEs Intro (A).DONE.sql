USE AdventureWorks2016;
GO

-- ALIASING COLUMNS
SELECT 
	LEFT(SalesOrderID,2) +	RIGHT(SalesOrderID,2)	AS SalesOrderID, 
	RIGHT(SalesOrderNumber, 4)						AS SalesNumber,
	YEAR(OrderDate)									AS OrderYear,
	REPLACE(PurchaseOrderNumber, 'PO', '')			AS PONumber,
	SUM(TotalDue)									AS TotalDue
FROM Sales.SalesOrderHeader 
GROUP BY
	 LEFT(SalesOrderID,2) +	RIGHT(SalesOrderID,2)	
	,RIGHT(SalesOrderNumber, 4)						
	,YEAR(OrderDate)									
	,REPLACE(PurchaseOrderNumber, 'PO', '')
	
-- This demo shows inline column aliasing. 
-- Also show how to externally perform column aliasing.
;WITH Module10Demo --(SalesOrderID, SalesNumber, OrderYear, PONumber, TotalDue) -- External Aliasing
AS
(
SELECT 
	LEFT(SalesOrderID,2) +	RIGHT(SalesOrderID,2)	AS SalesOrderID, 
	RIGHT(SalesOrderNumber, 4)						AS SalesNumber,
	YEAR(OrderDate)									AS OrderYear,
	REPLACE(PurchaseOrderNumber, 'PO', '')			AS PONumber,
	TotalDue										AS TotalDue
FROM Sales.SalesOrderHeader
)
SELECT SalesOrderID, SalesNumber, OrderYear, PONumber, SUM(TotalDue) TotalDue
FROM Module10Demo
GROUP BY SalesOrderID, SalesNumber, OrderYear, PONumber

-- Return first three orders per customer
-- ROW NUMBER FUNCTION IN A WHERE CLAUSE.
;WITH SalesByCustomer AS
(
	SELECT CustomerID, SalesOrderID, OrderDate, TotalDue,
			ROW_NUMBER() OVER (Partition By CustomerID ORDER BY SalesOrderID) RN -- DESC vs. ASC vs. Order by ORDERDATE
	 FROM Sales.SalesOrderHeader soh
)
SELECT CustomerID, SalesOrderID, OrderDate
FROM SalesByCustomer
WHERE RN <= 3


