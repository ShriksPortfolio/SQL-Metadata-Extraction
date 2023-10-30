-- SETUP - Create table for following examples.

USE AdventureWorks2016;
GO

IF OBJECT_ID('dbo.ControlTable_Module04') is not null
DROP TABLE dbo.ControlTable_Module04
go

;with dates ([Date]) as (
    Select convert(date, dateadd(dd, -10, getdate())) as [Date] -- Put the start date here

    union all 

    Select dateadd(day, 1, [Date])
    from dates
    where [Date] <= dateadd(dd, -3, GETDATE()) -- Put the end date here 
)

-- Create ControlTable for Module 04 demo
SELECT date, CAST('1/1/2099' AS DATETIME) LastLoadDate 
INTO ControlTable_Module04
FROM dates
option (maxrecursion 32767) -- Don't forget to use the maxrecursion option!


SELECT * FROM ControlTable_Module04