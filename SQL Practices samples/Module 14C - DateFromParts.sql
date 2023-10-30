
SELECT DATEFROMPARTS ( 2010, 12, 31 ) AS Result;

-- Return First day of Month
Select DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) as [Date]