USE AdventureWorks2016;
-- The following code creates a comma separated list in a GROUP BY SCENARIO.

SELECT pc.Name Category,  
    STUFF((SELECT ', ' + psc.Name
           FROM Production.ProductSubcategory psc 
           WHERE psc.ProductCategoryID = pc.ProductCategoryID 
          FOR XML PATH('')), 1, 2, '') AS Subcategory
FROM Production.ProductCategory pc
GROUP BY pc.Name, pc.ProductCategoryID


-- XML PATH
-- First generate XML Fragments
	
		SELECT ', ' + psc.Name
        FROM Production.ProductSubcategory psc 
        FOR XML PATH

-- NEXT REMOVE THE XML TAGS BY REPLACING THE TAG NAME WITH AN EMPTY STRING('')
		SELECT ', ' + psc.Name
        FROM Production.ProductSubcategory psc 
        FOR XML PATH('') -- REPLACE TAG NAME WITH EMPTY STRING.


-- Next Remove the XML Tags returning only a row of text data.
-- Use the STUFF function to remove the first two characters.
		SELECT STUFF((
			SELECT ', ' + psc.Name
			FROM Production.ProductSubcategory psc 
			FOR XML PATH('')), 1, 2, '') AS Subcategory

-- FINAL RESULT
SELECT pc.Name Category,  
    STUFF((SELECT ', ' + psc.Name
           FROM Production.ProductSubcategory psc 
           WHERE psc.ProductCategoryID = pc.ProductCategoryID 
          FOR XML PATH('')), 1, 2, '') AS Subcategory
FROM Production.ProductCategory pc
GROUP BY pc.Name, pc.ProductCategoryID


