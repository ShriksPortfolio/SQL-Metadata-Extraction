/*
	In this example a result set is created that contains a record for each employee
	for each date. For example
		Mitchell  1/1/2008
		Mitchell  1/2/2008
		Mitchell  1/3/2008
		....
*/

USE AdventureWorksDW2016;

SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT		EmployeeKey, FirstName, dd.FullDateAlternateKey
FROM		DimEmployee de
CROSS JOIN	DimDate dd
WHERE dd.FullDateAlternateKey BETWEEN '1/1/2008' AND '1/10/2008'
ORDER BY EmployeeKey

-- ALTERNATIVE METHOD (APPLY)
-- SQL Server Optimizer creates the same plan for both queries.
SELECT		EmployeeKey, FirstName, dd.FullDateAlternateKey
FROM		DimEmployee de
CROSS APPLY	DimDate dd
WHERE dd.FullDateAlternateKey BETWEEN '1/1/2008' AND '1/10/2008'
ORDER BY EmployeeKey



