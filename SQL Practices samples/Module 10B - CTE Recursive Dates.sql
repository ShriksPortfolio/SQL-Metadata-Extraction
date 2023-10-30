
/*
	DATEFROMPARTS (YEAR, MONTH, DAY)
	EOMONTH
	Recursive CTE
*/

;WITH dates ([Date]) AS (
    SELECT DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) AS [Date] -- Put the start date here (Anchor)

    UNION ALL															 -- Split Anchor and Recursive Members

    SELECT dateadd(day, 1, [Date])
    FROM dates
    WHERE [Date] < EOMONTH(GETDATE())									 -- Put the end date here (Recursive Members)
)

SELECT [Date], 0
FROM dates
option (maxrecursion 32767) 
