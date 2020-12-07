

USE contoso

SELECT COUNT(*) FROM  [contoso].[dbo].[Contoso_Customer1]

SELECT TOP(200) * FROM  [contoso].[dbo].[Contoso_Customer1]

SELECT TOP(1000) * FROM  [ContosoRetailDW].[dbo].[FactOnlineSales]

ALTER DATABASE [contoso] SET RECOVERY BULK_LOGGED;

 
SELECT  * FROM  [contoso].[dbo].[Contoso_Customer1]  AS A 
LEFT JOIN [dbo].[FactOnlineSales]   AS B ON A.[CustomerKey]=B.[CustomerKey]
 
 WITH Temp
AS
(
SELECT   A.[CustomerKey], [AgeLevel], [Star], [ZodiacLevel], [NewMarital], [NewGender], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar], [EduLevel], [JobLevel], [ContinentNameLevel], [GroupId],
			    [OnlineSalesKey], [DateKey], [StoreKey], [ProductKey], [PromotionKey], [CurrencyKey], [SalesOrderNumber], [SalesOrderLineNumber], [SalesQuantity], [SalesAmount], [ReturnQuantity], [ReturnAmount], [DiscountQuantity], [DiscountAmount], [TotalCost], [UnitCost], [UnitPrice], [ETLLoadID], [LoadDate], [UpdateDate]  
FROM  [contoso].[dbo].[Contoso_Customer1]  AS A 
LEFT JOIN [dbo].[FactOnlineSales]   AS B ON A.[CustomerKey]=B.[CustomerKey]
)
SELECT  *
--DROP TABLE  [ManPin_Customer]
INTO [ManPin_Customer]
FROM Temp;

SELECT * FROM [ManPin_Customer]  