/* === SCENARIO ===
	From the SalesOrderHeader table return all orders for any 
	customers that had more than $10,000 for their first three orders.

	RETURN all Sales Orders for each customer that had greater than $10,000 in sales for their first three orders.
*/

USE AdventureWorks2016; 
GO

-- MULTIPLE CTEs
-- FIRST CTE Returns a list of all SalesOrders per Customer and assigns a row number.
-- SECOND CTE Aggregates the first three Sales Orders for each customer and also assigns a row number to each occurance
-- of a customer ID. This will make removing duplicates easier. Could alternatively use DISTINCT or a Group by
-- depending on what columns end up being included.
-- THIRD - The select statement returns the distinct customers from the second CTE who had total sales greater than 10,000
	--then does a join to SalesOrderHeader to return all SalesOrderIDs.
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
ORDER BY soh.CustomerID


SELECT SalesOrderID, CustomerID, TotalDue 
FROM Sales.SalesOrderHeader