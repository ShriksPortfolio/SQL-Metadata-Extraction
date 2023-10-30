/* ====== Patindex FIND PATTERNS IN A STRING ====== */
-- DEMO 1

SELECT PATINDEX('%BOB%', 'Where did bob go?')

-- DEMO 2
/*
	IF OBJECT_ID('TempDB.dbo.#FileNames') IS NOT NULL
	DROP TABLE #FileNames

	CREATE TABLE #FileNames (FileName varchar(100), FileDate date null)
	INSERT INTO #FileNames (FileName)
		VALUES	('\\10.123.345.678\SRC_FOLDER\WRK_FOLDER\FILES\Internet_Sales\20150727_ABC_InternetSales.csv'),
				('\\10.123.345.678\SRC_FOLDER\WRK_FOLDER\FILES\Reseller_Sales\ResellerSales_20150727_DEF.csv'),
				('\\10.123.345.678\SRC_FOLDER\CORPORATE_20160109.xlsx')
	SELECT * FROM #FileNames
*/

	SELECT 
		FileName,
		SUBSTRING(
			FileName,														-- String / Expression	
			patindex('%[2][0][0-9][0-9][0-9][0-9][0-9][0-9]%', FileName),	-- Dynamically determine starting position. Look for 8 characters 
			8)																-- Number of characters to substring.
	FROM
		#FileNames