
/*
	DEMO 1 -- Shows a list of Employees that have worked in more than one department using a Self Join.
	In this example a self join is used along with a non equi join (ed1.DepartmentID <> ed2.DepartmentID)
*/

-- SELF JOIN
-- NON EQUI JOIN
USE AdventureWorks2016;

SET STATISTICS IO ON
SET STATISTICS TIME ON

-- DEMO 1 - SHOW THE DATA
		SELECT * 
		FROM [HumanResources].[EmployeeDepartmentHistory]
		--WHERE BusinessEntityID = 4

-- DEMO 2 -- SELF JOIN WITH NON EQUI JOIN
SELECT DISTINCT
	   ED1.[BusinessEntityID]
      ,ED2.[DepartmentID]
FROM [HumanResources].[EmployeeDepartmentHistory] ED1
JOIN [HumanResources].[EmployeeDepartmentHistory] ED2
ON	ED1.BusinessEntityID = ED2.BusinessEntityID AND
	ED1.DepartmentID <> ED2.DepartmentID

-- DEMO 3 -- VALIDATION
SELECT * 
FROM [HumanResources].[EmployeeDepartmentHistory]
WHERE BusinessEntityID = 4

