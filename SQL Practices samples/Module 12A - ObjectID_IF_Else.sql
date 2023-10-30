USE AdventureWorks2016;

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

	-- DEMO Running 		
		EXEC usp_CustomerInfo 
		EXEC usp_CustomerInfo '1'
		EXEC usp_CustomerInfo 'A'

		
--SHOW THE RESULT RETURNED FROM usp_CustoemrInfo
	SELECT OBJECT_ID('usp_CustomerInfo')

-- DROP PROCEDURE TWO TIMES AND SHOW ERROR
		DROP PROC usp_CustomerInfo

-- USE IF and the OBJECT_ID to check for the existence of the stored procedure
-- ADD THE OBJECT TYPE 'P' FOR PROCEDURE.
-- Now an error never occurs dropping the stored procedure.

	IF OBJECT_ID('usp_CustomerInfo', 'P') IS NOT NULL
	DROP PROC usp_CustomerInfo;
GO


