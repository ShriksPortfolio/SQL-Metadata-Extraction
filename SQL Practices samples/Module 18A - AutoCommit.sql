-- The Default for SQL is autocommit.

-- AutoCommit examples

-- Autocommit will commit lines that run succesful and not run lines that have run time errors.
-- Running the following will autocommit Alabama  and Alaska, but not Arkansas.

USE AdventureWorks2016;

If OBJECT_ID('dbo.Autocommit') is not null
drop table dbo.Autocommit
go
Create table Dbo.Autocommit (AutocommitKey INT PRIMARY KEY, Name varchar(50));
GO
-- RUN-TIME ERROR
INSERT INTO dbo.Autocommit VALUES (1, 'Alabama') -- Auto Commit
INSERT INTO dbo.Autocommit VALUES (2, 'Alaska')  -- Auto Commit
INSERT INTO dbo.Autocommit VALUES (1, 'Arkansas') -- Duplicate key error.
GO
SELECT * FROM dbo.Autocommit  -- Returns Alabama and Alaska.
GO

-- TRY TO ROLLBACK THE CHANGES
ROLLBACK TRANSACTION	-- WILL FAIL.
GO
SELECT * FROM dbo.Autocommit  -- Returns Alabama and Alaska.
GO

-- Autocommit works differently with compile errors
-- Running the following will not commit  Alabama,Alaska, or Arkansas.

If OBJECT_ID('dbo.Autocommit') is not null
drop table dbo.Autocommit
go
Create table Dbo.Autocommit (AutocommitKey INT PRIMARY KEY, Name varchar(50));
GO
-- COMPILE ERROR
INSERT INTO dbo.Autocommit VALUES (1, 'Alabama')
INSERT INTO dbo.Autocommit VALUES (2, 'Alaska')
INSERT INTO dbo.Autocommit VALUE (3, 'Arkansas') -- Syntax Error / Compile error
GO
SELECT * FROM dbo.Autocommit  -- Shows no rows
GO


