-- https://msdn.microsoft.com/en-us/library/ms177562.aspx

SELECT 10 / (10 - 10)
	
-- NULLIF ( expression , expression ) 
SELECT 10 / NULLIF((10 - 10), 0)

