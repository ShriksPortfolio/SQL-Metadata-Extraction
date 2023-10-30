/* ====== CTEs RECURSIVE - Navigate Hierarchy ====== */

-- https://technet.microsoft.com/en-us/library/ms186243(v=sql.105).aspx

USE AdventureWorks2016;
GO

IF OBJECT_ID('TempDB.dbo.#MyEmployees') IS NOT NULL
DROP TABLE #MyEmployees


CREATE TABLE #MyEmployees
(
	EmployeeID smallint NOT NULL,
	FirstName nvarchar(30)  NOT NULL,
	LastName  nvarchar(40) NOT NULL,
	Title nvarchar(50) NOT NULL,
	DeptID smallint NOT NULL,
	ManagerID int NULL,
 CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
);
-- Populate the table with values.
INSERT INTO #MyEmployees VALUES 
 (1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL)
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273)
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274)
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274)
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273)
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285)
,(16,  N'David',N'Bradley', N'Marketing Manager', 4, 273)
,(23,  N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);

select * from #MyEmployees;

WITH DirectReports --(ManagerID, EmployeeID, Title, DeptID, Level)
AS
(
	-- ANCHOR MEMBER
		SELECT e.ManagerID, e.EmployeeID, e.Title, edh.DepartmentID AS DeptID, 0 AS Level
		FROM #MyEmployees AS e
		INNER JOIN HumanResources.EmployeeDepartmentHistory AS edh
			ON e.EmployeeID = edh.BusinessEntityID AND edh.EndDate IS NULL -- return only active employees
		WHERE ManagerID IS NULL

    UNION ALL		-- SPLIT CTE INTO ANCHOR AND RECURSIVE MEMBERS

	-- RECURSIVE MEMBER
		SELECT e.ManagerID, e.EmployeeID, e.Title, edh.DepartmentID,
			Level + 1
		FROM #MyEmployees AS e
		INNER JOIN HumanResources.EmployeeDepartmentHistory AS edh
			ON e.EmployeeID = edh.BusinessEntityID AND edh.EndDate IS NULL
		INNER JOIN DirectReports AS d
			ON e.ManagerID = d.EmployeeID
)
-- Statement that executes the CTE
SELECT ManagerID, EmployeeID, Title, DeptID, Level
FROM DirectReports
INNER JOIN HumanResources.Department AS dp
    ON DirectReports.DeptID = dp.DepartmentID
WHERE dp.GroupName = N'Sales and Marketing' OR Level = 0;
GO