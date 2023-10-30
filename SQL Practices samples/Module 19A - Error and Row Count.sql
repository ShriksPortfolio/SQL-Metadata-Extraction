-- BATCH TERMINATING

	-- BATCH and NON BATCH TERMINATING ERRORS:
	
		-- DIVIDE BY 0
		SELECT 1/0
		PRINT 'Batch Doesn’t Terminate'

		-- COMPILE ERRORS
		SELECT * FROM MyTableThatDoesNotExists
		PRINT 'Batch Terminated... apparently..'
	
		-- CONVERSION ERRORS
		SELECT 'Mitchell' + 4
		PRINT 'WHO KNOWS...'

-- @@ERROR and @@ROWCOUNT

-- DEMO 1 -- @@ERROR & @@ROWCOUNT - DON'T WORK
/*
	In this first demo @@ERROR and @@ROWCOUNT do not capture the error from the insert statement because they do not 
	immediately follow the insert statement. They both follow the "SET IDENTITY_INSERT" statement which replaces / overrides
	the values of those two variables with a 0 because that statement completes successfully.
*/

USE AdventureWorks2016;
GO
SET IDENTITY_INSERT HumanResources.Department ON
  INSERT INTO HumanResources.Department(DepartmentID,Name,GroupName,ModifiedDate)
  VALUES (17,'Payroll','Executive General and Administration','2008-04-30 00:00:00:000')
  SET IDENTITY_INSERT HumanResources.Department  OFF

PRINT N'Error = ' + CAST(@@ERROR AS NVARCHAR(8)); 
PRINT N'Rows Inserted = ' + CAST(@@ROWCOUNT AS NVARCHAR(8)); 
-- THIS PRINT STATEMENT FOLLOWS THE PREVIOUS PRINT STATEMENT AND THEREFORE WILL ALWAYS RETURN 0
-- BECAUSE THE PREVIOUS PRINT STATEMENT SET @@ROWCOUNT = 0
GO

-- DEMO 2 - 
/*
	In this demo @@ERROR can now capture the error because it is called directly after the statement that generated
	the error. However @@ROWCOUNT is called after the PRINT @@ERROR statement and therefore the variable @@ROWCOUNT
	is set to 0 since no rows were affected by the previous PRINT statement.
*/
USE AdventureWorks2016;
GO
SET IDENTITY_INSERT HumanResources.Department ON
  INSERT INTO HumanResources.Department(DepartmentID,Name,GroupName,ModifiedDate)
  VALUES (17,'Payroll','Executive General and Administration','2008-04-30 00:00:00:000')

PRINT N'Error = ' + CAST(@@ERROR AS NVARCHAR(8));			 -- @@ERROR WILL NOW CAPTURE ERRORS FROM THE INSERT.
PRINT N'Rows Inserted = ' + CAST(@@ROWCOUNT AS NVARCHAR(8)); -- SAME AS PREVIOUS EXAMPLE
GO
  SET IDENTITY_INSERT HumanResources.Department  OFF

-- DEMO 3
/*
	In this demo @@ERROR and @@ROWCOUNT are both called after the insert statement.
*/

GO
SET IDENTITY_INSERT HumanResources.Department ON
  INSERT INTO HumanResources.Department(DepartmentID,Name,GroupName,ModifiedDate)
  VALUES (17,'Payroll','Executive General and Administration','2008-04-30 00:00:00:000')
  
PRINT N'Error = ' + CAST(@@ERROR AS NVARCHAR(8)) + ' Rows Inserted = ' + CAST(@@ROWCOUNT AS NVARCHAR(8));
GO
  SET IDENTITY_INSERT HumanResources.Department  OFF
-- This PRINT would successfully capture any error number.

-- CLEANUP
BEGIN TRAN
	DELETE FROM HumanResources.Department WHERE DepartmentID = 17
COMMIT
