---------------------------------------------------------------------
-- T-SQL Querying 3rd Edition (Microsoft Press, 2014)
-- Chapter 08 - T-SQL for BI Practitioners
-- © Dejan Sarka
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Data Preparation
---------------------------------------------------------------------
-----Sales Analysis View
---------------------------------------------------------------------
-- Listing 8-1: View for Sales Analysis
SET NOCOUNT ON;
USE TSQLV4;
IF OBJECT_ID(N'dbo.SalesAnalysis', N'V') IS NOT NULL
    DROP VIEW dbo.SalesAnalysis;
GO
CREATE VIEW dbo.SalesAnalysis
AS
SELECT O.orderid,
       P.productid,
       C.country AS customercountry,
       CASE
           WHEN c.country IN ( N'Argentina', N'Brazil', N'Canada', N'Mexico', N'USA', N'Venezuela' ) THEN
               'Americas'
           ELSE
               'Europe'
       END AS 'customercontinent',
       e.country AS employeecountry,
       PC.categoryname,
       YEAR(O.orderdate) AS orderyear,
       DATEDIFF(day, O.requireddate, o.shippeddate) AS requiredvsshipped,
       OD.unitprice,
       OD.qty,
       OD.discount,
       CAST(OD.unitprice * OD.qty AS NUMERIC(10, 2)) AS salesamount,
       CAST(OD.unitprice * OD.qty * OD.discount AS NUMERIC(10, 2)) AS discountamount
FROM Sales.OrderDetails AS OD
    INNER JOIN Sales.Orders AS O
        ON OD.orderid = O.orderid
    INNER JOIN Sales.Customers AS C
        ON O.custid = C.custid
    INNER JOIN Production.Products AS P
        ON OD.productid = P.productid
    INNER JOIN Production.Categories AS PC
        ON P.categoryid = PC.categoryid
    INNER JOIN HR.Employees AS E
        ON O.empid = E.empid;
GO


SELECT TOP (10)
    orderid,
    productid,
    categoryname,
    salesamount,
    discountamount
FROM dbo.SalesAnalysis;
GO







---------------------------------------------------------------------
-- Frequencies
---------------------------------------------------------------------
-- Frequencies - Solution Before SQL Server 2012
WITH FreqCTE AS
(
SELECT categoryname,
  COUNT(categoryname) AS absfreq,
  ROUND(100. * (COUNT(categoryname)) /
    (SELECT COUNT(*) FROM dbo.SalesAnalysis), 4) AS absperc
FROM dbo.SalesAnalysis
GROUP BY categoryname)


SELECT C1.categoryname,
  C1.absfreq,
  (SELECT SUM(C2.absfreq)
   FROM FreqCTE AS C2
   WHERE C2.categoryname <= C1.categoryname) AS cumfreq,
  CAST(ROUND(C1.absperc, 0) AS INT) AS absperc,
  CAST(ROUND((SELECT SUM(C2.absperc)
   FROM FreqCTE AS C2
   WHERE C2.categoryname <= C1.categoryname), 0) AS INT) AS cumperc,
  CAST(REPLICATE('*',C1.absPerc) AS VARCHAR(100)) AS histogram
FROM FreqCTE AS C1
ORDER BY C1.categoryname;

-- SQL 2012 / 2014 Solution 1
WITH FreqCTE AS
(
SELECT categoryname,
  COUNT(categoryname) AS absfreq,
  ROUND(100. * (COUNT(categoryname)) /
    (SELECT COUNT(*) FROM SalesAnalysis), 4) AS absperc
FROM dbo.SalesAnalysis
GROUP BY categoryname
)
SELECT categoryname,
  absfreq,
  SUM(absfreq) 
   OVER(ORDER BY categoryname 
        ROWS BETWEEN UNBOUNDED PRECEDING
         AND CURRENT ROW) AS cumfreq,
  CAST(ROUND(absperc, 0) AS INT) AS absperc,
  CAST(ROUND(SUM(absperc)
   OVER(ORDER BY categoryname
        ROWS BETWEEN UNBOUNDED PRECEDING
         AND CURRENT ROW), 0) AS INT) AS CumPerc,
  CAST(REPLICATE('*',absperc) AS VARCHAR(50)) AS histogram
FROM FreqCTE
ORDER BY categoryname;



-- SQL 2012 / 2014 Solution 2
-- Explanation Query
SELECT categoryname,
  ROW_NUMBER() OVER(PARTITION BY categoryname ORDER BY categoryname, orderid, productid) AS rn_absfreq,
  ROW_NUMBER() OVER( ORDER BY categoryname, orderid, productid) AS rn_cumfreq, 
  PERCENT_RANK() OVER(ORDER BY categoryname) AS pr_absperc, 
  CUME_DIST() OVER(ORDER BY categoryname, orderid, productid) AS cd_cumperc
