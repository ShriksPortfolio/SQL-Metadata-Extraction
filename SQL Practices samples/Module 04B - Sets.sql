/* ====== PSEUDO CODE ======
	{ <query_specification> | ( <query_expression> ) } 
	{ UNION | EXCEPT | INTERSECT }
	{ <query_specification> | ( <query_expression> ) }
*/

USE AdventureWorksDW2016;

-- DEMO 1
	SELECT ProductKey
	FROM DimProduct
		EXCEPT
	SELECT ProductKey
	FROM FactInternetSales;

-- DEMO 2 -- UNDERSTANDING PRECEDENCE
-- Intersect has the highest precedence here and will be evaluated first.

	SELECT ProductKey
	FROM DimProduct
		EXCEPT
	SELECT ProductKey
	FROM FactInternetSales
		INTERSECT 
	SELECT ProductKey
	FROM FactResellerSales;

-- DEMO 2B -- USING PARENTHESES
-- This gives Except the Precedence and now the results are significantly different.

	(SELECT ProductKey
	FROM DimProduct
		EXCEPT
	SELECT ProductKey
	FROM FactInternetSales)
		INTERSECT 
	SELECT ProductKey
	FROM FactResellerSales;

-- DEMO 3 -- UNION ALL
SELECT 'UK', NULL, 'LONDON' 
	UNION ALL
SELECT 'USA', NULL, 'NEW YORK'
	UNION ALL
SELECT 'UK', NULL, 'LONDON' 

-- DEMO 3 -- UNION 
-- REMOVES DUPLICATE VALUES AUTOMATICALLY
SELECT 'UK', NULL, 'LONDON' 
	UNION 
SELECT 'USA', NULL, 'NEW YORK'
	UNION 
SELECT 'UK', NULL, 'LONDON' 
