USE AdventureWorks2016;
GO
/****** Object:  StoredProcedure [dbo].[uspUnknownRow]    Script Date: 3/14/2013 8:55:11 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[uspUnknownRow]  
      @TableSchema sysname = 'dbo',
      @TableName sysname, 
      @UnknownKeyValue int = -1, 
      @Action varchar(10) = 'Script' 
as 
 
  declare @ColumnListing varchar(max) = ''
  declare @foreignkeys varchar(max)
  declare @ValuesList varchar(max) = ''
  declare @query varchar(max)=' ' 
  declare @primaryKey sysname
  declare @primaryKeyColumnCount int
  declare @BadDataType sysname = null
  
  begin try 

    --=============================================================================================
    -- Check to see if table exists
    --=============================================================================================
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @TableSchema and TABLE_NAME = @TableName and TABLE_TYPE = 'BASE TABLE')
      raiserror ('Error - table %s does not exist in shema %s', 16,1,@TableName,@TableSchema) 

    --=============================================================================================
    -- Check to see if table has a primary key and make sure it is not a compound key
    --=============================================================================================
    select 
      @primaryKeyColumnCount = count(*)
    from 
      INFORMATION_SCHEMA.TABLE_CONSTRAINTS as tc
      join INFORMATION_SCHEMA.KEY_COLUMN_USAGE as kcu
        on kcu.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
          and kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
          and kcu.TABLE_SCHEMA = tc.TABLE_SCHEMA
          and kcu.TABLE_NAME = tc.TABLE_NAME
    where 
      tc.CONSTRAINT_TYPE in ( 'PRIMARY KEY')
      and kcu.TABLE_SCHEMA = @TableSchema
      and kcu.TABLE_NAME = @TableName  
   
    if @primaryKeyColumnCount = 0 
      raiserror ('Error - uspUnknownRow does not support tables without a primary key', 16,1) 
    if @primaryKeyColumnCount > 1 
      raiserror ('Error - uspUnknownRow does not support tables with multi-column primary keys', 16,1)
        
    --=============================================================================================
    -- Get PK column but fail if PK column data type is not int, bigint, or tiny int
    --=============================================================================================
    select 
      @primaryKey = kcu.COLUMN_NAME
    from 
      INFORMATION_SCHEMA.TABLE_CONSTRAINTS as tc
      join INFORMATION_SCHEMA.KEY_COLUMN_USAGE as kcu
        on kcu.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
          and kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
          and kcu.TABLE_SCHEMA = tc.TABLE_SCHEMA
          and kcu.TABLE_NAME = tc.TABLE_NAME
        join INFORMATION_SCHEMA.COLUMNS c
          on c.TABLE_SCHEMA = tc.TABLE_SCHEMA
            and c.TABLE_NAME = tc.TABLE_NAME
            and kcu.COLUMN_NAME = c.COLUMN_NAME
    where 
      tc.CONSTRAINT_TYPE in ( 'PRIMARY KEY')
      AND c.DATA_TYPE in ('INT','BIGINT','TINYINT')
      and kcu.TABLE_SCHEMA = @TableSchema
      and kcu.TABLE_NAME = @TableName
    
    if @primaryKey is null 
      raiserror ('Error - uspUnknownRow does not support tables with primary keys with this data type.', 16,1)

    --=============================================================================================
    -- Check for unsupported data types
    --=============================================================================================
    SELECT top 1
      @BadDataType = c.DATA_TYPE
    FROM  
      INFORMATION_SCHEMA.COLUMNS c 
      INNER JOIN SYSOBJECTS o ON c.TABLE_NAME = o.name 
      INNER JOIN sys.schemas s ON o.uid = s.schema_id 
      LEFT JOIN sys.all_columns c2 ON o.id = c2.object_id AND c.COLUMN_NAME = c2.name 
    WHERE 
      c.TABLE_NAME = @TableName 
      AND c.TABLE_SCHEMA = @TableSchema 
      AND c2.is_computed = 0 
      AND c.TABLE_SCHEMA = s.name 
      AND c.COLUMN_NAME <> @primaryKey
      AND c.DATA_TYPE not IN ('INT', 'NUMERIC', 'DECIMAL','TINYINT','FLOAT','BIT','VARCHAR', 'CHAR', 'NVARCHAR', 'NCHAR','DateTime','Date')

    if @BadDataType is not null
      raiserror ('Error - uspUnknownRow does not data type %s', 16,1,@BadDataType) 
      
    --=============================================================================================
    -- Get column list
    --=============================================================================================
    set @ColumnListing = '[' + @primaryKey + '],'
    SELECT 
      @ColumnListing += '['+Column_Name+']'+',' 
    FROM  
      INFORMATION_SCHEMA.COLUMNS c 
      INNER JOIN SYSOBJECTS o ON c.TABLE_NAME = o.name 
      INNER JOIN sys.schemas s ON o.uid = s.schema_id 
      LEFT JOIN sys.all_columns c2 ON o.id = c2.object_id AND c.COLUMN_NAME = c2.name 
    WHERE 
      c.TABLE_NAME = @TableName 
      AND c.TABLE_SCHEMA = @TableSchema 
      AND c2.is_computed = 0 
      AND c.TABLE_SCHEMA = s.name 
      AND COLUMN_NAME <> @primaryKey  -- PK already added
    ORDER BY 
      c.ORDINAL_POSITION 

    set @ColumnListing = '(' + SUBSTRING(@ColumnListing,0, len(@columnlisting)) + ')'

    --=============================================================================================
    -- Get value list
    --=============================================================================================
    set @ValuesList =  cast(@UnknownKeyValue as varchar(50)) + ','
    SELECT 
      @ValuesList += 
      CASE 
		WHEN DATA_TYPE IN ('INT', 'NUMERIC', 'DECIMAL','TINYINT','FLOAT','BIT') and tc.CONSTRAINT_TYPE in ( 'FOREIGN KEY') THEN '-1'
        WHEN DATA_TYPE IN ('INT', 'NUMERIC', 'DECIMAL','TINYINT','FLOAT','BIT') THEN '0' 
        WHEN DATA_TYPE IN ('VARCHAR', 'CHAR', 'NVARCHAR', 'NCHAR') THEN 
          case 
            when CHARACTER_MAXIMUM_LENGTH = 1 then '''?'''
            when CHARACTER_MAXIMUM_LENGTH between 4 and 7 then '''UNK'''
            else ''''+rtrim(left('UNKNOWN',CHARACTER_MAXIMUM_LENGTH))+''''
          end
        WHEN DATA_TYPE IN ('DateTime','Date') THEN '''1900-01-01''' 
      END+',' 
    FROM 
      INFORMATION_SCHEMA.TABLE_CONSTRAINTS as tc
      RIGHT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE as kcu
        on kcu.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
          and kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
          and kcu.TABLE_SCHEMA = tc.TABLE_SCHEMA
          and kcu.TABLE_NAME = tc.TABLE_NAME
      RIGHT JOIN INFORMATION_SCHEMA.COLUMNS c
          on c.TABLE_SCHEMA = tc.TABLE_SCHEMA
            and c.TABLE_NAME = tc.TABLE_NAME
            and kcu.COLUMN_NAME = c.COLUMN_NAME
      INNER JOIN SYSOBJECTS o ON c.TABLE_NAME = o.name 
      INNER JOIN sys.schemas s ON o.uid = s.schema_id 
      LEFT JOIN sys.all_columns c2 ON o.id = c2.object_id AND c.COLUMN_NAME = c2.name 
      
    WHERE 
      c.TABLE_NAME = @TableName 
      AND c.TABLE_SCHEMA = @TableSchema 
      AND c2.is_computed = 0 
      AND c.TABLE_SCHEMA = s.name 
      AND c.COLUMN_NAME <> @primaryKey
    ORDER BY 
      c.ORDINAL_POSITION 

    set @ValuesList = '('+substring(@ValuesList,0,LEN(@valueslist))+')' 
    
    --=============================================================================================
    -- Construct insert statement
    --=============================================================================================
      
    set @query += 'IF NOT EXISTS (SELECT * FROM ['+@TableSchema+'].['+@TableName+'] '
    set @query += 'WHERE ['+@primaryKey+'] = ' + cast(@UnknownKeyValue as varchar(50)) + ')' 
    set @query += ' begin' 
    set @query += ' set identity_insert ['+@TableSchema+'].['+@TableName+'] ON' 
    set @query += ' INSERT INTO ['+@TableSchema+'].['+@TableName+']' + @ColumnListing
    set @query += ' VALUES ' + @ValuesList
    set @query += ' set identity_insert ['+@TableSchema+'].['+@TableName+'] OFF' 
    set @query += ' end' 

    --=============================================================================================
    -- Script or Execute
    --=============================================================================================
    if(@Action = 'Script') 
    begin 
      print @query 
    end 
    else 
    begin 
      exec (@query) 
    end
  end try
  
  begin catch
    declare @errmsg varchar(2048) = error_message()
    raiserror (@errmsg, 16,1)  
  end catch

GO