FROM dbo.SalesAnalysis;



-- Complete Solution
WITH FreqCTE AS
(
SELECT categoryname,
  ROW_NUMBER() OVER(PARTITION BY categoryname
   ORDER BY categoryname, orderid, productid) AS rn_absfreq,
  ROW_NUMBER() OVER(
   ORDER BY categoryname, orderid, productid) AS rn_cumfreq,
  ROUND(100 * PERCENT_RANK()
   OVER(ORDER BY categoryname), 4) AS pr_absperc, 
  ROUND(100 * CUME_DIST()
   OVER(ORDER BY categoryname, orderid, productid), 4) AS cd_cumperc
FROM dbo.SalesAnalysis
)

SELECT categoryname,
  MAX(rn_absfreq) AS absfreq,
  MAX(rn_cumfreq) AS cumfreq,
  ROUND(MAX(cd_cumperc) - MAX(pr_absperc), 0) AS absperc,
  ROUND(MAX(cd_cumperc), 0) AS cumperc,
  CAST(REPLICATE('*',ROUND(MAX(cd_cumperc) - MAX(pr_absperc), 0)) AS VARCHAR(100)) AS histogram
FROM FreqCTE
GROUP BY categoryname
ORDER BY categoryname;
GO

---------------------------------------------------------------------
-- Centers of a Distribution
---------------------------------------------------------------------

-- Mode
SELECT TOP (1) WITH TIES salesamount, COUNT(*) AS number
FROM dbo.SalesAnalysis
GROUP BY salesamount
ORDER BY COUNT(*) DESC;
GO

-- Median: Difference between PERCENTILE_CONT() and PERCENTILE_DISC()
IF OBJECT_ID(N'dbo.TestMedian',N'U') IS NOT NULL
  DROP TABLE dbo.TestMedian;
GO
CREATE TABLE dbo.TestMedian
(
 val INT	NOT NULL
);
GO
INSERT INTO dbo.TestMedian (val)
VALUES (1), (2), (3), (4);
SELECT DISTINCT			-- can also use TOP (1)
  PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY val) OVER () AS mediandisc,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY val) OVER () AS mediancont
FROM dbo.TestMedian;
GO

-- Median
SELECT DISTINCT
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salesamount) OVER () AS median
FROM dbo.SalesAnalysis;

-- Mean
SELECT AVG(salesamount) AS mean
FROM dbo.SalesAnalysis;
GO

---------------------------------------------------------------------
-- Spread of a distribution
---------------------------------------------------------------------

-- Range
SELECT MAX(salesamount) - MIN(salesamount) AS range
FROM dbo.SalesAnalysis;
GO

-- IQR
SELECT DISTINCT
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salesamount) OVER () -
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salesamount) OVER () AS IQR
FROM dbo.SalesAnalysis;
GO

-- MAD
DECLARE @mean AS NUMERIC(10,2);
SET @mean = (SELECT AVG(salesamount) FROM dbo.SalesAnalysis);
SELECT SUM(ABS(salesamount - @mean))/COUNT(*) AS MAD
FROM dbo.SalesAnalysis;
GO

-- MSD
DECLARE @mean AS NUMERIC(10,2);
SET @mean = (SELECT AVG(salesamount) FROM dbo.SalesAnalysis);
SELECT SUM(SQUARE(salesamount - @mean))/COUNT(*) AS MSD
FROM dbo.SalesAnalysis;
GO

-- Variance of a Sample and of a Population
SELECT VAR(salesamount) AS populationvariance,
  VARP(salesamount) AS samplevariance,
  VARP(salesamount) / VAR(salesamount) AS samplevspopulation1,
  (1.0 * COUNT(*) - 1) / COUNT(*) AS samplevspopulation2
FROM dbo.SalesAnalysis;
GO

-- Standard Deviation, Coeficient of Variation
SELECT STDEV(salesamount) AS populationstdev,
  STDEVP(salesamount) AS samplestdev,
  STDEV(salesamount) / AVG(salesamount) AS CVsalesamount,
  STDEV(discountamount) / AVG(discountamount) AS CVdiscountamount
FROM dbo.SalesAnalysis;
GO

