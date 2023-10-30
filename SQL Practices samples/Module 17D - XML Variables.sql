-- XML can be easily stored and accessed through variables.

-- DEMO 1 -- SET @XML Variable to simple XML script.

USE AdventureWorks2016;

DECLARE @XML AS XML

SELECT @XML = 
	(SELECT
		ProductID,
		Name,
		ProductNumber,
		ListPrice
	FROM Production.Product
	FOR XML PATH ('Product'))

SELECT @XML