
USE AdventureWorks2016;
GO

-- DEMO 1 -- SHOW PATH MODE
SELECT
	ProductID,
	Name,
	ProductNumber,
	ListPrice
FROM Production.Product
FOR XML PATH

-- DEMO 2 -- Change Tag Name
SELECT
	ProductID,
	Name,
	ProductNumber,
	ListPrice
FROM Production.Product
FOR XML PATH ('Product')


-- DEMO 3 -- ADD ROOT TAG -- USE ROOT CLAUSE
-- XML PATH mode is element centric.

SELECT
	ProductID,
	Name,
	ProductNumber,
	ListPrice,
	ModifiedDate
FROM Production.Product
FOR XML PATH ('Product'), ROOT ('ProductList')

-- DEMO 4 -- TURN A COLUMN INTO AN ATTRIBUTE USING XPATH
-- @ is used to turn an element into an attribute.
-- (/) is used to to define hierarchies and levels for where the element / attribute will be displayed at.

SELECT
	ProductID	 AS [@ProductID],
	Name,
	ProductNumber	[ProductDetails/ProductNumber],
	ListPrice		[ProductDetails/ListPrice],
	ModifiedDate	
FROM Production.Product
FOR XML PATH ('Product'), ROOT ('ProductList')

-- DEMO 4B -- XPATH -- Add ModifiedDate as an Attribute in a hierarchy.
-- First try to add it as an attribute in the last position.
-- Second move the Modified Date up below the Name column.

SELECT
	ProductID	 AS [@ProductID],
	Name,
	ModifiedDate	[ProductDetails/@ModifiedDate], -- Add it after Name.
	ProductNumber	[ProductDetails/ProductNumber],
	ListPrice		[ProductDetails/ListPrice]
FROM Production.Product
FOR XML PATH ('Product'), ROOT ('ProductList')


-- DEMO 5 -- FOR XML Path also supports subqueries so you can have nested XML output.
-- STEP 1 -- CONSTRUCT XML FOR SUBCATEGORY

SELECT 
	PSC.ProductSubcategoryID AS [@ProductSubcategoryID],
	PSC.Name AS [@Name]
FROM
	Production.ProductSubcategory PSC
FOR XML PATH ('Subcategory'), ROOT ('ProductSubcategories')

-- STEP 2 -- ADD NESTED CORRELATED SUBQUERY
-- The results of the subquery are returned as a string not xml.

SELECT 
	PSC.ProductSubcategoryID AS [@ProductSubcategoryID],
	PSC.Name AS [@Name],
	(SELECT
		ProductID,
		Name,
		ProductNumber,
		ListPrice,
		ModifiedDate
	 FROM Production.Product PRD
	 WHERE PRD.ProductSubcategoryID = PSC.ProductSubcategoryID
	 FOR XML PATH ('Product'), ROOT ('ProductList')) 
FROM
	Production.ProductSubcategory PSC
FOR XML PATH ('Subcategory'), ROOT ('Subcategories')


-- DEMO 6 -- Cast Results of Subquery as an XML data type
-- ALSO add the Order By Clause

SELECT 
	PSC.ProductSubcategoryID AS [@ProductSubcategoryID],
	PSC.Name AS [@Name],
		(SELECT
			ProductID,
			Name,
			ProductNumber,
			ListPrice,
			ModifiedDate
		 FROM Production.Product P
		 WHERE P.ProductSubcategoryID = PSC.ProductSubcategoryID
		 ORDER BY P.ProductID
		 FOR XML PATH ('Product'), ROOT ('Products'), TYPE)
FROM
	Production.ProductSubcategory PSC
ORDER BY PSC.ProductSubCategoryID
FOR XML PATH ('Subcategory'), ROOT ('Subcategories')







