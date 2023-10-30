
/*
	DEMO 1 - Create scalar function that returns a delimited list of all orders per customer.
	DEMO 2 - Use the function in a select clause.
	DEMO 3 - Create scala function that returns an address per person.
	DEMO 4 - Use the function in a select clause.
*/

USE AdventureWorks2016;

IF OBJECT_ID (N'dbo.GetPersonAddress', N'FN') IS NOT NULL
    DROP FUNCTION GetPersonAddress;
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

--Select directly from a scalar function returns 1 record ****Note that Scalar functions DO NOT use "columns" or "from" command in a select
--The syntax for selecting from a scalar function is a direct select ex: "Select 1" there are no columns or from.

SELECT dbo.GetPersonAddress(10)


-- Using Inline function syntax allows functions to be called for each record in a select
SELECT P.Title, P.FirstName, P.MiddleName, P.LastName, dbo.GetPersonAddress(BusinessEntityID) as AddressLine1 
FROM person.person P








-- GOOD Example from TSQL Programming Book (similar to example in book)


IF OBJECT_ID('dbo.CustomerOrders', 'FN') IS NOT NULL
	DROP FUNCTION dbo.CustomerOrders
GO

CREATE FUNCTION dbo.CustomerOrders
	(@CustomerID AS INT) RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Orders AS VARCHAR(MAX) = '';

	SELECT @Orders = @Orders + CAST(SalesOrderId AS VARCHAR(10)) + '; '
	FROM [Sales].[SalesOrderHeader]
	WHERE CustomerID = @CustomerID;

	RETURN @orders;
END
GO

-- NOW USE FUNCTION IN SELECT QUERY:

SELECT CustomerID, dbo.CustomerOrders(CustomerID) AS AllOrders
FROM Sales.Customer;

USE AdventureWorks2016;