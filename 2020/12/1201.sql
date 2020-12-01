USE AdventureWorksDW2012
--- 從 View dbo.vTagetMal設計抓出sql再在入INTO語法 
SELECT          c.CustomerKey, c.GeographyKey, c.CustomerAlternateKey, c.Title, c.FirstName, c.MiddleName, c.LastName, 
                            c.NameStyle, c.BirthDate, c.MaritalStatus, c.Suffix, c.Gender, c.EmailAddress, c.YearlyIncome, c.TotalChildren, 
                            c.NumberChildrenAtHome, c.EnglishEducation, c.SpanishEducation, c.FrenchEducation, c.EnglishOccupation, 
                            c.SpanishOccupation, c.FrenchOccupation, c.HouseOwnerFlag, c.NumberCarsOwned, c.AddressLine1, 
                            c.AddressLine2, c.Phone, c.DateFirstPurchase, c.CommuteDistance, x.Region, x.Age, 
                            CASE x.[Bikes] WHEN 0 THEN 0 ELSE 1 END AS BikeBuyer
INTO BikeBuyerPredict
FROM              dbo.DimCustomer AS c INNER JOIN
                                (SELECT          CustomerKey, Region, Age, 
                                                              SUM(CASE [EnglishProductCategoryName] WHEN 'Bikes' THEN 1 ELSE 0 END) AS Bikes
                                  FROM               dbo.vDMPrep
                                  GROUP BY    CustomerKey, Region, Age) AS x ON c.CustomerKey = x.CustomerKey


SELECT * FROM BikeBuyerPredict

ALTER TABLE BikeBuyerPredict
DROP COLUMN [GeographyKey];
ALTER TABLE BikeBuyerPredict
DROP COLUMN Title;
ALTER TABLE BikeBuyerPredict
DROP COLUMN Suffix;
ALTER TABLE BikeBuyerPredict
DROP COLUMN NameStyle,EmailAddress;
ALTER TABLE BikeBuyerPredict
DROP COLUMN AddressLine1;
ALTER TABLE BikeBuyerPredict
DROP COLUMN AddressLine2;
ALTER TABLE BikeBuyerPredict
DROP COLUMN Phone;

--------------星座--------------
CREATE TABLE StarTable
(
	id INT,
	name_zh NVARCHAR(10),
	name_en NVARCHAR(128),
	s_time INT,
	o_time INT
);
 
INSERT INTO StarTable
VALUES
	(10,N'魔羯座',N'Capricorn' ,1222 ,119),
	(11,N'水瓶座',N'Aquarius' ,120 ,218),
	(12,N'雙魚座',N'Pisces' ,219 ,320),
	(1,N'牡羊座',N'Aries' ,321 ,420),
	(2,N'金牛座',N'Taurus' ,421 ,520),
	(3,N'双子座',N'Gemini' ,521 ,621),
	(4,N'巨蟹座',N'Cancer' ,622 ,722),
	(5,N'獅子座',N'Leo' ,723 ,822),
	(6,N'處女座',N'Virgo' ,823 ,922),
	(7,N'天秤座',N'Libra' ,923 ,1022),
	(8,N'天蝎座',N'Scorpio' ,1023 ,1121),
	(9,N'射手座',N'Sagittarius' ,1122 ,1221);

SELECT * FROM StarTable;


CREATE FUNCTION StarSign(@birthday DATETIME)
RETURNS @tt TABLE
(
	id INT,
    name_zh NVARCHAR(10),
    name_en NVARCHAR(128),
    s_time INT,
    o_time INT
)
AS
  BEGIN 

	DECLARE @NowDate INT;
	SELECT @NowDate = CONVERT(INT,FORMAT(@Birthday,'Mdd'))
     
	IF @NowDate >= 1222 OR @NowDate <= 119
		BEGIN		
			INSERT INTO @tt VALUES(10,N'魔羯座',N'Capricorn',1222,119);
		END
	ELSE
		BEGIN		
			INSERT INTO @tt
				SELECT id,name_zh, name_en, s_time, o_time
				FROM StarTable
				WHERE @NowDate>=s_time AND @NowDate<=o_time;
		END
	RETURN
  END
GO	

SELECT * FROM dbo.StarSign('1976/10/2');
------------------------------
ALTER TABLE BikeBuyerPredict ADD [Star] INT;
UPDATE BikeBuyerPredict SET [Star]=(SELECT [id] FROM dbo.StarSign([BirthDate]));

SELECT * FROM BikeBuyerPredict