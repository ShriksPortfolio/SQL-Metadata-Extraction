/*
		DYNAMICALLY CREATE TABLE
		sys.dm_exec_describe_first_result_set
		STUFF FUNCTION
		IF NOT EXISTS
		EXEC sp_executesql @sql
*/

	USE AdventureWorks2016;
-- INPUT PARAMETERS
	DECLARE @FCT_DT DATE		= '5/6/2016'
	DECLARE @table  VARCHAR(50)	= 'Person.Person' 

	DECLARE @strFactDate varchar(8) = convert(varchar, @FCT_DT ,112)
	DECLARE @newtable NVARCHAR(MAX) = @table + '_' + @strFactDate
	DECLARE @sql  NVARCHAR(MAX)
	DECLARE @cols NVARCHAR(MAX) = N''
	DECLARE @debug INT = 1
	
	IF @debug = 0
	BEGIN
		IF OBJECT_ID(@newtable) IS NOT NULL 
		DROP TABLE Person.Person_20160506
	END

	-- SELECT * FROM  sys.dm_exec_describe_first_result_set('SELECT * FROM ' + @TABLE, NULL, 1)

	SELECT @cols += N', [' + name + '] '+  system_type_name + case is_nullable when 1 then ' NULL' else ' NOT NULL' end
	FROM  sys.dm_exec_describe_first_result_set('SELECT * FROM ' + @table, NULL, 1)

	PRINT @cols

	SET @cols = STUFF(@cols, 1, 2, N'');

	PRINT @cols

	SET @sql = N'CREATE TABLE '+ @newtable + '(' + @cols + ') '  -- newtable = Person.Person_20160506

IF NOT EXISTS (SELECT 1 FROM sys.tables where object_name(object_id) = @newtable)
	BEGIN
				
		IF @DEBUG = 1 
			BEGIN 
				PRINT @sql
			END
				ELSE 
			BEGIN 
				EXEC sp_executesql @sql
			END 
	END

		Select @newtable as NewTable,
		@strFactDate as PPNDate 