/*
	PSEUDO code for UNPIVOT Transform
	SELECT	<Columns>
	FROM	<PivotedTable>
		UNPIVOT (<AggregatedColumn>
					FOR <NewColumn>
						IN (<ColumnList>)) AS PVT
*/

-- SET UP
USE AdventureWorks2016;

IF OBJECT_ID ('TempDB.dbo.#Employee') IS NOT NULL
DROP TABLE #Employee

CREATE TABLE #Employee (EmployeeID INT, BusinessPhone varchar(20), PersonalPhone varchar(20), CellPhone varchar(20))

INSERT INTO #Employee (EmployeeID, BusinessPhone, PersonalPhone, CellPhone)
VALUES
	(1, '123-987-6543', '231-789-3456', '312-897-5643'),
	(2, '321-978-6534', '132-798-5634', '213-879-3564')

-- SHOW DATA
SELECT * FROM #Employee

-- UNPIVOT DEMO
SELECT 
	EmployeeID,
	PhoneType,
	PhoneNumber
FROM #Employee
UNPIVOT
	(PhoneNumber
		FOR PhoneType
			IN (BusinessPhone, PersonalPhone, CellPhone)) AS PVT;
