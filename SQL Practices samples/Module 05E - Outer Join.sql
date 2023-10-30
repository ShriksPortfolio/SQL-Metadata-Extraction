/*
	DEMO 1 - Full Outer Join Example. Typically used in data warehouse design patterns
	where inserts, updates, and deletes are performed on the destination table.
*/

-- DEMO 1- SHOW Basic FULL OUTER JOIN syntax with a join between Production.Product and SalesOrderDetail

-- SET UP 
		USE AdventureWorks2016;
		GO

		IF OBJECT_ID ('DimProduct') IS NOT NULL
		DROP TABLE DimProduct

		SELECT * INTO DimProduct FROM Production.Product
		DELETE TOP(15) FROM DimProduct
		UPDATE TOP(10) DimProduct SET ProductNumber = ProductNumber + 'XXX'
		BEGIN TRAN
			SET IDENTITY_INSERT DimProduct ON
			INSERT INTO DimProduct (ProductID,  Name, ProductNumber, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, Weight, DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate)
			SELECT TOP(10) ProductID + 1000, Name, ProductNumber, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, Weight, DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate FROM Production.Product
		COMMIT

SELECT * FROM DimProduct
SELECT * FROM Production.Product


SELECT p.ProductID ProductID_Source, dp.ProductID ProductID_Target
FROM Production.Product p
FULL OUTER JOIN DimProduct dp
ON p.ProductID = dp.ProductID
WHERE
	 p.ProductID IS NULL OR
	dp.ProductID IS NULL OR
	p.ProductNumber <> dp.ProductNumber
ORDER BY p.ProductID, dp.ProductID