-- Skewness
WITH SkewCTE AS
(
SELECT SUM(salesamount) AS rx,
  SUM(POWER(salesamount,2)) AS rx2,
  SUM(POWER(salesamount,3)) AS rx3,
  COUNT(salesamount) AS rn,
  STDEV(salesamount) AS stdv,
  AVG(salesamount) AS av
FROM dbo.SalesAnalysis
)
SELECT
   (rx3 - 3*rx2*av + 3*rx*av*av - rn*av*av*av)
   / (stdv*stdv*stdv) * rn / (rn-1) / (rn-2) AS skewness
FROM SkewCTE;
GO

-- Kurtosis
WITH KurtCTE AS
(
SELECT SUM(salesamount) AS rx,
  SUM(POWER(salesamount,2)) AS rx2,
  SUM(POWER(salesamount,3)) AS rx3,
  SUM(POWER(salesamount,4)) AS rx4,
  COUNT(salesamount) AS rn,
  STDEV(salesamount) AS stdv,
  AVG(salesamount) AS av
FROM dbo.SalesAnalysis
)
SELECT
   (rx4 - 4*rx3*av + 6*rx2*av*av - 4*rx*av*av*av + rn*av*av*av*av)
   / (stdv*stdv*stdv*stdv) * rn * (rn+1) / (rn-1) / (rn-2) / (rn-3)
   - 3.0 * (rn-1) * (rn-1) / (rn-2) / (rn-3) AS kurtosis
FROM KurtCTE;
GO

-- Skewness and Kurtosis C# Code
/*

using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

[Serializable]
[SqlUserDefinedAggregate(
   Format.Native,	              
   IsInvariantToDuplicates = false, 
   IsInvariantToNulls = true,       
   IsInvariantToOrder = true,     
   IsNullIfEmpty = false)]            
public struct Skew
{
    private double rx;	 // running sum of current values (x)
    private double rx2;	 // running sum of squared current values (x^2)
    private double r2x;	 // running sum of doubled current values (2x)
    private double rx3;	 // running sum of current values raised to power 3 (x^3)
    private double r3x2; // running sum of tripled squared current values (3x^2)
    private double r3x;	 // running sum of tripled current values (3x)
    private Int64 rn;    // running count of rows

    public void Init()
    {
        rx = 0;
        rx2 = 0;
        r2x = 0;
        rx3 = 0;
        r3x2 = 0;
        r3x = 0;
        rn = 0;
    }

    public void Accumulate(SqlDouble inpVal)
    {
        if (inpVal.IsNull)
        {
            return;
        }
        rx = rx + inpVal.Value;
        rx2 = rx2 + Math.Pow(inpVal.Value, 2);
        r2x = r2x + 2 * inpVal.Value;
        rx3 = rx3 + Math.Pow(inpVal.Value, 3);
        r3x2 = r3x2 + 3 * Math.Pow(inpVal.Value, 2);
        r3x = r3x + 3 * inpVal.Value;
        rn = rn + 1;
    }

    public void Merge(Skew Group)
    {
        this.rx = this.rx + Group.rx;
        this.rx2 = this.rx2 + Group.rx2;
        this.r2x = this.r2x + Group.r2x;
        this.rx3 = this.rx3 + Group.rx3;
        this.r3x2 = this.r3x2 + Group.r3x2;
        this.r3x = this.r3x + Group.r3x;
        this.rn = this.rn + Group.rn;
    }

    public SqlDouble Terminate()
    {
        double myAvg = (rx / rn);
        double myStDev = Math.Pow((rx2 - r2x * myAvg + rn * Math.Pow(myAvg, 2))
                             / (rn - 1), 1d / 2d);
        double mySkew = (rx3 - r3x2 * myAvg + r3x * Math.Pow(myAvg, 2) - 
                             rn * Math.Pow(myAvg, 3)) /
                        Math.Pow(myStDev,3) * rn / (rn - 1) / (rn - 2);
        return (SqlDouble)mySkew;
    }

}


[Serializable]
[SqlUserDefinedAggregate(
   Format.Native,
   IsInvariantToDuplicates = false,
   IsInvariantToNulls = true,
   IsInvariantToOrder = true,
   IsNullIfEmpty = false)]
public struct Kurt
{
    private double rx;   // running sum of current values (x)
    private double rx2;  // running sum of squared current values (x^2)
    private double r2x;	 // running sum of doubled current values (2x)
    private double rx4;	 // running sum of current values raised to power 4 (x^4)
    private double r4x3; // running sum of quadrupled current values raised to power 3 (4x^3)
    private double r6x2; // running sum of squared current values multiplied by 6 (6x^2)
    private double r4x;	 // running sum of quadrupled current values (4x)
    private Int64 rn;    // running count of rows

    public void Init()
    {
        rx = 0;
        rx2 = 0;
        r2x = 0;
        rx4 = 0;
        r4x3 = 0;
        r6x2 = 0;
        r4x = 0;
        rn = 0;
    }

    public void Accumulate(SqlDouble inpVal)
    {
        if (inpVal.IsNull)
        {
            return;
        }
        rx = rx + inpVal.Value;
        rx2 = rx2 + Math.Pow(inpVal.Value, 2);
        r2x = r2x + 2 * inpVal.Value;
        rx4 = rx4 + Math.Pow(inpVal.Value, 4);
        r4x3 = r4x3 + 4 * Math.Pow(inpVal.Value, 3);
        r6x2 = r6x2 + 6 * Math.Pow(inpVal.Value, 2);
        r4x = r4x + 4 * inpVal.Value;
        rn = rn + 1;
    }

    public void Merge(Kurt Group)
    {
        this.rx = this.rx + Group.rx;
        this.rx2 = this.rx2 + Group.rx2;
        this.r2x = this.r2x + Group.r2x;
        this.rx4 = this.rx4 + Group.rx4;
        this.r4x3 = this.r4x3 + Group.r4x3;
        this.r6x2 = this.r6x2 + Group.r6x2;
        this.r4x = this.r4x + Group.r4x;
        this.rn = this.rn + Group.rn;
    }

    public SqlDouble Terminate()
    {
        double myAvg = (rx / rn);
        double myStDev = Math.Pow((rx2 - r2x * myAvg + rn * Math.Pow(myAvg, 2))
                             / (rn - 1), 1d / 2d);
        double myKurt = (rx4 - r4x3 * myAvg + r6x2 * Math.Pow(myAvg, 2) 
                             - r4x * Math.Pow(myAvg, 3) + rn * Math.Pow(myAvg, 4)) /
                        Math.Pow(myStDev, 4) * rn * (rn + 1) 
                             / (rn - 1) / (rn - 2) / (rn - 3) -
                        3 * Math.Pow((rn - 1), 2) / (rn - 2) / (rn - 3);
        return (SqlDouble)myKurt;
    }

}

*/


