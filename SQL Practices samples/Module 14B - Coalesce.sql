/* ======= COMMA DELIMITED LIST WITH COALESCE ======== */

IF OBJECT_ID('TempDB.dbo.#CommaDelimitedList') IS NOT NULL
DROP TABLE #CommaDelimitedList
CREATE TABLE #CommaDelimitedList (FCT_DT DATE)
INSERT INTO #CommaDelimitedList VALUES ('1/1/2016'), ('2/1/2016'), ('3/1/2016'), ('4/1/2016'), ('5/1/2016'), ('6/1/2016')
SELECT * FROM #CommaDelimitedList


/*
		COALESCE(@COLUMNNAME + 'WHATEVER', '')	
*/



DECLARE @CommaDelimitedList varchar(4000);

	SELECT 
		@CommaDelimitedList = 
		COALESCE(@CommaDelimitedList + ', ', '') + CAST(FCT_DT AS varchar)   --+ CHAR(13) + CHAR(10) 
	FROM 
		#CommaDelimitedList

PRINT @CommaDelimitedList

