USE AdventureWorks2016;


-- Module 03
If OBJECT_ID('dbo.MicrosoftStockHistory') is not null
DROP TABLE dbo.MicrosoftStockHistory
go

-- Module 04
If OBJECT_ID('dbo.ControlTable_Module04') is not null
DROP TABLE dbo.ControlTable_Module04
go

-- Module 05
USE AdventureWorks2016;
		GO

		IF OBJECT_ID ('DimProduct') IS NOT NULL
		DROP TABLE DimProduct

-- Module 06
IF OBJECT_ID('dbo.ufnTotalDueByVendor') IS NOT NULL
	DROP FUNCTION dbo.ufnTotalDueByVendor;

IF OBJECT_ID (N'dbo.ufn_GetPersonAddress', N'FN') IS NOT NULL
	DROP FUNCTION ufn_GetPersonAddress; GO

IF OBJECT_ID (N'dbo.MS_SalesByStore') IS NOT NULL
    DROP FUNCTION dbo.MS_SalesByStore;

IF OBJECT_ID (N'dbo.SalesByStore', N'IF') IS NOT NULL
    DROP FUNCTION dbo.SalesByStore;

IF OBJECT_ID (N'dbo.ufn_ListOfDates') IS NOT NULL
    DROP FUNCTION dbo.ufn_ListOfDates;

-- Module 17
IF OBJECT_ID ('dbo.Top3Orders') IS NOT NULL 
DROP FUNCTION dbo.Top3Orders;

-- Module 10
IF OBJECT_ID ('usp_Customers') IS NOT NULL
DROP PROCEDURE usp_Customers; 

-- Module 12
IF OBJECT_ID('usp_CustomerInfo', 'P') IS NOT NULL
	DROP PROC usp_CustomerInfo;

-- Module 13
If OBJECT_ID('dbo.Customers') is not null
DROP TABLE dbo.Customers;

If OBJECT_ID('dbo.Customers_Stage') is not null
DROP TABLE dbo.Customers_Stage;

-- Module 14
IF OBJECT_ID('usp_SubcategoryList') IS NOT NULL
DROP PROCEDURE usp_SubcategoryList;

-- Module 17
IF OBJECT_ID('Module17_XML') IS NOT NULL
DROP TABLE Module17_XML

-- Module 18
If OBJECT_ID('dbo.Autocommit') is not null
DROP TABLE dbo.Autocommit
go


If OBJECT_ID('dbo.ExplicitTransaction') is not null
DROP TABLE dbo.ExplicitTransaction
go


If OBJECT_ID('dbo.ImplicitTransaction') is not null
DROP TABLE dbo.ImplicitTransaction
go

-- Module 19
If OBJECT_ID('dbo.testtrycatch') is not null   
DROP PROCEDURE dbo.testtrycatch

If(object_ID('dbo.InsertDepartment')) is not null
DROP PROCEDURE dbo.insertDepartment
go