--CROSS APPLY returns only records from the left input object that has a matching result from the right object 
--OUTER APPLY returns all records from the left input object regardless of a matching record in the right object. 
--OUTER APPLY substitutes "NULL" for records that do not match.

USE [AdventureWorks2016];
--Simple select from a Table Valued Function already in the AW database
select 
	PersonID,FirstName,LastName,JobTitle,BusinessEntityType
from dbo.ufnGetContactInformation (10) --passing a PersonID parameter (replaces the where clause)


--Inner Join to Table Valued Function --Returns Error
select p.FirstName, p.LastName, p.BusinessEntityID from [Person].[Person] p
inner join dbo.ufnGetContactInformation (p.BusinessEntityID) C; --Returns Error


--CROSS APPLY 
SELECT C.FirstName, C.LastName, C.JobTitle, C.BusinessEntityType FROM [Person].[Person] p
CROSS APPLY dbo.ufnGetContactInformation (p.BusinessEntityID) C --Passing in the ID or identifying column from the Peron table 
--WHERE C.JobTitle is not NULL

--OUTER APPLY
SELECT P.LastName, P.FirstName FirstName_person, C.FirstName FirstName_function, C.JobTitle,C.BusinessEntityType FROM [Person].[Person] p
OUTER APPLY dbo.ufnGetContactInformation (p.BusinessEntityID) C
WHERE p.LastName like 'abo%'					--substitutes null values for records not matching in right object

-- VALIDATION
SELECT * FROM PERSON.PERSON WHERE LastName = 'Abolrous'
