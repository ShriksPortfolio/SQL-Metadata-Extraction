-- Generating XML from SQL Server tables

--  DEMO 1 -- SHOW TABLE
USE AdventureWorks2016;

SELECT
	ProductID,
	Name,
	ProductNumber,
	ListPrice
FROM 
	Production.Product

-- DEMO 2 -- SHOW AUTO MODE
SELECT
	ProductID,
	Name,
	ProductNumber,
	ListPrice
FROM Production.Product
FOR XML AUTO

-- DEMO 3 -- Add Row Tag Name
-- Show Error, Row Tag Name is only allowed with RAW or PATH mode.
-- If you want to change the ROW TAG name just alias the table accordingly... AS Product
SELECT
	ProductID,
	Name,
	ProductNumber,
	ListPrice
FROM Production.Product 
FOR XML AUTO ('Product')

-- DEMO 4- Convert Fragments to Document by adding a single root node.

SELECT
	ProductID,
	Name,
	ProductNumber,
	ListPrice
FROM Production.Product Product
FOR XML AUTO, ROOT ('ProductList')

-- DEMO 5 -- The order of columns matter, especially with Element Centric / Nested XML.
-- Join to ProductSubCategory
-- Notice how AUTO automatically picked up and nested the elements.
SELECT
	ProductID,
	Product.Name,
	Subcategory.Name AS Subcategory,
	Subcategory.ProductSubcategoryID,
	ProductNumber,
	ListPrice
FROM Production.Product				AS Product
JOIN Production.ProductSubcategory	AS Subcategory
ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
FOR XML AUTO, ROOT ('ProductList')

-- DEMO 5B -- Change the order of columns and move Subcategory to the top.
SELECT
	Subcategory.Name AS Subcategory,
	Subcategory.ProductSubcategoryID,
	ProductID,
	Product.Name,
	ProductNumber,
	ListPrice
FROM Production.Product				AS Product
JOIN Production.ProductSubcategory  AS Subcategory
ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
FOR XML AUTO, ROOT ('ProductList')

-- DEMO 6 -- Show how selecting which column matters.
-- By selecting the ProductSubcategoryID from the product table it now becomes an attribute of
-- product instead of Subcategory. 

SELECT
	Subcategory.Name AS Subcategory,
	Product.ProductSubcategoryID,			-- SubcategoryID from Product table.
	ProductID,
	Subcategory.Name,
	ProductNumber,
	ListPrice
FROM Production.Product				AS Product
JOIN Production.ProductSubcategory	AS Subcategory
ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
FOR XML AUTO, ROOT ('ProductList')

-- DEMO 6B -- ORDER BY is important when generating XML. 
-- Evaluate the XML generated with and without ORDER BY.
-- A proper ORDER BY Clause is very important becuase you are formatting the XML. Without the ORDER BY clause
-- you can get an unexpected XML document with an element repeated multiple times with just part of the nested 
-- elements every time. The order of the rows returned is also unpredictable.

SELECT
	Subcategory.Name					AS Subcategory,
	Subcategory.ProductSubcategoryID,
	ProductID,
	Subcategory.Name,
	ProductNumber,
	ListPrice
FROM Production.Product				AS Product
JOIN Production.ProductSubcategory	AS Subcategory
ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
--ORDER BY Subcategory.ProductSubcategoryID, ProductID
FOR XML AUTO, ROOT ('ProductList')

-- DEMO 6C -- THIS RESULT IS ATTRIBUTE CENTRIC. 
-- ADD THE ELMENTS Directive to make it Element Centri XML
SELECT
	Subcategory.Name		AS Subcategory,
	Subcategory.ProductSubcategoryID,
	ProductID,
	Subcategory.Name,
	ProductNumber,
	ListPrice
FROM Production.Product				AS Product
JOIN Production.ProductSubcategory	AS Subcategory
ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
ORDER BY Subcategory.ProductSubcategoryID, ProductID
FOR XML AUTO, ELEMENTS, ROOT ('ProductList')


-- DEMO 7 -- Return the XSD Schema using the XMLSCHEMA directive.
-- Use WHERE 0 = 1. No rows will be returned and we simply get the metadata.

SELECT
	Subcategory.Name AS Subcategory,
	Subcategory.ProductSubcategoryID,
	ProductID,
	Subcategory.Name,
	ProductNumber,
	ListPrice
FROM Production.Product				AS Product
JOIN Production.ProductSubcategory	AS Subcategory
ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
WHERE 0=1
ORDER BY Subcategory.ProductSubcategoryID, ProductID
FOR XML AUTO, ROOT ('ProductList'),
XMLSCHEMA ('ProductList')
