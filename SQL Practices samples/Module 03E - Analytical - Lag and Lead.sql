
-- https://msdn.microsoft.com/en-us/library/hh231256.aspx

-- Show data in table. Show gaps between days where data does not exists.
USE		AdventureWorks2016;
SELECT * FROM MicrosoftStockHistory
ORDER BY Date

-- What is the best way to find the closing price of Monday vs. the closing price of Friday? 
-- SubQuery is one option but then you have to nest your query for things like 3 days or 4 day gaps due to holidays.
-- Lag and Lead functions are good examples to use here.

/* QUESTIONS 

	1) What is my difference between current day and previous day close?
		a) First Method:  Use Self Join method.
		b) Second Method: Use Row Number and Self Join method.
		c) Third Method:  Use Lag Function.
*/

-- Self Join method for acquiring the Previous Day Closing Price
-- Build this out incrementally one subquery at a time.
SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT 
	M1.Date, M1.ClosePrice,
	M2.Date, M2.ClosePrice
	--M3.Date, M3.ClosePrice,
	--M4.Date, M4.ClosePrice,
	--COALESCE(M1.ClosePrice, M2.ClosePrice, M3.ClosePrice, M4.ClosePrice) PrevClosePrice
FROM MicrosoftStockHistory M1
LEFT JOIN MicrosoftStockHistory M2
ON M1.Date = DATEADD(DD, 1, m2.Date)
--LEFT JOIN MicrosoftStockHistory M3
--ON M1.Date = DATEADD(DD, 2, M3.Date)-- maybe one day holiday
--LEFT JOIN MicrosoftStockHistory M4
--ON M1.Date = DATEADD(DD, 3, M4.Date)-- maybe weekend
ORDER BY m1.Date

-- DEMO 2 - Show how to use CTE with Row Number function.
-- Using CTE and SelfJoin to get previous day Close Price

WITH PreviousDay
AS
(
SELECT date, ClosePrice, ROW_NUMBER() over (partition by 1 Order By Date) rn
FROM MicrosoftStockHistory
)
	SELECT
		P1.Date, P1.ClosePrice, P2.ClosePrice,
		p1.ClosePrice - p2.ClosePrice PriceDifference
	FROM PreviousDay P1
	JOIN PreviousDay P2 
	ON P1.RN = P2.RN + 1

-- DEMO 3 - SHOW LAG 
SELECT DATE, ClosePrice,
	LAG(ClosePrice) OVER (ORDER BY DATE)				PrevClosePrice,
	LAG(ClosePrice, 2) OVER (ORDER BY DATE)				TwoDays_PrevClosePrice,
	ClosePrice - LAG(ClosePrice) OVER (ORDER BY DATE)	ClosePriceDifference
FROM MicrosoftStockHistory
ORDER BY Date

