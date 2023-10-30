
-- Create a Function that calculates total due by vendor for YTD by passing in the parameter of the VendorID.

USE AdventureWorks2016;

IF OBJECT_ID('dbo.ufnTotalDueByVendor') IS NOT NULL
	DROP FUNCTION dbo.ufnTotalDueByVendor
GO


CREATE FUNCTION ufnTotalDueByVendor (@VendorID INT) 
RETURNS TABLE 
AS 
  RETURN 
    (SELECT   POH.VendorID, SUM(POH.TotalDue) AS [YTD Total]
     FROM     Production.Product AS P 
     INNER JOIN Purchasing.PurchaseOrderDetail AS POD 
                ON POD.ProductID = P.ProductID 
     INNER JOIN Purchasing.PurchaseOrderHeader AS POH 
                ON POH.PurchaseOrderID = POD.PurchaseOrderID 
     WHERE    POH.VendorID = @VendorID  -- 1566
     GROUP BY POH.VendorID); 

GO

--Simple select for a single vendor (1492)
SELECT * FROM dbo.ufnTotalDueByVendor (1492)

--CROSS APPLY to the PURCHASING.VENDOR table to get all Vendors with balances owed.
SELECT V.Name, V.AccountNumber, TDV.[YTD Total]  
FROM Purchasing.VENDOR V
CROSS APPLY  ufnTotalDueByVendor (BusinessEntityID) TDV
WHERE TDV.[YTD Total] > 0

--OUTER APPLY to the PURCHASING.VENDOR table to get all Vendors including no balances. 
--This shows a complete list of Vendors and balances owed including those Vendors with zero balance.
SELECT V.Name,V.AccountNumber, COALESCE(TDV.[YTD Total],0) AS [YTD Total]
FROM 
	Purchasing.VENDOR V
OUTER APPLY  
	ufnTotalDueByVendor (BusinessEntityID) TDV
