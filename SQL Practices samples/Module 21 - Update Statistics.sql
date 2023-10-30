-- https://msdn.microsoft.com/en-us/library/ms187348.aspx

-- The following updates statistics on all indexes on the table:
USE AdventureWorks2012;
GO
UPDATE STATISTICS SALES.SalesOrderDetail;
GO

-- The following updates statistics on only the index specified:
USE AdventureWorks2012;
GO
UPDATE STATISTICS SALES.SalesOrderDetail AK_SalesOrderDetail_rowguid;
GO

-- The following updates statistics using sample. -- not sure what this means though.
USE AdventureWorks2012;
GO
UPDATE STATISTICS SALES.SalesOrderDetail AK_SalesOrderDetail_rowguid
	WITH SAMPLE 50 PERCENT;
GO