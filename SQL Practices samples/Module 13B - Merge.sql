/*	SETUP
		USE AdventureWorks2016;
		DELETE FROM Customers WHERE CustomerKey > 11001
		UPDATE Customers SET EmailAddress = NULL

		SELECT * FROM Customers
		SELECT * FROM Customers_Stage
*/
USE [AdventureWorks2016];

	MERGE Customers CST
	USING Customers_Stage CSS
	ON CST.CustomerKey = CSS.CustomerKey

WHEN MATCHED -- AND <column> = <expression>
THEN
	UPDATE SET EmailAddress = css.EmailAddress
WHEN NOT MATCHED 
THEN
	INSERT (FirstName, LastName, Gender, EmailAddress, AddressLine1, AddressLine2, Phone)
	VALUES (CSS.FirstName, CSS.LastName, CSS.Gender, CSS.EmailAddress, CSS.AddressLine1, CSS.AddressLine2, CSS.Phone);	

GO

SELECT * FROM Customers

-- Optional design

BEGIN TRAN
	Update C SET c.EmailAddress = cs.EmailAddress
	FROM Customers C
	JOIN Customers_Stage CS
	ON C.CustomerKey = CS. CustomerKey

	INSERT INTO Customers (FirstName, LastName, Gender, EmailAddress, AddressLine1, AddressLine2, Phone)
	SELECT CS.FirstName, CS.LastName, CS.Gender, CS.EmailAddress, CS.AddressLine1, CS.AddressLine2, CS.Phone
	FROM Customers_Stage CS
	LEFT JOIN Customers C
	ON C.CustomerKey = CS.CustomerKey
	Where c.CustomerKey IS NULL
COMMIT TRAN