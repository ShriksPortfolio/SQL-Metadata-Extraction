/*
	Data Masking example
*/
-- This demo uses the DimCustomer table in the AdventureWorksDW2016 sample database
-- to demonstrate how Dynamic Data Masking (DDM) can be used to mask (fully or partially) data
-- in sensitive columns.

USE AdventureWorksDW2016;
GO

-- If you are connected as 'dbo', you will always see unmasked data:
SELECT EmailAddress, Phone,* FROM DimCustomer
go

-- Unprivileged users see masked data by default. For example, this SalesPerson 'NoDataMasking' will
-- see masked data:
EXECUTE AS USER = 'NoDataMasking'
	SELECT EmailAddress, Phone,* FROM DimCustomer		-- EmailAddress and PhoneNumber are masked
REVERT
go

-- Granting users or roles the UNMASK permission will enable them to see unmasked data:
GRANT UNMASK TO NoDataMasking -- user
go

EXECUTE AS USER = 'NoDataMasking'
SELECT EmailAddress, Phone,* FROM DimCustomer -- EmailAddress and PhoneNumber are no longer masked
REVERT
go

-- Reset the changes
REVOKE UNMASK TO NoDataMasking
go

-- DDM is configured in the table schema. For example, if you have the ALTER ANY MASK permission,
-- you can remove a mask on a column like this:
ALTER TABLE DimCustomer
ALTER COLUMN EmailAddress DROP MASKED
go

-- And you can add a mask like this: 
ALTER TABLE DimCustomer
ALTER COLUMN EmailAddress ADD MASKED WITH (FUNCTION = 'email()')
go

-- You can also edit a mask with a different masking function. This shows how to define a custom
-- mask, where you specify how many characters to reveal (prefix and suffix) and your own padding
-- string in the middle:

ALTER TABLE DimCustomer
ALTER COLUMN EmailAddress ADD MASKED WITH (FUNCTION = 'partial(2, "zzz@abab", 4)')   -- New mask for email
go

ALTER TABLE DimCustomer
ALTER COLUMN Phone ADD MASKED WITH (FUNCTION = 'partial(0, "111-111-11", 2)')		 -- New mask for phone
go

-- See how that masks now:
EXECUTE AS USER = 'NoDataMasking'
SELECT EmailAddress, Phone,* FROM DimCustomer -- New custom masks for EmailAddress and Phone
REVERT
go

-- Reset the changes
ALTER TABLE DimCustomer
ALTER COLUMN EmailAddress ADD MASKED WITH (FUNCTION = 'email()')
go
ALTER TABLE DimCustomer
ALTER COLUMN Phone ADD MASKED WITH (FUNCTION = 'default()')
go

-- Try doing a SELECT INTO from the table with a mask into a temp table (with a user that doesn't 
-- have the UNMASK permission), and you'll find that the temp table contains masked data:
EXECUTE AS USER = 'NoDataMasking'

SELECT FirstName, EmailAddress, Phone INTO #temp_table
FROM DimCustomer -- Masked Email and Phone

SELECT * FROM #temp_table
