-- USE EXPLICIT TRANSACTIONS TO ROLLBACK POTENTIAL MISTAKES


USE AdventureWorks2016;

-- SHOW DATA IN PERSON.PERSON TABLE
SELECT * FROM PERSON.PERSON


BEGIN TRANSACTION
		
		UPDATE Person.Person SET ModifiedDate = GETDATE()
		
		
		SELECT ModifiedDate, * FROM PERSON.PERSON 

ROLLBACK TRANSACTION