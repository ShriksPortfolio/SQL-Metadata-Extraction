
USE [AdventureWorks2016];
 
 -- DEMO 1 - ROWS/RANGE UNBOUNDED PRECEDING
 -- UNBOUNDED PRECEDING - **The window starts with the first row and ends with the current row
 -- To Calculate Cumulative SUM or Running Totals:
 -- Show the difference in results between RANGE and ROWS
	 -- RANGE gets the cummulative total for all items in the order by that match and displays
	 -- the same value for each one. ROWS, on the other hand does more of what you would expect
	 -- here and aggregates the data one row at a time.

 SET STATISTICS IO ON
 SET STATISTICS TIME ON

 SELECT 
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal
	,SUM(LineTotal) OVER (ORDER BY SalesOrderID) RunningTotal
	,SUM(LineTotal) OVER (ORDER BY SalesOrderID ROWS UNBOUNDED PRECEDING) AS SumByRows
       ,SUM(LineTotal) OVER (ORDER BY SalesOrderID RANGE UNBOUNDED PRECEDING) AS SumByRange
 FROM Sales.SalesOrderDetail
 ORDER BY SalesOrderID

-- DEMO 2 - ROWS/RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
-- This means that the windows starts at the current row and ends at the last row.
-- We use CURRENT ROW and Unbounded Following to start at the current row and get a cummulative total to the last row.
-- First show Rows vs. Range with no Partition By.
-- Finally show Rows using Partition By on Purchase OrderID.

SELECT [PurchaseOrderID],
       [PurchaseOrderDetailID],
       [ProductID],
       [LineTotal]
	   ,SUM(LineTotal) OVER (ORDER BY PurchaseOrderID ROWS  BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS SumByRows
	   --,SUM(LineTotal) OVER (ORDER BY PurchaseOrderID RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS SumByRange
	   --,SUM(LineTotal) OVER (PARTITION BY PurchaseOrderID ORDER BY PurchaseOrderID ROWS  BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS SumWithPartitionBy
  FROM 
	[Purchasing].[PurchaseOrderDetail]
  WHERE PurchaseOrderID < 10
  ORDER BY PurchaseOrderID, PurchaseOrderDetailID





-- DEMO 3 - DEMO WITHOUT UNBOUNDED.
-- First show how to do 1 row previous and 1 after.
-- Second show 1 preceding and 1 following on RANGE. Explain error.
-- Now change Range to ROWS
-- Add one more line of code this time using 1 PRECEDING AND UNBOUNDED FOLLOWING. 
-- Explain that at this point any combination of frame delimiters could be used.
 SELECT [PurchaseOrderID],
       [PurchaseOrderDetailID],
       [ProductID],
       [LineTotal],
	   SUM(LineTotal) OVER (ORDER BY PurchaseOrderID ROWS  BETWEEN CURRENT ROW AND 1 FOLLOWING) AS SumByRows,
	   -- SUM(LineTotal) OVER (ORDER BY PurchaseOrderID RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS SumByRange,
	   SUM(LineTotal) OVER (ORDER BY PurchaseOrderID ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS SumByRange,
	   SUM(LineTotal) OVER (ORDER BY PurchaseOrderID ROWS BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING) AS SumByRange
  FROM 
	[Purchasing].[PurchaseOrderDetail]
  WHERE PurchaseOrderID < 10
  ORDER BY PurchaseOrderID, PurchaseOrderDetailID



