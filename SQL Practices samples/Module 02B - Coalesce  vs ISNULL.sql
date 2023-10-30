/*
COALESCE											ISNULL
	ANSI Standard										MS SQL Server
	Accepts Multiple Parameters							Accepts Two Parameters
	Uses the data type with the highest precedence		Uses data type of first parameter

*/

USE AdventureWorks2016;

--DEMO 1 (Basic Syntax)
DECLARE
	@SQL1 AS INT = NULL,
	@SQL2 AS INT = 2,
	@SQL3 AS INT = 3

-- Coalesce can handle all three columns / parameters in one statement. Returns first non null (@SQL2)
SELECT COALESCE(@SQL1, @SQL2, @SQL3)

-- ISNULL can only accept two parameters.
SELECT ISNULL(@SQL1, @SQL2)

-- That worked ok because the second parameter had a value. But what if both param 1 and 2 were NULL?

-- DEMO 2 (Multiple Parameters)

DECLARE
	@SQL1A AS INT = NULL,
	@SQL2A AS INT = NULL,
	@SQL3A AS INT = 3

-- Coalesce can handle all three columns / parameters in one statement. Returns first non null (@SQL2)
SELECT COALESCE(@SQL1A, @SQL2A, @SQL3A)

-- ISNULL can only accept two parameters.
SELECT ISNULL(@SQL1A, @SQL2A)
-- Now ISNULL returns a NULL value. 

-- For ISNULL to work with multiple Parameters we must nest multiple functions.
SELECT ISNULL(ISNULL(@SQL1A, @SQL2A), @SQL3A)

-- DEMO 3 (Data Types)
-- We Change the data type of column/variable 1.

DECLARE
	@SQL1B AS VARCHAR(10) = NULL,
	@SQL2B AS INT = NULL,
	@SQL3B AS INT = 3

-- This will now error because Coalesce returns the data type with the highest precendence 
-- which is an integer and that cannot be concatenated with a 'string' value.

SELECT COALESCE(@SQL1B, @SQL2B, @SQL3B)	+ 'Test'		-- Returns an Integer data type column

-- This will work because the data type returned from ISNULL is inherited from the 'First' parameter
-- which in this case is a string therefore two strings can be combined. 
SELECT ISNULL(ISNULL(@SQL1B, @SQL2B), @SQL3B) + 'Test'	-- Returns a varchar data type column