-- Deploying CLR UDAs for Skewness and Kurtosis
-- Enable CLR
EXEC sp_configure 'clr enabled', 1;
RECONFIGURE WITH OVERRIDE;
GO
-- Load CS Assembly 
CREATE ASSEMBLY DescriptiveStatistics 
FROM 'C:\temp\DescriptiveStatistics.dll'
WITH PERMISSION_SET = SAFE;
GO
-- Skewness UDA
CREATE AGGREGATE dbo.Skew(@s float)
RETURNS float
EXTERNAL NAME DescriptiveStatistics.Skew;
GO
-- Kurtosis UDA
CREATE AGGREGATE dbo.Kurt(@s float)
RETURNS float
EXTERNAL NAME DescriptiveStatistics.Kurt;
GO

-- Using the UDAs
SELECT dbo.Skew(salesamount) AS skewness,
  dbo.Kurt(salesamount) AS kurtosis
FROM dbo.SalesAnalysis;

-- The Four Population Moments in Groups
SELECT employeecountry,
 AVG(salesamount) AS mean,
 STDEV(salesamount) AS standarddeviation,
 dbo.Skew(salesamount) AS skewness,
 dbo.Kurt(salesamount) AS kurtosis
FROM dbo.SalesAnalysis
GROUP BY employeecountry;
GO

---------------------------------------------------------------------
-- Linear Dependencies
---------------------------------------------------------------------

-- Continuous Variables

-- Covariance
WITH CoVarCTE AS
(
SELECT salesamount as val1,
  AVG(salesamount) OVER () AS mean1,
  discountamount AS val2,
  AVG(discountamount) OVER() AS mean2
FROM dbo.SalesAnalysis
)
SELECT 
  SUM((val1-mean1)*(val2-mean2)) / COUNT(*) AS covar
FROM CoVarCTE;
GO


-- Covariance, Correlation Coeeficient,
-- and Coefficient of Determination
WITH CoVarCTE AS
(
SELECT salesamount as val1,
  AVG(salesamount) OVER () AS mean1,
  discountamount AS val2,
  AVG(discountamount) OVER() AS mean2
FROM dbo.SalesAnalysis
)
SELECT 
  SUM((val1-mean1)*(val2-mean2)) / COUNT(*) AS covar,
  (SUM((val1-mean1)*(val2-mean2)) / COUNT(*)) /
  (STDEVP(val1) * STDEVP(val2)) AS correl,
  SQUARE((SUM((val1-mean1)*(val2-mean2)) / COUNT(*)) /
  (STDEVP(val1) * STDEVP(val2))) AS CD
