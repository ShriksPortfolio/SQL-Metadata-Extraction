USE AdventureWorks2016;

-- SETUP - CREATE A TEMP TABLE THAT HAS DATA WE CAN SPLIT FOR THIS MODULE.

			IF OBJECT_ID('TempDB.dbo.#StringSplitDemo') IS NOT NULL
			DROP TABLE   #StringSplitDemo
			CREATE TABLE #StringSplitDemo (ProductCategory VARCHAR(50),ProductSubcategories VARCHAR(1000))

			-- GET LIST OF CATEGORIES AND CATEGORY IDs
			INSERT INTO #StringSplitDemo (ProductCategory, ProductSubcategories)

			SELECT pc.Name Category, 
				STUFF((SELECT ', ' + psc.Name
					   FROM Production.ProductSubcategory psc 
					   WHERE psc.ProductCategoryID = pc.ProductCategoryID 
					  FOR XML PATH('')), 1, 2, '')								 AS Subcategory
			FROM Production.ProductCategory pc
			GROUP BY pc.Name, pc.ProductCategoryID

-- LOOK AT DATA THAT HAS BEEN POPULATED
			SELECT * FROM #StringSplitDemo


-- DEMO STRING_SPLIT using CROSS APPLY
SELECT ProductCategory, LTRIM(value) as Subcategory
FROM #StringSplitDemo
CROSS APPLY string_split(ProductSubcategories, ',')

