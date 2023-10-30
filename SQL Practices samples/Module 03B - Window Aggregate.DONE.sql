USE AdventureWorks2016;

-- DEMO 1
-- TOTALS
-- PERCENT OF PARENT
-- 1) Show the total of all sales order by excluding the Parition By.
-- 2) Show the total for each SalesOrder by partitioning by the SalesOrderID.
-- 3) Finally show how we can now divide the total for each detailed item 
--	  by the total of the order.

SELECT
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	SUM(LineTotal) OVER() AS WithoutPartitionBy,
	SUM(LineTotal) OVER(Partition By SalesOrderID) AS TransactionTotal,
	LineTotal /	SUM(LineTotal) OVER(Partition By SalesOrderID) * 100 PctOftotal
FROM	
	Sales.SalesOrderDetail

-- DEMO 2
-- RUNNING TOTAL
-- In this example we show how to quickly and easily create a running total by Customer.
-- by using framing. (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW).
-- With statistics on we see that the WORK TABLE is being
-- scanned with RANGE but not ROWS. With ROWS the work is done in memory.

	SET STATISTICS IO ON
	SET STATISTICS TIME ON 

	SELECT 
		CustomerId, SalesOrderID, OrderDate, TotalDue,
		SUM(TotalDue) 
			OVER(PARTITION BY CustomerID ORDER By SalesOrderID) AS RunningTotal	--  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	FROM	
		Sales.SalesOrderHeader;