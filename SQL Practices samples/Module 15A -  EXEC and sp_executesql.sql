--  Execute or Exec uses a string as an argument.

USE AdventureWorks2016;

SET STATISTICS IO OFF
SET STATISTICS TIME OFF

DECLARE @sql  VARCHAR(500)
DECLARE @sql2 VARCHAR(500)
DECLARE @sql3 VARCHAR(500)

SELECT @sql  = 'select * from Person.Person where emailpromotion = '
SELECT @sql2 = '1'
SELECT @Sql3 = @SQL + @sql2
-- PRINT (@sql3) (test the code by using Print instead of Execute)
-- EXEC (@sql + @sql2)  -- returns emailpromotion 1 recipients
EXEC (@SQL)


-- sp_executesql allows the use of parameters in there original form (parameter substitution).
USE AdventureWorks2016;
GO
DECLARE @sql nvarchar(500)
DECLARE @ParameterDef nvarchar(500)
DECLARE @intPromotion int
SET		@ParameterDef = '@EmailPromotion int'
SET		@sql = 'select * from Person.Person where emailpromotion = @EmailPromotion'

SET @intPromotion = 2
EXECUTE sp_executesql 
		@sql, 
		@ParameterDef, 
		@EmailPromotion = @intPromotion;  -- emailpromotion 2 recipients
		
-- SQL Injection issue with EXEC

DECLARE @sql varchar(500)
DECLARE @sql2 varchar(500)
DECLARE @sql3 varchar(500)

SELECT @sql = 'select * from Person.Person where emailpromotion = '
SELECT @Sql3 = '1; Print '' All Data is lost!!!'''
SELECT @Sql2 = @SQL + @sql3
-- print (@sql2)  
exec (@sql2) -- returns emailpromotion 1 recipients

-- sp_executesql can provide better security because the EmailPromotion
-- parameter is passed in as an integer which will significantly reduce the 
-- range of values that can be passed into the stored procedure / dynamic sql.