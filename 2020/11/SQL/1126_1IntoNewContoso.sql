SELECT 
	[CustomerKey], B.ContinentName
	,[BirthDate], [MaritalStatus], [Gender]
	,[Education], [Occupation]
	,[AgeLevel], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar]
INTO Contoso_Customer
FROM DimCustomer AS A JOIN [dbo].[DimGeography] AS B
	ON A.GeographyKey=B.GeographyKey
WHERE CustomerType='Person';


SELECT * 
INTO NewContoso..Customer
FROM ContosoRetailDW..Contoso_Customer 