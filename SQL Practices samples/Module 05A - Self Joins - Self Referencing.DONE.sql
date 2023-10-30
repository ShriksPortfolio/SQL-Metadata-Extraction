
-- DEMO 1 -- SELF JOIN
-- Get manager name from self referencing table
-- SETUP
		USE AdventureWorksDW2016;

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
-- DEMO 1 - SHOW THE DATA IN THE TABLE AND EXPLAIN THE SCENARIO.
SELECT
	*
FROM
	#MyEmployees

-- DEMO 2 - DEMO HOW TO RETURN THE SUPERVISOR NAME FOR EACH EMPLOYEE.
SELECT 
	MES.FirstName + ' '  + MES.LastName AS Supervisor,
	ME.FirstName  + ' '  + ME.LastName  AS Employee
FROM 
	#MyEmployees ME
LEFT OUTER JOIN 
	#MyEmployees MES
ON ME.ManagerID = MES.EmployeeID



