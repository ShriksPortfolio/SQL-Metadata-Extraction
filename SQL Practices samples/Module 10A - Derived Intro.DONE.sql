
-- This first demo is the same code we used in CTE section. 
-- We put all of our code into a Derived table to make referencing the columns easier in the group by.
USE AdventureWorks2016;

SELECT SalesOrderID, SalesNumber, OrderYear, PONumber, SUM(TotalDue)
FROM(
	SELECT 
		LEFT(SalesOrderID,2) +	RIGHT(SalesOrderID,2)	AS SalesOrderID, 
		RIGHT(SalesOrderNumber, 4)						AS SalesNumber,
		YEAR(OrderDate)									AS OrderYear,
		REPLACE(PurchaseOrderNumber, 'PO', '')			AS PONumber,
		TotalDue
	FROM Sales.SalesOrderHeader) SalesOrderHeader --(SalesOrder, SalesNum, OrderYear, Number) -- EXTERNAL ALIASING
GROUP BY SalesOrderID, SalesNumber, OrderYear, PONumber

-- Return first three orders per customer
USE AdventureWorks2016;
GO

SELECT CustomerID, SalesOrderID, OrderDate
FROM 
	(SELECT CustomerID, SalesOrderID, OrderDate,
			ROW_NUMBER() OVER (Partition By CustomerID ORDER BY SalesOrderID) RN 
	 FROM Sales.SalesOrderHeader soh) AS SalesByCustomer -- Derived Table Name alias
WHERE
	RN <= 3



-- REWRITE The previous example from CTE demo to return the same results using a derived table. 
/* First write the inner table.
			(SELECT CustomerID, SalesOrderID, TotalDue,									-- I have to add SalesOrderID here, this was not necessary in the CTE.
				ROW_NUMBER() OVER (Partition By CustomerID ORDER BY SalesOrderID) RN 
			 FROM Sales.SalesOrderHeader soh) SalesByCustomer
*/

SELECT SOH.CustomerID, F3.TotalDue First3Orders, soh.SalesOrderID, soh.TotalDue
FROM (SELECT CustomerID, SUM(TotalDue) OVER (Partition By CustomerID) TotalDue, ROW_NUMBER() OVER (Partition By CustomerID ORDER BY SalesOrderID) RN
	  FROM (SELECT CustomerID, SalesOrderID, TotalDue,									-- I have to add SalesOrderID here, this was not necessary in the CTE.
				ROW_NUMBER() OVER (Partition By CustomerID ORDER BY SalesOrderID) RN 
			FROM Sales.SalesOrderHeader soh) SalesByCustomer
	 WHERE RN <= 3) F3
JOIN Sales.SalesOrderHeader SOH
ON soh.CustomerID = F3.CustomerID
WHERE RN = 1 AND F3.TotalDue > 10000
ORDER BY soh.CustomerID


-- EXECUTE at the same time as the Derived Table and show execution plans.
	;WITH SalesByCustomer AS
(
	SELECT CustomerID, TotalDue,
			ROW_NUMBER() OVER (Partition By CustomerID ORDER BY SalesOrderID) RN -- DESC vs. ASC vs. Order by ORDERDATE
	 FROM Sales.SalesOrderHeader soh
) -- SELECT * FROM SalesByCustomer
	,First_3_Sales AS
(
	SELECT 
		CustomerID, 
		SUM(TotalDue) OVER (Partition By CustomerID) TotalDue,
		ROW_NUMBER() OVER (Partition By CustomerID ORDER BY CustomerID) RN
	FROM SalesByCustomer	
	WHERE 
		RN <= 3
)
	--SELECT * FROM First_3_Sales -- Show data in CTE
SELECT soh.CustomerID, F3.TotalDue First3Orders, SalesOrderID, soh.TotalDue
FROM Sales.SalesOrderHeader SOH
JOIN First_3_Sales  F3
ON soh.CustomerID = f3.CustomerID
WHERE RN = 1 AND F3.TotalDue > 10000
	--GROUP BY soh.CustomerID		-- use to validate there are customers with more than 3 orders. -793 (11,131)
	--having count(*) > 3
ORDER BY soh.CustomerID




