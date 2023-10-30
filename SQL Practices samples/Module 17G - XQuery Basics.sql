
-- LOAD HARDCODED XML DATA INTO AN XML VARIABLE.
DECLARE @XML AS XML 
SET @XML= N'
	<Subcategories>
	  <Subcategory ProductSubcategoryID="10" Name="Forks">
		<Products>
		  <Product>
			<ProductID>802</ProductID>
			<Name>LL Fork</Name>
			<ProductNumber>FK-1639</ProductNumber>
			<ListPrice>148.2200</ListPrice>
			<ModifiedDate>2008-03-11T10:01:36.827</ModifiedDate>
		  </Product>
		  <Product>
			<ProductID>803</ProductID>
			<Name>ML Fork</Name>
			<ProductNumber>FK-5136</ProductNumber>
			<ListPrice>175.4900</ListPrice>
			<ModifiedDate>2008-03-11T10:01:36.827</ModifiedDate>
		  </Product>
		  <Product>
			<ProductID>804</ProductID>
			<Name>HL Fork</Name>
			<ProductNumber>FK-9939</ProductNumber>
			<ListPrice>229.4900</ListPrice>
			<ModifiedDate>2008-03-11T10:01:36.827</ModifiedDate>
		  </Product>
		</Products>
	  </Subcategory>
	</Subcategories>'

 -- -- DEMO 1 -- Use .query to return the full sequence, all values and just product names.
 -- --  XQuery allows us to return these XML Fragments.
SELECT 
	@XML.query('/Subcategories/Subcategory/Products/Product[1]/ProductID')	    AS Product802,
	@XML.query('*')																AS ReturnAll,
	@XML.query('/Subcategories/Subcategory/Products/Product/ProductID')			AS AllProducts,
	@XML.query('/Subcategories/Subcategory/Products/Product[1]/ProductID')	    AS Product802, -- Use Brackets to Filter
	@XML.query('/Subcategories/Subcategory/Products/Product[ProductID=802]')	AS AllDetailsProduct802,
	@XML.query('/Subcategories/Subcategory[@ProductSubcategoryID="10"]')		AS Subcategory_10,
	@XML.query('/Subcategories/Subcategory[@ProductSubcategoryID="10"]/Products/Product[ProductNumber="FK-1639"]')	AS ProductNumber_1639,
	@XML.query('data(*)')														AS AllValues,
	@XML.query('data(/Subcategories/Subcategory/Products/Product/Name)')		AS ProductName

---- DEMO 2 -- Use Xquery to return values using the value method.
---- Value method can only return 1 Value, therefore [1] must be added to each level in the hierarchy.
---- Datatype is required for the return value.
---- In this example Name is returned for ProductSubcategoryID = 10.

SELECT
	@XML.value('/Subcategories[1]/Subcategory[@ProductSubcategoryID="10"][1]/@Name', 'VARCHAR(50)')
