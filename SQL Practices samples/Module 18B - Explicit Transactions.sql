-- Explicit means you need to tell SQL when a transaction starts
-- Example

USE AdventureWorks2016;

IF OBJECT_ID('dbo.ExplicitTransaction') is not null
DROP TABLE dbo.ExplicitTransaction
GO
CREATE TABLE dbo.ExplicitTransaction (ExplicitTransactionKey INT PRIMARY KEY, Name varchar(50));
GO

BEGIN TRANSACTION
	INSERT INTO dbo.ExplicitTransaction VALUES (1, 'Alabama')
	INSERT INTO dbo.ExplicitTransaction VALUES (2, 'Alaska')
	INSERT INTO dbo.ExplicitTransaction VALUES (1, 'Arkansas') -- Duplicate Key Error
	GO
	SELECT * FROM dbo.ExplicitTransaction  -- Returns rows 1 and 2.
	GO

-- Run rollback to remove entries
ROLLBACK TRANSACTION
GO
SELECT * FROM dbo.ExplicitTransaction  -- Rows have been removed
GO

-- Fix the third row and then commit the changes.  

IF OBJECT_ID('dbo.ExplicitTransaction') is not null
DROP TABLE dbo.ExplicitTransaction
GO
CREATE TABLE Dbo.ExplicitTransaction (ExplicitTransactionKey INT PRIMARY KEY, Name varchar(50));
GO
BEGIN TRANSACTION
INSERT INTO dbo.ExplicitTransaction VALUES (1, 'Alabama')
INSERT INTO dbo.ExplicitTransaction VALUES (2, 'Alaska')
INSERT INTO dbo.ExplicitTransaction VALUES (3, 'Arkansas') -- Duplicate Key Error
GO
SELECT * FROM dbo.ExplicitTransaction  -- Returns all three rows.
GO

-- Run commit
COMMIT TRANSACTION

-- NOW ROLLBACK WILL NOT WORK BECAUSE THE TRANSACTION WAS COMMITTED.
ROLLBACK TRANSACTION
GO
SELECT * FROM dbo.ExplicitTransaction  
GO

-- Implicit transactions are an option that can be turned on
-- With implicit transactions statements are no longer autocommitted.

go
IF OBJECT_ID('dbo.ImplicitTransaction') is not null
DROP TABLE dbo.ImplicitTransaction
GO
CREATE TABLE dbo.ImplicitTransaction (ImplicitTransactionKey INT PRIMARY KEY, Name varchar(50));
GO
SET IMPLICIT_TRANSACTIONS ON

INSERT INTO dbo.ImplicitTransaction VALUES (1, 'Alabama')
INSERT INTO dbo.ImplicitTransaction VALUES (2, 'Alaska')
INSERT INTO dbo.ImplicitTransaction VALUES (3, 'Arkansas') 
GO
SELECT * FROM dbo.ImplicitTransaction  -- Returns all three rows.
GO

-- now rollback will work 
ROLLBACK TRANSACTION
GO
SELECT * FROM dbo.ImplicitTransaction  -- Rows have been removed
GO

-- Turn off implicit transactions
SET IMPLICIT_TRANSACTIONS OFF
