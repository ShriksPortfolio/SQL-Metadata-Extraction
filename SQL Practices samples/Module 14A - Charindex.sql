/*
	In this example we return only the first part of the email. 
	Exclude @.....com
*/
USE AdventureWorks2016;
GO

-- OBTAIN THE STARTING POSITION OF @
SELECT CHARINDEX('@', EmailAddress, 1), EmailAddress
FROM person.EmailAddress

-- USE PREVIOUS FUNCTION AS A PARAMETER IN THE SUBSTRING FUNCTION.
SELECT  EmailAddress,
		SUBSTRING(EmailAddress,
				  1,
				  CHARINDEX('@', EmailAddress, 1) - 1)
FROM person.EmailAddress