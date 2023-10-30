-- DEMO 1 -- Accessing an .XML file using OPENROWSET
-- Selecting from the Document directly returns binary data. This can be stored in an XML Variable.

USE AdventureWorks2016;

SELECT AllXML
FROM OPENROWSET (BULK 'C:\Advanced TSQL\Module Resources\Module 18\ProductList.xml', SINGLE_BLOB) AS ProductList(AllXML)

-- DEMO 2 - Store into an XML Variable
DECLARE @XML AS XML
DECLARE @DOC AS INT

SELECT @XML = 
	AllXML
	FROM OPENROWSET (BULK 'C:\Advanced TSQL\Module Resources\Module 18\ProductList.xml', SINGLE_BLOB) AS ProductList(AllXML)

EXEC sp_xml_preparedocument @DOC OUTPUT, @XML

SELECT *
FROM OPENXML (@DOC, '/ProductList/Product', 3)
WITH (
		ProductID		INT,
		Name			VARCHAR(100),
		ProductNumber	VARCHAR(50),
		ListPrice		FLOAT,
		ModifiedDate	Date
	)

EXEC sp_xml_removedocument @DOC

-- DEMO 3 --Insert the XML document into an SQL table.

DECLARE @XML AS XML
DECLARE @DOC AS INT

SELECT @XML = 
	AllXML
	FROM OPENROWSET (BULK 'C:\Advanced TSQL\Module Resources\Module 18\ProductList.xml', SINGLE_BLOB) AS ProductList(AllXML)

EXEC sp_xml_preparedocument @DOC OUTPUT, @XML

SELECT *
INTO Module17_XML								--Insert into a table
FROM OPENXML (@DOC, '/ProductList/Product', 3)
WITH (
		ProductID		INT,
		Name			VARCHAR(100),
		ProductNumber	VARCHAR(50),
		ListPrice		FLOAT,
		ModifiedDate	Date
	)

EXEC sp_xml_removedocument @DOC

/*
	SELECT * FROM Module17_XML
	
	IF OBJECT_ID('Module17_XML') IS NOT NULL
	DROP TABLE Module17_XML

 */