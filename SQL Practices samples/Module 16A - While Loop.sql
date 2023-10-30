USE AdventureworksDW2016;
GO

DECLARE @Counter	AS INT = 0
DECLARE @StartDate  AS DATE = '1/15/2008'
DECLARE @ProcessDate AS DATE 

WHILE @Counter < 10
		BEGIN
				SELECT @ProcessDate = dd.FullDateAlternateKey 
				FROM DimDate		dd 
				WHERE FullDateAlternateKey = @StartDate

			PRINT @ProcessDate
			PRINT @Counter
		
			SET @counter = @counter + 1
			SET @StartDate = DATEADD(dd, -1, @StartDate)
		END