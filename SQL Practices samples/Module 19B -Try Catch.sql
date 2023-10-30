Use AdventureWorks2016
GO
-- DELETE FROM HumanResources.Department where DepartmentID = 17

-- DEMO 1 - GENERATES AN ERROR ON PRIMARY KEY CONSTRAINT
	  SET IDENTITY_INSERT HumanResources.Department ON
		  Insert into HumanResources.Department(DepartmentID,Name,GroupName,ModifiedDate)
		  Values(17,'Payroll','Executive General and Administration','1998-06-01 00:00:00:000')
	  SET IDENTITY_INSERT HumanResources.Department  OFF

-- DEMO 2 - TRY / CATCH is used to Capture the error and prevent it from bubbling up.
	BEGIN TRY
	  SET IDENTITY_INSERT HumanResources.Department ON
	  INSERT INTO HumanResources.Department(DepartmentID,Name,GroupName,ModifiedDate)
	  VALUES(17,'Payroll','Executive General and Administration','1998-06-01 00:00:00:000')
	  SET IDENTITY_INSERT HumanResources.Department  OFF
	END TRY
	BEGIN CATCH
	  PRINT  'Error!!!!'
	END CATCH

-- DEMO 3
/*
	Some errors, such as compile errors cannot be trapped within the same level even when executed
	with in TRY/CATCH.  To capture these errors we can capture them in the previous level.

	This first demo illustrates that the TRY/CATCH block does not capture the compile error.
*/
	BEGIN TRY
		SELECT * FROM dbo.trycatch   -- Table does not exist.
	END TRY
	BEGIN CATCH
		PRINT 'Error'
	END CATCH

-- Create a procedure for the query to show how the error can be caught outside the procedure.
-- DEMO 4A
/*
	Put the select statement into a stored procedure and wrap it in 
	another level of try catch which allows the error to be captured.
*/
	IF OBJECT_ID('dbo.testtrycatch') is not null   -- Drop procedure if exists.
	DROP PROCEDURE dbo.testtrycatch
	GO
	
	CREATE PROC dbo.testtrycatch  
	AS
	SELECT * FROM dbo.trycatch


-- DEMO 4B -- Execute the Stored Proc
	BEGIN TRY
		EXEC dbo.testtrycatch
	END TRY
	BEGIN CATCH
		PRINT 'Error!!!!!'
	END CATCH


--  DEMO 5A -- ERROR HANDLING FUNCTIONS
IF(object_ID('dbo.InsertDepartment')) is not null
	DROP PROC dbo.InsertDepartment
GO

CREATE PROC dbo.InsertDepartment
AS
	BEGIN TRY
		SET IDENTITY_INSERT HumanResources.Department ON
			Insert into HumanResources.Department(DepartmentID,Name,GroupName,ModifiedDate)
			Values(17,'Payroll','Executive General and Administration','1998-06-01 00:00:00:000')
		SET IDENTITY_INSERT HumanResources.Department  OFF
	END TRY
	BEGIN CATCH
	SELECT
		ERROR_NUMBER()			AS Error_Number,
		ERROR_MESSAGE()			AS Error_Message,
		ERROR_SEVERITY()		AS Severity,
		ERROR_STATE()			AS Error_State,
		ERROR_LINE()			AS Error_line,
		ERROR_PROCEDURE()		AS Error_Procedure
	END CATCH
	GO


-- DEMO 5B
EXEC  dbo.InsertDepartment

-- DEMO 6 -- RAISERROR
/*
	Capturing an error in a TRY/CATCH block prevents an error from bubbling up to the caller.
	To return an error to the caller we can use RAISERROR.
*/
IF(object_ID('dbo.InsertDepartment')) is not null
	DROP PROC dbo.InsertDepartment
GO

CREATE PROC dbo.InsertDepartment
AS
	BEGIN TRY
		SET IDENTITY_INSERT HumanResources.Department ON
			Insert into HumanResources.Department(DepartmentID,Name,GroupName,ModifiedDate)
			Values(17,'Payroll','Executive General and Administration','1998-06-01 00:00:00:000')
		SET IDENTITY_INSERT HumanResources.Department  OFF
	END TRY
	BEGIN CATCH
	
	SELECT
		ERROR_NUMBER()			AS Error_Number,
		ERROR_MESSAGE()			AS Error_Message,
		ERROR_SEVERITY()		AS Severity,
		ERROR_STATE()			AS Error_State,
		ERROR_LINE()			AS Error_line,
		ERROR_PROCEDURE()		AS Error_Procedure

	DECLARE 
		@Message		NVARCHAR(1000),
		@Severity		INT,
		@State			INT

	SELECT 
		@Message	= ERROR_MESSAGE(),
		@Severity	= ERROR_SEVERITY(),
		@State		= ERROR_STATE()

	RAISERROR(@Message, @Severity, @State)

	END CATCH
	GO

	EXEC  dbo.InsertDepartment

-- DEMO 6B - Hardcoded Values for RAISERROR
/*
	Note that the values for RAISERROR can also be hardcoded.
*/

IF(object_ID('dbo.InsertDepartment')) is not null
	DROP PROC dbo.InsertDepartment
GO

CREATE PROC dbo.InsertDepartment
AS
	BEGIN TRY
		SET IDENTITY_INSERT HumanResources.Department ON
			Insert into HumanResources.Department(DepartmentID,Name,GroupName,ModifiedDate)
			Values(17,'Payroll','Executive General and Administration','1998-06-01 00:00:00:000')
		SET IDENTITY_INSERT HumanResources.Department  OFF
	END TRY
	BEGIN CATCH
	
	SELECT
		ERROR_NUMBER()			AS Error_Number,
		ERROR_MESSAGE()			AS Error_Message,
		ERROR_SEVERITY()		AS Severity,
		ERROR_STATE()			AS Error_State,
		ERROR_LINE()			AS Error_line,
		ERROR_PROCEDURE()		AS Error_Procedure

	RAISERROR('Incorrect value supplied, please try again', 16, 1)

	END CATCH
	GO

	EXEC  dbo.InsertDepartment