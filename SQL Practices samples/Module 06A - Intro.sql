-- BUILT IN FUNCTIONS
	-- AGGREGATE FUNCTIONS
	-- SUBSTRING
	-- GETDATE
	-- ECT..

-- DETERMINISTIC AND NON-DETERMINISTIC FUNCTIONS
USE AdventureWorks2016;

-- NON-DETERMINISTIC - RUNS ONCE FOR ENTIRE QUERY.
	SELECT SalesOrderID, SalesOrderNumber, GETDATE()		
	FROM Sales.SalesOrderHeader


	SELECT SalesOrderID, SalesOrderNumber, RAND()
	FROM Sales.SalesOrderHeader


-- SCALAR FUNCTIONS

			USE AdventureWorks2016;

			IF OBJECT_ID (N'dbo.ufn_GetPersonAddress', N'FN') IS NOT NULL
				DROP FUNCTION ufn_GetPersonAddress;
			GO
			CREATE FUNCTION dbo.ufn_GetPersonAddress(@BusinessEntityID int)
						RETURNS varchar(100) 
			--WITH RETURNS NULL ON NULL INPUT
			AS 
			-- Returns the addressline1 for a person
			BEGIN
				DECLARE @Address VARCHAR(100);
				
				SELECT @Address = addressLine1 
				FROM Person.Person P
				INNER JOIN Person.BusinessEntityAddress BA on  BA.BusinessEntityID=P.BusinessEntityID
				INNER JOIN Person.Address A on A.Addressid=BA.AddressID
				WHERE  P.BusinessEntityID=@BusinessEntityID
       
				RETURN @Address;

			END;
			GO


SET STATISTICS IO ON
SET STATISTICS TIME ON
-- SHOW Statistics IO -- CPU Time very high.

SELECT p.FirstName, dbo.ufn_GetPersonAddress(p.BusinessEntityID)
FROM  Person.Person P

-- DEMO. This is the original method and the performance we would want from the function.
-- SHOW Statistics IO - CPU Time.			
SELECT p.FirstName, a.AddressLine1
FROM Person.Person P	
	INNER JOIN Person.BusinessEntityAddress BA on  BA.BusinessEntityID = P.BusinessEntityID
	INNER JOIN Person.Address A on A.Addressid = BA.AddressID;
GO



-- DETERMINISTIC - RUNS ONCE FOR EACH ROW

-- WITH SCHEMABINDING

-- NOW TRY TO CHANGE SalesOrderID column

-- NULL INPUTS