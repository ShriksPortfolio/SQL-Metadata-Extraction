
-- First get the database names
USE master;
GO

SELECT Name AS DatabaseName
FROM sysdatabases

-- Second Filter out system databases
SELECT Name AS DatabaseName
FROM sysdatabases
WHERE Name NOT IN ('Master', 'TempDB', 'Model', 'MSDB', 'PWInsurance', 'PWInsuranceDW')

-- Database backup script
-- Generate backup script from GUI removing excess parameters... 
BACKUP DATABASE [AdventureWorks2016] 
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\AdventureWorks2016.bak' 
GO

-- CREATE THE VARIABLES
DECLARE @PATH				VARCHAR(256)	= 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\'
DECLARE @DatabaseName		VARCHAR(50)	
DECLARE @QualifiedFileName  VARCHAR(256) 

-- CREATE LIST OF DATABASES USING A CURSOR
-- PRINT DATABASE NAME AND FILE NAME
DECLARE DatabaseList CURSOR 

FORWARD_ONLY
FOR
	SELECT Name AS DatabaseName
	FROM sysdatabases
	WHERE Name NOT IN ('Master', 'TempDB', 'Model', 'MSDB', 'PWInsurance', 'PWInsuranceDW')

OPEN DatabaseList
	
FETCH NEXT FROM DatabaseList INTO @DatabaseName

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @QualifiedFileName = @PATH + @DatabaseName + '.BAK'
	
	-- PRINT TO TEST THE SCRIPT
	PRINT @QualifiedFileName

	---- UNCOMMENT BELOW LINE TO RUN BACKUP SCRIPTS
	--BACKUP DATABASE @DatabaseName 
	--TO  DISK = @QualifiedFileName 

	PRINT @DatabaseName + ' Backed up Succesfully at ' + CONVERT(VARCHAR, GETDATE())

Fetch Next from DatabaseList into @DatabaseName

End
Close DatabaseList
Deallocate DatabaseList