FROM CoVarCTE;
GO

-- Linear Regression
WITH CoVarCTE AS
(
SELECT salesamount as val1,
  AVG(salesamount) OVER () AS mean1,
  discountamount AS val2,
  AVG(discountamount) OVER() AS mean2
FROM dbo.SalesAnalysis
)
SELECT Slope1=
        SUM((val1 - mean1) * (val2 - mean2))
        /SUM(SQUARE((val1 - mean1))),
       Intercept1=
         MIN(mean2) - MIN(mean1) *
           (SUM((val1 - mean1)*(val2 - mean2))
            /SUM(SQUARE((val1 - mean1)))),
       Slope2=
        SUM((val1 - mean1) * (val2 - mean2))
        /SUM(SQUARE((val2 - mean2))),
       Intercept2=
         MIN(mean1) - MIN(mean2) *
           (SUM((val1 - mean1)*(val2 - mean2))
            /SUM(SQUARE((val2 - mean2))))
FROM CoVarCTE;
GO

-- Discrete Variables 

-- Observed Frequencies 
SELECT categoryname, [USA],[UK]
FROM (SELECT categoryname, employeecountry, orderid FROM dbo.SalesAnalysis) AS S
  PIVOT(COUNT(orderid) FOR employeecountry
    IN([USA],[UK])) AS P
ORDER BY categoryname;
GO

-- Observed and Expected Frequencies Step by Step
WITH
ObservedCombination_CTE AS
(
SELECT categoryname, employeecountry, COUNT(*) AS observed
FROM dbo.SalesAnalysis
GROUP BY categoryname, employeecountry
),
ObservedFirst_CTE AS
(
SELECT categoryname, NULL AS employeecountry, COUNT(*) AS observed
FROM dbo.SalesAnalysis
GROUP BY categoryname
),
ObservedSecond_CTE AS
(
SELECT NULL AS categoryname, employeecountry, COUNT(*) AS observed
FROM dbo.SalesAnalysis
GROUP BY employeecountry
),
ObservedTotal_CTE AS
(
SELECT NULL AS categoryname, NULL AS employeecountry, COUNT(*) AS observed
FROM dbo.SalesAnalysis
),
ExpectedCombination_CTE AS
(
SELECT F.categoryname, S.employeecountry, 
  CAST(ROUND(1.0 * F.observed * S.observed / T.observed, 0) AS INT) AS expected
FROM ObservedFirst_CTE AS F
  CROSS JOIN ObservedSecond_CTE AS S
  CROSS JOIN ObservedTotal_CTE AS T
),
ObservedExpected_CTE AS
(
SELECT O.categoryname, O.employeecountry, O.observed, E.expected
FROM ObservedCombination_CTE AS O
  INNER JOIN ExpectedCombination_CTE AS E
   ON O.categoryname = E.categoryname
    AND O.employeecountry = E.employeecountry
)
SELECT * FROM ObservedExpected_CTE;
GO

-- Chi Squared - using Window Functions
WITH ObservedCombination_CTE AS
(
SELECT categoryname AS onrows,
  employeecountry AS oncols, 
  COUNT(*) AS observedcombination
FROM dbo.SalesAnalysis
GROUP BY categoryname, employeecountry
),
ExpectedCombination_CTE AS
(
SELECT onrows, oncols, observedcombination,
  SUM(observedcombination) OVER (PARTITION BY onrows) AS observedonrows,
  SUM(observedcombination) OVER (PARTITION BY oncols) AS observedoncols,
  SUM(observedcombination) OVER () AS observedtotal,
  CAST(ROUND(SUM(1.0 * observedcombination) OVER (PARTITION BY onrows)
   * SUM(1.0 * observedcombination) OVER (PARTITION BY oncols) 
   / SUM(1.0 * observedcombination) OVER (), 0) AS INT) AS expectedcombination
FROM ObservedCombination_CTE
)
SELECT SUM(SQUARE(observedcombination - expectedcombination)
  / expectedcombination) AS chisquared,
 (COUNT(DISTINCT onrows) - 1) * (COUNT(DISTINCT oncols) - 1) AS degreesoffreedom
FROM ExpectedCombination_CTE;
GO

