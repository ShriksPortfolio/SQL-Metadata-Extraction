-- SET UP
USE AdventureWorks2016;

IF OBJECT_ID('TempDB.dbo.#Employee') IS NOT NULL
DROP TABLE #Employee

CREATE TABLE #Employee (EmployeeID INT, BusinessPhone varchar(20), PersonalPhone varchar(20), CellPhone varchar(20))

INSERT INTO #Employee (EmployeeID, BusinessPhone, PersonalPhone, CellPhone)
VALUES
	(1, '123-987-6543', '231-789-3456', '312-897-5643'),
	(2, '321-978-6534', '132-798-5634', '213-879-3564')

SET STATISTICS IO ON
SET STATISTICS TIME ON

-- DEMO
SELECT EmployeeID, 'Business' PhoneType, BusinessPhone AS PhoneNumber
FROM #Employee
UNION ALL 
SELECT EmployeeID, 'Personal' PhoneType, PersonalPhone AS PhoneNumber
FROM #Employee
UNION ALL
SELECT EmployeeID, 'Cell' PhoneType, CellPhone AS PhoneNumber
FROM #Employee
--ORDER BY EmployeeID

-- NOW COMPARE THE TWO AT THE SAME TIME WITH AN EXECUTION PLAN
-- UNION ALL EXAMPLE SCANS THE TABLE 3 TIMES WHEREAS UNPIVOT ONLY SCANS THE TABLE ONCE yielding a more efficient plan.


SELECT	pvt.EmployeeID, pvt.PhoneType, pvt.PhoneNumber
FROM	#Employee
		UNPIVOT (PhoneNumber
					FOR PhoneType
						IN (BusinessPhone, PersonalPhone, CellPhone)) AS PVT;