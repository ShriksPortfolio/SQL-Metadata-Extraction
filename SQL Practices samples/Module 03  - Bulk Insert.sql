/*
	This script is used to create a table for Module 03E.
*/

USE [AdventureWorks2016];
GO

-- Drop Table if it already exists
IF OBJECT_ID('dbo.MicrosoftStockHistory') is not null
DROP TABLE dbo.MicrosoftStockHistory
GO

-- Create Table
/****** Object:  Table [dbo].[MicrosoftStockHistory]    Script Date: 7/5/2016 2:05:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MicrosoftStockHistory](
	[Date] [date]				NOT NULL,
	[OpenPrice] [numeric](5, 2) NOT NULL,
	[High] [numeric](5, 2)		NOT NULL,
	[Low] [numeric](5, 2)		NOT NULL,
	[ClosePrice] [numeric](5, 2) NOT NULL,
	[Volume] [bigint]			NOT NULL,
	[AdjClose] [numeric](5, 2)	NOT NULL
) ON [PRIMARY]

GO

-- Load Table using Bulk Insert
BULK INSERT MicrosoftStockHistory
FROM 'C:\Advanced TSQL\Module Resources\Module 03\Microsoft Stock Info.csv'
WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',	-- CSV Field Delimiter
		ROWTERMINATOR = '\n',	-- Use to shift the control to next row
		TABLOCK
	)



	