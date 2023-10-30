/*
		sys.dm_exec_plan_attributes
		sys.dm_exec_sql_text
		sys.dm_exec_query_plan
		sys.dm_exec_cached_plans
*/

-- DEMO 1 - ACTUAL vs ESTIMATED query plans

-- DEMO 2 - GRAPHICAL AND XML EXECUTION PLANS
USE AdventureworksDW2016;
GO
SET SHOWPLAN_XML ON;
--SET SHOWPLAN_XML OFF;
GO

SELECT 
	dc.FirstName + '' + dc.LastName AS CustomerName,
	MAX(CAST(CAST(fis.OrderDateKey AS VARCHAR) AS DATE)) LastOrderDate,
	SUM(SalesAmount) TotalSales,
	Count(*) TransactionCount
FROM FactInternetSales fis
JOIN DimCustomer dc
ON fis.CustomerKey = dc.CustomerKey
GROUP BY dc.FirstName + '' + dc.LastName
ORDER BY CustomerName

-- DEMO 3B -- SAVE XML FILE TO MODULES FOLDER. OPEN IT. CREATE A COPY AND RENAME TO .SQLPLAN. OPEN IT AGAIN, THIS TIME IT OPENS UP IN GRAPHICAL FORMAT.

-- DEMO 3C -- PLAN TEXT -- DEPRECATED AND RECOMMENDED TO USE XML.
SET SHOWPLAN_TEXT ON;
SET SHOWPLAN_TEXT OFF;

SELECT 
	dc.FirstName + '' + dc.LastName AS CustomerName,
	MAX(CAST(CAST(fis.OrderDateKey AS VARCHAR) AS DATE)) LastOrderDate,
	SUM(SalesAmount) TotalSales,
	Count(*) TransactionCount
FROM FactInternetSales fis
JOIN DimCustomer dc
ON fis.CustomerKey = dc.CustomerKey
GROUP BY dc.FirstName + '' + dc.LastName
ORDER BY CustomerName

-- DEMO 4 -- SET Statistics IO & Statistics TIME on.
SET STATISTICS IO ON
SET STATISTICS TIME ON


SELECT 
	dc.FirstName + '' + dc.LastName AS CustomerName,
	MAX(CAST(CAST(fis.OrderDateKey AS VARCHAR) AS DATE)) LastOrderDate,
	SUM(SalesAmount) TotalSales,
	Count(*) TransactionCount
FROM FactInternetSales fis
JOIN DimCustomer dc
ON fis.CustomerKey = dc.CustomerKey
GROUP BY dc.FirstName + '' + dc.LastName
ORDER BY CustomerName