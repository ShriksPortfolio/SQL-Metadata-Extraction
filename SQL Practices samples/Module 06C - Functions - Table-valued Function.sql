/*------------------------------MULTI-STATEMENT TABLE-VALUED FUNCTION-----------------------------------------------------------------------*/

--Multi-Statement Table-valued Function creates the definition of the table object with a table variable
--MSITVF - Requires Table variable and definition and may include the "BEGIN/END" blocks and returns the table variable
--Returned table is defined by the variable definition
--Multi-Statement Table-valued Functions can NOT be used to update underlying tables

IF OBJECT_ID (N'dbo.MS_SalesByStore') IS NOT NULL
    DROP FUNCTION dbo.MS_SalesByStore;
GO
CREATE FUNCTION dbo.MS_SalesByStore (@storeid int)
RETURNS @table TABLE (productID int, Name varchar(50),Total numeric(16,2)) -- required metadata. Define Table variable.
AS
BEGIN
  INSERT INTO @table
    SELECT P.ProductID, P.Name, SUM(SD.LineTotal) AS 'Total'
    FROM Production.Product		AS P 
    JOIN Sales.SalesOrderDetail AS SD ON SD.ProductID		= P.ProductID
    JOIN Sales.SalesOrderHeader AS SH ON SH.SalesOrderID	= SD.SalesOrderID
    JOIN Sales.Customer			AS C  ON SH.CustomerID		= C.CustomerID
    WHERE C.StoreID = @storeid
    GROUP BY P.ProductID, P.Name

 RETURN
END
GO

--Select syntax is treated like querying a table
SELECT * from dbo.MS_SalesByStore (1020)

--Example of inLine Table-valued Funtion
--There are no "BEGIN/END" blocks for inline table-valued Functions
--Returned table is defined by the select statement
--Inline Table-valued functions are better for performance than Multistatement Table-valued Function
--SQL treats Inline Table-valued Function like a view
--Underlying tables can be updated using the Inline Table-valued function

USE AdventureWorks2016;

IF OBJECT_ID (N'dbo.SalesByStore', N'IF') IS NOT NULL
    DROP FUNCTION dbo.SalesByStore;
GO
CREATE FUNCTION dbo.SalesByStore (@storeid int)
RETURNS TABLE
AS
RETURN 
(
    SELECT P.ProductID, P.Name, SUM(SD.LineTotal) AS 'Total'
    FROM Production.Product AS P 
    JOIN Sales.SalesOrderDetail AS SD ON SD.ProductID		= P.ProductID
    JOIN Sales.SalesOrderHeader AS SH ON SH.SalesOrderID	= SD.SalesOrderID
    JOIN Sales.Customer			AS C ON SH.CustomerID		= C.CustomerID
    WHERE C.StoreID = @storeid
    GROUP BY P.ProductID, P.Name
);
GO

--Select all product sales for a single store into table resultset
SELECT * FROM dbo.SalesByStore (1020);

--Select all product sales for all stores using CROSS APPLY
--Note Apply is required here because a join can not be performed to a function.
SET STATISTICS IO ON
SET STATISTICS TIME ON

-- Multi-Statement TVF will perform worse
SELECT CustomerID, StoreID, TerritoryID, AccountNumber, ProductID, Name, Total 
FROM Sales.Customer
CROSS APPLY dbo.MS_SalesByStore (StoreID) 

-- Code will be inlined by SQL Server and will perform significantly better.
SELECT CustomerID, StoreID, TerritoryID, AccountNumber, ProductID, Name, Total 
FROM Sales.Customer
CROSS APPLY dbo.SalesByStore (StoreID)


-- MS TVF with procedural code
-- SQL Server Engine cannot optimize the code and access the underlying objects.

USE AdventureworksDW2016;

IF OBJECT_ID (N'dbo.ufn_ListOfDates') IS NOT NULL
    DROP FUNCTION dbo.ufn_ListOfDates;
GO
CREATE FUNCTION dbo.ufn_ListOfDates (@StartDate date)
RETURNS @table TABLE (ProcessDate Date) -- required metadata. Define Table variable.
AS
BEGIN
	DECLARE @counter int = 0
	WHILE @Counter < 10
		BEGIN
			 INSERT INTO @table
				SELECT dd.FullDateAlternateKey as ProcessDate
				FROM DimDate		dd 
				WHERE FullDateAlternateKey = @StartDate
		
			SET @counter = @counter + 1
			SET @StartDate = DATEADD(dd, -1, @StartDate)
		END
 Return
End
GO

--Select syntax is treated like querying a table
select * from dbo.ufn_ListOfDates ('1/10/2008')






