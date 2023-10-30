/* Demo how CHECKSUM works */
USE AdventureWorks2016;

	SELECT CHECKSUM(Name, ProductNumber, Color)		AS  CHECKColumn, Name, ProductNumber, Color
	FROM Production.Product

-- CHECKSUM IS NOT CASE SENSITIVE (unlike hashbytes)
SELECT CHECKSUM('MITCHELL', 'G', 'PEARSON') -- 493637671
SELECT CHECKSUM('MITCHELL', 'g', 'PEARSON') -- 493637671

SELECT HASHBYTES('SHA', 'Mitchell' + 'G' + 'Pearson')
SELECT HASHBYTES('SHA', 'Mitchell' + 'G' + 'Pearson' + NULL)
SELECT HASHBYTES('SHA', 'Mitchell' + 'G' + 'Pearson' + COALESCE(NULL, 'NA'))
SELECT HASHBYTES('SHA', 'MitchellG' + 'Pearson' + COALESCE(NULL, 'NA'))
SELECT HASHBYTES('SHA', 'Mitchellg' + 'Pearson' + COALESCE(NULL, 'NA'))
SELECT HASHBYTES('SHA', 'Mitchell' + '|' + 'G' + '|' +'Pearson' + COALESCE(NULL, 'NA'))
/* Change a Value in the table and show how the results change */
--UPDATE Production.Product
--SET Color = 'Red'
--WHERE ProductNumber = 'AR-5381'

/* Demo how HASHBYTES works */
SELECT 
	HASHBYTES('SHA',ISNULL(Name,'Unknown')			+' | '+ 
					ISNULL(ProductNumber,'Unknown')	+' | '+ 
					ISNULL(Color,'Unknown'))				AS HASHColumn, 
	Name, 
	ProductNumber, 
	Color
FROM Production.Product