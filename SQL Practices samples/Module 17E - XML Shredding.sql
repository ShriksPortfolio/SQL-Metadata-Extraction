-- DEMO 1 -- Use OPENROWSET TO ACCESS AN XML FILE. 
	-- This will load the XML into one large rowset into a single row and a single column.

/* 
	OPENXML (Handle, XPATH, FLAG (ATT/ELEMENT))
	WITH (
		COLUMNS) TO RETURN
	sp_xml_prepareddocument (Stores XML Document in Memory, accepts two parameters 
		(First is an output XML Document, Second is input XML)
	sp_xml_removedocument (Removes DOM from Memory)
*/

/*
	Module 17E - Load XML into variable and shred the XML using OPENXML Function.
	Module 17F - Load XML from document using OPENROWSET.
*/
-- =========== MODULE 1 ===========--

-- DEMO 1 -- Load an XML Variable, Prepare the XML document, Select From Document using OPEN XML
-- Query will return NULL because flag has been selected.

USE AdventureWorks2016;

DECLARE @DOC AS INT
DECLARE @XML AS XML

SELECT @XML = 
	(
	SELECT
		ProductID,
		Name,
		ProductNumber,
		ListPrice,
		ModifiedDate
	FROM Production.Product
	FOR XML PATH ('Product'), ROOT ('ProductList')
	)
	
EXEC sp_xml_preparedocument @DOC OUTPUT, @XML

SELECT * 
FROM OPENXML(@DOC, '/ProductList/Product')
WITH(
	ProductID		INT,
	Name			VARCHAR(100),
	ProductNumber	VARCHAR(50),
	ListPrice		FLOAT,
	ModifiedDate	Date
	)

EXEC sp_xml_removedocument @DOC

-- DEMO 2 -- Select a Flag (1 for Attributes, 2 for Elements, 3 for both)
-- Make ProductID an Attribute and it is now  returned as NULL
-- Show FLAG 3 - Attributes Field and Elements Fields
-- @ alias is used to reference Attibutes.

DECLARE @DOC AS INT
DECLARE @XML AS XML

SELECT @XML = 
	(
	SELECT
		ProductID AS [@ProductID],
		Name,
		ProductNumber,
		ListPrice,
		ModifiedDate
	FROM Production.Product
	FOR XML PATH ('Product'), ROOT ('ProductList')

	)
	
EXEC sp_xml_preparedocument @DOC OUTPUT, @XML

SELECT * 
FROM OPENXML(@DOC, '/ProductList/Product', 2)
WITH(
	ProductID		INT,
	Name			VARCHAR(100),
	ProductNumber	VARCHAR(50),
	ListPrice		FLOAT,
	ModifiedDate	Date
	)

EXEC sp_xml_removedocument @DOC

-- DEMO 3 -- Change the paths for ModifiedDate, ListPrice and ProductNumber to ProductInfo/<Element>. 
-- Now they return Null, this is because they do not match our XPATH parameter in the OPENXML function.
-- NEXT change the XPATH to point to ProductInfo -- notice that two columns are NULL and the other three work now.
-- NEXT Show how we can navigate back a level. (../)
-- PRODUCTID is still NULL, now show how we can use the @ symbol to specify that it is an attribute.

DECLARE @DOC AS INT
DECLARE @XML AS XML

SELECT @XML = 
	(
	SELECT
		ProductID		AS [@ProductID],
		Name,
		ProductNumber	AS [ProductInfo/ProductNumber],
		ListPrice		AS [ProductInfo/ListPrice],
		ModifiedDate	AS [ProductInfo/ModifiedDate]
	FROM Production.Product
	FOR XML PATH ('Product'), ROOT ('ProductList')

	)
	
EXEC sp_xml_preparedocument @DOC OUTPUT, @XML

SELECT * 
FROM OPENXML(@DOC, '/ProductList/Product/ProductInfo', 3)
WITH(
	ProductID		INT				'../@ProductID',
	Name			VARCHAR(100)	'../Name',
	ProductNumber	VARCHAR(50),
	ListPrice		FLOAT,
	ModifiedDate 	Datetime	 
	)

EXEC sp_xml_removedocument @DOC
