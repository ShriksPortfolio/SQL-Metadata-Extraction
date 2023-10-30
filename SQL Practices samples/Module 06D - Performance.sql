-- DEMO 1 - Table Value Function can be used to solve the row by row problem.

USE AdventureWorks2016;
GO

IF OBJECT_ID (N'dbo.GetPersonAddress') IS NOT NULL
    DROP FUNCTION GetPersonAddress;

IF OBJECT_ID ('dbo.tvf_GetPersonAddress') IS NOT NULL
DROP FUNCTION dbo.tvf_GetPersonAddress;
GO

CREATE FUNCTION dbo.GetPersonAddress(@BusinessEntityID int)
RETURNS varchar(100) 
AS 
-- Returns the addressline1 for a person
BEGIN
    DECLARE @Address VARCHAR(100);
    SELECT @Address = addressLine1 
	FROM Person.Person P
	INNER JOIN Person.BusinessEntityAddress BA ON  BA.BusinessEntityID = P.BusinessEntityID
	INNER JOIN Person.Address A ON A.Addressid = BA.AddressID
	WHERE  P.BusinessEntityID=@BusinessEntityID
       
    RETURN @Address;

END;
GO

CREATE FUNCTION dbo.tvf_GetPersonAddress ()
RETURNS TABLE
AS
RETURN
   SELECT BA.BusinessEntityID, a.AddressLine1
FROM Person.BusinessEntityAddress BA 
	INNER JOIN Person.Address A on A.Addressid = BA.AddressID;;
GO

-- BASIC SELECT FROM FUNCTION
SELECT * FROM dbo.tvf_GetPersonAddress()

-- RUN THE TVF Function and compare with Scalar Function
-- The execution plan is showing a Hash Match instead of a Nested Loop which tells us
-- the TVF has been inlined and it's not running once per row. Also if we hover over the 
-- Hash match component we can see the number of executions is 1 meaning it ran only once
-- for the TVF which further confirms that the function has been inlined here.

SET STATISTICS IO ON
SET STATISTICS TIME ON

-- Using Inline function syntax allows functions to be called for each record in a select
SELECT P.Title, P.FirstName, P.MiddleName, P.LastName, dbo.GetPersonAddress(BusinessEntityID) as AddressLine1 
FROM person.person P

SELECT p.FirstName, tvf.AddressLine1
FROM Person.Person P
JOIN dbo.tvf_GetPersonAddress () tvf
ON p.BusinessEntityID = tvf.BusinessEntityID


-- Table Value Functions


SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT p.FirstName, tvf.AddressLine1
FROM Person.Person P
JOIN dbo.GetPersonAddress () tvf
ON p.BusinessEntityID = tvf.BusinessEntityID
WHERE p.FirstName like 'b%'
