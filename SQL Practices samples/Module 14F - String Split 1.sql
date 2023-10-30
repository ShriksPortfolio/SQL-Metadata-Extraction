-- SPLIT Function
-- https://msdn.microsoft.com/en-us/library/mt684588.aspx

-- STRING_SPLIT (TABLE VALUE FUNCTION)
SELECT * FROM STRING_SPLIT('THIS IS A TEST', ' ')

/*
	In this example we use the String_Split function inside a stored procedure
	that accepts a comma separated list as a stored procedure.

	This is a great use case for SSRS.
*/

USE AdventureWorks2016;

IF OBJECT_ID('usp_SubcategoryList') IS NOT NULL
DROP PROCEDURE usp_SubcategoryList;
GO

-- CREATE STORED PROCEDURE THAT PARSES THE INPUT PARAMETER.
CREATE PROC usp_SubcategoryList 
(@Subcategories VARCHAR(300))
AS
	SELECT LTRIM(value) Subcategory FROM string_split(@Subcategories, ',')

-- EXECUTE THE STORED PROCEDURE PASSING IN A COMMA DELIMITED LIST OF VALUES
EXEC usp_SubcategoryList 'Mountain-Bikes, Road-Bikes, Touring-Bikes'