-- Discrete and Continuous Variables */
/* C# Console Application foR F Distribution */
/*

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms.DataVisualization.Charting;

class FDistribution
{
    static void Main(string[] args)
    {
        // Test input arguments
        if (args.Length != 3)
        {
            Console.WriteLine("Please use three arguments: double FValue, int DF1, int DF2.");
            //Console.ReadLine();
            return;
        }

        // Try to convert the input arguments to numbers. 
        // FValue
        double FValue;
        bool test = double.TryParse(args[0], System.Globalization.NumberStyles.Float,
             System.Globalization.CultureInfo.InvariantCulture.NumberFormat, out FValue);
        if (test == false)
        {
            Console.WriteLine("First argument must be double (nnn.n).");
            return;
        }

        // DF1
        int DF1;
        test = int.TryParse(args[1], out DF1);
        if (test == false)
        {
            Console.WriteLine("Second argument must be int.");
            return;
        }

        // DF2
        int DF2;
        test = int.TryParse(args[2], out DF2);
        if (test == false)
        {
            Console.WriteLine("Third argument must be int.");
            return;
        }

        // Calculate the cumulative F distribution function probability
        Chart c = new Chart();
        double result = c.DataManipulator.Statistics.FDistribution(FValue, DF1, DF2);
        Console.WriteLine("Input parameters: " + 
            FValue.ToString(System.Globalization.CultureInfo.InvariantCulture.NumberFormat)
            + " " + DF1.ToString() + " " + DF2.ToString());
        Console.WriteLine("Cumulative F distribution function probability: " +
            result.ToString("P"));
    }
}

*/
/* C# console application for F distribution */

-- One-way ANOVA
WITH Anova_CTE AS
(
SELECT categoryname, salesamount,
  COUNT(*) OVER (PARTITION BY categoryname) AS gr_casescount,
  DENSE_RANK() OVER (ORDER BY categoryname) AS gr_denserank,
  SQUARE(AVG(salesamount) OVER (PARTITION BY categoryname) -
         AVG(salesamount) OVER ()) AS between_gr_SS,
  SQUARE(salesamount - 
         AVG(salesamount) OVER (PARTITION BY categoryname)) 
	     AS within_gr_SS
FROM dbo.SalesAnalysis

) 
SELECT N'Between groups' AS [Source of Variation],
  SUM(between_gr_SS) AS SS,
  (MAX(gr_denserank) - 1) AS df,
  SUM(between_gr_SS) / (MAX(gr_denserank) - 1) AS MS,
  (SUM(between_gr_SS) / (MAX(gr_denserank) - 1)) /
  (SUM(within_gr_SS) / (COUNT(*) - MAX(gr_denserank))) AS F
FROM Anova_CTE
UNION 
SELECT N'Within groups' AS [Source of Variation],
  SUM(within_gr_SS) AS SS,
  (COUNT(*) - MAX(gr_denserank)) AS df,
  SUM(within_gr_SS) / (COUNT(*) - MAX(gr_denserank)) AS MS,
  NULL AS F
FROM Anova_CTE;
-- Calculating the Cumulative F
-- Turn on the SQLCMD Mode
!!C:\temp\FDistribution 7.57962783966074 7 2147
GO


-- Definite Integration
-- Standard Normal Distribution Table
CREATE TABLE #StdNormDist
(z0 DECIMAL(3,2)  NOT NULL,
 yz DECIMAL(10,9) NOT NULL);
GO
-- Insert the Data
DECLARE @z0 DECIMAL(3,2), @yz DECIMAL(10,9);
SET @z0=-4.00;
WHILE @z0 <= 4.00
 BEGIN
  SET @yz=1.00/SQRT(2.00*PI())*EXP((-1.00/2.00)*SQUARE(@z0));
  INSERT INTO #StdNormDist(z0,yz) VALUES(@z0, @yz);
  SET @z0=@z0+0.01;
END
GO
-- Check the Data
SELECT *
FROM #StdNormDist;
GO

-- Trapezoidal Formula for Definite Integral Approximation

-- Pct of Area between 0 and 1
WITH ZvaluesCTE AS
(
SELECT z0, yz,
  FIRST_VALUE(yz) OVER(ORDER BY z0 ROWS UNBOUNDED PRECEDING) AS fyz,
  LAST_VALUE(yz) 
   OVER(ORDER BY z0
        ROWS BETWEEN CURRENT ROW
         AND UNBOUNDED FOLLOWING) AS lyz
FROM #StdNormDist
WHERE z0 >= 0 AND z0 <= 1
)
SELECT 100.0 * ((0.01 / 2.0) * (SUM(2 * yz) - MIN(fyz) - MAX(lyz))) AS pctdistribution
FROM ZvaluesCTE;

