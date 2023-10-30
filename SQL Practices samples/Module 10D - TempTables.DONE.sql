/*
Temp tables have 2 variations Local and Global
Local temp tables are only available to the current connection session where they are created. 
Temp tables can be created in several ways. They are created in the TEMPDB by using a single "#" designation.
Temp tables will remain available with the data that is populated for the length of the session or until they are deleted. 
TEMP Tables that are used in stored procedures are automatically drop at the end of the SP execution	
*/

/*--------------------------------------------Local TEMP Tables---------------------------------------------*/

-- You may define a Local TEMP table as you would a permanent table with each colum definiton and then insert records.

CREATE TABLE #MyTempTable (BusinessEntityID int, FirstName varchar(100))

INSERT INTO #MyTempTable (BusinessEntityID,FirstName) VALUES (1,'Ken')
INSERT INTO #MyTempTable (BusinessEntityID,FirstName) VALUES (2,'Terri')
INSERT INTO #MyTempTable (BusinessEntityID,FirstName) VALUES (3,'Roberto')

--View Data
SELECT * FROM #MyTempTable

-- NOTE YOU CANNOT QUERY THIS TEMP TABLE FROM ANOTHER SESSION WINDOW. 

-- NOW DROP THE TABLE AND SHOW IT WITHIN THE CONTEXT OF A STORED PROCEDURE.
DROP TABLE #MyTempTable

IF OBJECT_ID ('usp_Customers') IS NOT NULL
DROP PROCEDURE usp_Customers; 
GO

CREATE PROC usp_Customers 
AS
BEGIN	
	CREATE TABLE #MyTempTable (BusinessEntityID int, FirstName varchar(100))

		INSERT INTO #MyTempTable (BusinessEntityID,FirstName) VALUES (1,'Ken')
		INSERT INTO #MyTempTable (BusinessEntityID,FirstName) VALUES (2,'Terri')
		INSERT INTO #MyTempTable (BusinessEntityID,FirstName) VALUES (3,'Roberto')

	SELECT * FROM #MyTempTable
END


-- EXECUTE STORED PROC (After procedure is run the temp table is dropped immediately.)
EXECUTE usp_Customers

-- SELECT FROM TEMP TABLE
SELECT * FROM #MyTempTable

--You can see the table is created in the TempDB
SELECT * FROM tempdb..sysobjects WHERE name LIKE '#MyTempTable%'

---Tools--
--Use system views
SELECT name, create_date FROM TempDB.sys.tables WHERE name LIKE '#%'

--Use sysobjects
SELECT * FROM tempdb..sysobjects WHERE name like '#MyTempTable%'

-- Use Information Schema
SELECT * FROM TempDB.information_schema.tables



--2. You can also create a TEMP Table by selecting data directly into it from the source objects. 
-- The default column definitions will match the source table column definitions
SELECT TOP 10 BusinessEntityID, EmailAddress 
INTO #MyTempTable2 FROM Person.EmailAddress order by BusinessEntityID


--Local TEMP Tables and Global TEMP tables can be indexed for optimization

CREATE NONCLUSTERED INDEX idx1 ON #MyTempTable(BusinessEntityID)
CREATE NONCLUSTERED INDEX idx2 ON #MyTempTable2(BusinessEntityID)


--To delete a Local TEMP Table close the connection session that created it or explicitly drop the TEMP Tables
DROP TABLE #MyTempTable
DROP TABLE #MyTempTable2

/*----------------------------------------GLOBAL TEMP TABLES--------------------------------------------*/

--Global Temp tables are very similar to local TEMP tables
--Global TEMP Tables are designated by 2 "##" in front of the table name
--Global TEMP Table names must be unique across all connections
--The biggest difference between a global TEMP table and a Local TEMP Table is that with a Global TEMP table any 
--session that is connected to the server where the Global TEMP table was created can view and query the TEMP object. 
--Gloabl TEMP tables are automatically dropped after the LAST connection session accessing the Global TEMP Table is closed 

--Method 1 - Define the table then insert records
CREATE TABLE ##MyGlobalTempTable (BusinessEntityID int, FirstName varchar(100))

INSERT INTO ##MyGlobalTempTable (BusinessEntityID,FirstName) VALUES (1,'Ken')
INSERT INTO ##MyGlobalTempTable (BusinessEntityID,FirstName) VALUES (2,'Terri')
INSERT INTO ##MyGlobalTempTable (BusinessEntityID,FirstName) VALUES (3,'Roberto')

--View Data
SELECT * FROM ##MyGlobalTempTable

--Method 2 - Select data directly into the Global TEMP Table
SELECT TOP 10 BusinessEntityID, EmailAddress INTO ##MyGlobalTempTable2 FROM Person.EmailAddress order by BusinessEntityID

--Must drop Global TEMP tables as they will remain in TEMDB
DROP TABLE ##MyGlobalTempTable
DROP TABLE ##MyGlobalTempTable2







