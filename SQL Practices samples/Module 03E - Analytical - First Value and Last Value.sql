-- In this example demos how to quickly get the value at the begining of the month and end of month. 


SET STATISTICS IO ON
SET STATISTICS TIME ON

USE AdventureWorks2016;
SELECT 
	*,
	FIRST_VALUE(ClosePrice)  OVER (Partition By MONTH(Date), YEAR(DATE) Order By Date) FirstClosePrice,
	LAST_VALUE (ClosePrice)  OVER (Partition By MONTH(Date), YEAR(DATE) Order By Date) LastClosePrice 
FROM MicrosoftStockHistory
ORDER BY Date

-- DEMO HOW TO USE ROWS TO USE MEMORY AND NOT TEMP DB FOR THE FIRST VALUE.
-- DEMO HOW TO FIX THE LAST VALUE BY USING FRAMING. Current Row to Unbounded Following works within the partition identified.

USE AdventureWorks2016;
SELECT 
	*,
	FIRST_VALUE(ClosePrice) OVER (Partition By MONTH(Date), YEAR(DATE) Order By Date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FirstClosePrice,
	LAST_VALUE(ClosePrice)  OVER (Partition By MONTH(Date), YEAR(DATE) Order By Date ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) LastClosePrice 
	 --DATEADD(MM, -1, DATEADD(DD, 1, EOMONTH(Date))),
	 --EOMONTH(Date)
FROM MicrosoftStockHistory
ORDER BY Date