-- Right Tail after Z >= 1.96
WITH ZvaluesCTE AS
(
SELECT z0, yz,
  FIRST_VALUE(yz) OVER(ORDER BY z0 ROWS UNBOUNDED PRECEDING) AS fyz,
  LAST_VALUE(yz)
   OVER(ORDER BY z0
        ROWS BETWEEN CURRENT ROW
         AND UNBOUNDED FOLLOWING) AS lyz
FROM #StdNormDist
WHERE z0 >= 0 AND z0 <= 1.96
)
SELECT 50 - 100.0 * ((0.01 / 2.0) * (SUM(2 * yz) - MIN(fyz) - MAX(lyz))) AS pctdistribution
FROM ZvaluesCTE;

---------------------------------------------------------------------
-- Moving Averages and Entropy
---------------------------------------------------------------------

-- Demo Table
CREATE TABLE dbo.MAvg
(id	 INT   NOT NULL IDENTITY(1,1),
 val FLOAT NULL);
GO
INSERT INTO dbo.MAvg(val) VALUES
(1), (2), (3), (4), (1), (2), (3), (4), (1), (2);
GO

SELECT id, val 
FROM dbo.MAvg
ORDER BY id;
GO

-- Simple MA - Last 3 Values
SELECT id, val,
 ROUND
 (AVG(val)
  OVER (ORDER BY id 
        ROWS BETWEEN 2 PRECEDING
         AND CURRENT ROW)
 ,2) AS SMA
FROM dbo.MAvg
ORDER BY id;
GO

-- Weighted MA - Last 2 Values
DECLARE  @A AS FLOAT;
SET @A = 0.7;
SELECT id, val,
 LAG(val, 1, val) OVER (ORDER BY id) AS prevval,
 @A * val + (1 - @A) *
  (LAG(val, 1, val) OVER (ORDER BY id))  AS WMA
FROM dbo.MAvg
ORDER BY id;
GO

-- Exponential MA - Cursor
DECLARE @CurrentEMA AS FLOAT, @PreviousEMA AS FLOAT, 
 @Id AS INT, @Val AS FLOAT,
 @A AS FLOAT;
DECLARE @Results AS TABLE(id INT, val FLOAT, EMA FLOAT);
SET @A = 0.7;

DECLARE EMACursor CURSOR FOR 
SELECT id, val 
FROM dbo.MAvg
ORDER BY id;

OPEN EMACursor;

FETCH NEXT FROM EMACursor 
 INTO @Id, @Val;
SET @CurrentEMA = @Val;
SET @PreviousEMA = @CurrentEMA;

WHILE @@FETCH_STATUS = 0
BEGIN
 SET @CurrentEMA = ROUND(@A * @Val + (1-@A) * @PreviousEMA, 2);
 INSERT INTO @Results (id, val, EMA)
  VALUES(@Id, @Val, @CurrentEMA);
  SET @PreviousEMA = @CurrentEMA;
 FETCH NEXT FROM EMACursor 
  INTO @Id, @Val;
END;

CLOSE EMACursor;
DEALLOCATE EMACursor;

SELECT id, val, EMA
FROM @Results;
GO

-- Exponential MA - Recursive CTE
DECLARE  @A AS FLOAT;
SET @A = 0.7;
WITH RnCTE AS
(
SELECT id, val,
 ROW_NUMBER() OVER(ORDER BY id) AS rn
FROM dbo.MAvg
),
EMACTE AS
(
  SELECT id, rn, val, val AS EMA
  FROM RnCTE
  WHERE id = 1

  UNION ALL

  SELECT C.id, C.rn, C.val, 
   ROUND (@A * C.val + (1 - @A) * P.EMA, 2) AS EMA
  FROM EMACTE AS P
   INNER JOIN RnCTE AS C
      ON C.rn = P.rn + 1
)
SELECT id, val, EMA 
FROM EMACTE;
GO


-- Exponential MA - Join + Window functions
-- Using the Transformed EMA Formula
DECLARE  @A AS FLOAT;
SET @A = 0.7;
WITH RnCTE AS
(
SELECT id, val,
 ROW_NUMBER() OVER(ORDER BY id) AS rn,
 FIRST_VALUE(val) OVER (ORDER BY id ROWS UNBOUNDED PRECEDING) AS v1
FROM dbo.MAvg
),
MaCTE AS
(
SELECT RN1.id AS id, Rn1.rn AS rn1, Rn2.rn AS rn2, 
 Rn1.v1, Rn1.val AS YI1, Rn2.val AS YI2,
 MAX(RN2.rn) OVER (PARTITION BY RN1.rn) AS TRC
FROM RnCTE AS Rn1
 INNER JOIN RnCTE AS Rn2
  ON Rn1.rn >= Rn2.rn
)
SELECT id, MAX(YI1) AS val,
 ROUND(
 SUM(@A * POWER((1 - @A), (rn1 - rn2)) * YI2)
 +
 MAX(POWER((1 - @A), (TRC - 1)))
 ,2) AS EMA
