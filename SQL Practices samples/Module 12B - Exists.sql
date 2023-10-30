USE AdventureWorks2016;

-- Return all Products that have sales in SalesOrderDetail table.
		SELECT a.*
		FROM Production.Product AS a
		WHERE EXISTS
			(SELECT *
			 FROM Sales.SalesOrderDetail sod
			 WHERE A.ProductID = sod.ProductID);

-- IF EXISTS to check for the existence of an object
		IF EXISTS (SELECT * FROM SYSOBJECTS WHERE NAME = 'usp_CustomerInfo')
		BEGIN
			SELECT * FROM SYSOBJECTS WHERE NAME = 'usp_CustomerInfo'
		END
		ELSE
			SELECT 'NO STORED PROCEDURE EXISTS'

-- IF EXISTS 2016 FUNCTIONALITY
		
CREATE PROC usp_CustomerInfo
(
	@CustomerID VARCHAR(10) = NULL
)
AS

	IF @CustomerID IS NULL 
	BEGIN
		RAISERROR('CustomerID field must be populated with a value.', 16, 1)
	END
	IF ISNUMERIC(@CustomerID) <> 1 AND @CustomerID IS NOT NULL
	BEGIN
		RAISERROR('CustomerID must be an integer value.', 16, 1)
	END
	ELSE
		SELECT * 
		FROM [Person].[Person]
		WHERE 
			BusinessEntityID = @CustomerID 


		DROP PROCEDURE	IF EXISTS usp_CustomerInfo

		DROP TABLE		IF EXISTS MyPretendTable 

		ALTER TABLE		Person.Person
		DROP COLUMN		IF EXISTS MyPretendColumn

