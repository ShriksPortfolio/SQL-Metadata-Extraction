
/*
	XML Raw - In RAW mode every row from returned rowsets converts to a single element named row,
	and columns translate to attributes of this element.

	This will most closely resemble a table.
*/

-- DEMO 1 -- SHOW Basic data in Production.Product table.
USE AdventureWorks2016;

	SELECT
		[ProductID], [Name], [ProductNumber], [Color]
	FROM
		Production.Product

-- DEMO 2 
-- SIMPLE XML Raw query.
-- These are Fragments and it is not yet a well formatted XML Document. 

SELECT
	[ProductID], [Name], [ProductNumber], [Color]
FROM
	Production.Product
FOR XML RAW

-- DEMO 3 - Name the Row, Add a root to make it a document.
-- Name the Row, change it to Product.
-- Add ROOT to make it well formatted.

SELECT
	[ProductID], [Name], [ProductNumber], [Color]
FROM
	Production.Product
FOR XML RAW('Product'), ROOT ('ProductList')

-- DEMO 4
-- ELEMENTS directive. Here we can use the ELEMENTS directive to create ELEMENT centric XML 
-- rather than Attribute centric.
-- Elements directive works with RAW and AUTO modes only.

SELECT
	[ProductID], [Name], [ProductNumber], [Color] 
FROM
	Production.Product 
FOR XML RAW('Product'), ELEMENTS, ROOT ('ProductList')

-- DEMO 5
-- Join to Sales.SalesOrderDetail and show that there is no nesting here. ProductID is repeated.
SELECT
	P.[ProductID], sod.SalesOrderID, [Name], [ProductNumber], [Color]
FROM
	Production.Product P
JOIN
	Sales.SalesOrderDetail SOD
ON P.ProductID = SOD.ProductID
WHERE p.ProductID = 707
FOR XML RAW('Product'), ROOT ('ProductList')

-- DEMO 6
-- ELEMENTS - Now use the ELEMENTS key word to make the XML element centric.
SELECT
	P.[ProductID], sod.SalesOrderID, [Name], [ProductNumber], [Color]
FROM
	Production.Product P
JOIN
	Sales.SalesOrderDetail SOD
ON P.ProductID = SOD.ProductID
FOR XML RAW('Product'), ELEMENTS,ROOT ('ProductList')