FROM MaCTE
WHERE rn2 > 1
GROUP BY ID
UNION
SELECT 1, 1, 1
ORDER BY Id;
GO

-- Exponential MA - Quintin du Bruyn Solution
DECLARE @A AS FLOAT = 0.7, @B AS FLOAT;
SET @B = 1 - @A; 
WITH cte_cnt AS
(
SELECT id, val,
  ROW_NUMBER() OVER (ORDER BY id) - 1 as exponent 
FROM dbo.MAvg 
) 
SELECT id, val, 
 ROUND(
  SUM(CASE WHEN exponent=0 THEN 1 
           ELSE @A 
      END * val * POWER(@B, -exponent))
  OVER (ORDER BY id) * POWER(@B, exponent)
 , 2) AS EMA 
FROM cte_cnt; 
GO


-- Entropy

-- Maximum  Possible Entropy 

-- Two States - Probability  0.9 and 0.1, 0.5 and 0.5
SELECT (-1) * (0.1*LOG(0.1,2) + 0.9*LOG(0.9,2)) AS unequaldistribution,
  (-1) * (0.5*LOG(0.5,2) + 0.5*LOG(0.5,2)) AS equaldistribution;

-- With More States, Max. Possible Entropy Increases
SELECT (-1)*(2)*(1.0/2)*LOG(1.0/2,2) AS TwoStatesMax,
 (-1)*(3)*(1.0/3)*LOG(1.0/3,2) AS ThreeStatesMax,
 (-1)*(4)*(1.0/4)*LOG(1.0/4,2) AS FourStatesMax;

-- Logarithmic equations: 
-- LOG(x/y) = LOG(x) - LOG(y)
-- LOG2(1/5) = LOG2(1) - LOG2(5) = - LOG2(5)
-- Therefore, the Query Can Be Simplified
SELECT LOG(2,2) AS TwoStatesMax,
 LOG(3,2) AS ThreeStatesMax,
 LOG(4,2) AS FourStatesMax;
GO

-- Entropy of a Variable

-- Customer Country
WITH ProbabilityCTE AS
(
SELECT customercountry,
 COUNT(customercountry) AS StateFreq
FROM dbo.SalesAnalysis
WHERE customercountry IS NOT NULL
GROUP BY customercountry
),
StateEntropyCTE AS
(
SELECT customercountry,
 1.0*StateFreq / SUM(StateFreq) OVER () AS StateProbability
FROM ProbabilityCTE
)
SELECT (-1)*SUM(StateProbability * LOG(StateProbability,2)) AS TotalEntropy,
 LOG(COUNT(*),2) AS MaxPossibleEntropy,
 100 * ((-1)*SUM(StateProbability * LOG(StateProbability,2))) / 
 (LOG(COUNT(*),2)) AS PctOfMaxPossibleEntropy
FROM StateEntropyCTE;

-- Product Category
WITH ProbabilityCTE AS
(
SELECT categoryname,
 COUNT(categoryname) AS StateFreq
FROM dbo.SalesAnalysis
WHERE categoryname IS NOT NULL
GROUP BY categoryname
),
StateEntropyCTE AS
(
SELECT categoryname,
 1.0*StateFreq / SUM(StateFreq) OVER () AS StateProbability
FROM ProbabilityCTE
)
SELECT (-1)*SUM(StateProbability * LOG(StateProbability,2)) AS TotalEntropy,
 LOG(COUNT(*),2) AS MaxPossibleEntropy,
 100 * ((-1)*SUM(StateProbability * LOG(StateProbability,2))) / 
 (LOG(COUNT(*),2)) AS PctOfMaxPossibleEntropy
FROM StateEntropyCTE;
GO

---------------------------------------------------------------------
-- Clean up
---------------------------------------------------------------------
DROP TABLE dbo.TestMedian;
DROP AGGREGATE dbo.Skew;
DROP AGGREGATE dbo.Kurt;
DROP ASSEMBLY DescriptiveStatistics;
EXEC sp_configure 'clr enabled', 0;
RECONFIGURE WITH OVERRIDE;
DROP TABLE #StdNormDist;
DROP TABLE dbo.MAvg;
GO
