/*
	ROW_NUMBER
	NTILE
	RANK
	DENSE_RANK
*/


-- DEMO 1 -- ROW NUMBER
-- SHOW HOW TO ASSIGN A ROW NUMBER TO EACH ORDER
-- NEXT SHOW HOW TO ASSIGN A ROW NUMBER TO EACH LINE ITEM WITHIN AN ORDER.

USE AdventureWorks2016;

SELECT
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	ROW_NUMBER() OVER (ORDER BY SalesOrderID) RN1, -- Assign a row number to all line items, no partition.
	ROW_NUMBER() OVER (PARTITION BY SalesOrderID ORDER BY SalesOrderDetailID) RN -- Rank each detail line item
FROM	
	Sales.SalesOrderDetail

-- ====== NTILE ====== --
-- DEMO 2 -- NTILE

SELECT
	SalesOrderID,
	SalesOrderDetailID,
	NTILE(20) OVER (ORDER BY SalesOrderID) NTILE1
FROM	
	Sales.SalesOrderDetail

-- DEMO 3 - NTILE WITH TOP
-- SHOW WITH TOP CLAUSE
-- This doesn't work because the TOP clause applies after the ranking function
-- in the order of logical query processing.

SELECT TOP(20)
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	NTILE(4) OVER (ORDER BY SalesOrderID) NTILE1
FROM	
	Sales.SalesOrderDetail

-- DEMO 4 - NTILE with subquery
-- SHOW NOW USING A SUBQUERY TO LIMIT THE RESULT SET.
SELECT 
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	NTILE(4) OVER (ORDER BY SalesOrderID) NTILE1
FROM	
	(SELECT TOP(20) * FROM Sales.SalesOrderDetail) x

-- ====== RANK ====== --
-- DEMO 5
-- SHOW BASIC SYNTAX OF RANK FUNCTION. Rank each line item within each sales order.
-- SHOW RANKING BY Line Total of each Sales Order Detail. Point out the jump from 3 to 6 here. 
-- How can we fix this jump in ranks, that is, if we want it fixed?
SELECT
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	RANK() OVER (PARTITION BY SalesOrderID ORDER BY SalesOrderDetailID) RNK1, -- BASIC SYNTAX
	RANK() OVER (PARTITION BY SalesOrderID ORDER BY LineTotal DESC) RNK_BY_LineTotal,
	RANK() OVER (ORDER BY LineTotal DESC) RNK_BY_LineTotal_AllSales
FROM
	Sales.SalesOrderDetail

-- ====== DENSE RANK ====== --
-- DEMO 6
-- In this example compare Rank with Dense Rank showing how to fix the gap
-- that appears when duplicates are in the code.

SELECT
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	RANK() OVER (ORDER BY LineTotal DESC)		RNK_BY_LineTotal_AllSales,
	DENSE_RANK() OVER (ORDER BY LineTotal DESC) DNS_RNK_BY_LineTotal_AllSales
FROM
	Sales.SalesOrderDetail