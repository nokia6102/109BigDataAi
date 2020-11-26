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

ALTER TABLE Customer ADD [Star] INT;
UPDATE [Customer] SET [Star]=(SELECT [id] FROM dbo.StarSign([BirthDate]));


SELECT * FROM Customer
SELECT DISTINCT [ContinentName] FROM [Customer] 
SELECT DISTINCT [Education] FROM [Customer]
SELECT DISTINCT [Occupation] FROM [Customer]


SELECT [CustomerKey]
	, IIF([ContinentName]='Asia',3,IIF([ContinentName]='North America',1,2)) AS [ContinentName]
	, IIF([MaritalStatus]='M',1,0) AS [MaritalStatus]
	, IIF([Gender]='M',1,0) AS [Gender]
	, CASE [Education]
		WHEN 'High School' THEN 1
		WHEN 'Partial High School' THEN 2
		WHEN 'Partial College' THEN 3
		WHEN 'Graduate Degree' THEN 4
		WHEN 'Bachelors' THEN 5
	  END AS [Education]
	, CASE [Occupation]
		WHEN 'Professional' THEN 1
		WHEN 'Clerical' THEN 2
		WHEN 'Manual' THEN 3
		WHEN 'Management' THEN 4
		WHEN 'Skilled Manual' THEN 5
	  END AS [Occupation]
	, CONVERT(INT,[AgeLevel]) AS [AgeLevel]
	, CONVERT(INT,[YearlyIncomeLevel]) AS [YearlyIncomeLevel]
	, CONVERT(INT,[HasChild]) AS [HasChild]
	, CONVERT(INT,[HasHouse]) AS [HasHouse]
	, CONVERT(INT,[HasCar]) AS [HasCar], [Star]
 ---INTO NewCustomer
FROM Customer

SELECT * FROM NewCustomer;
--------
DECLARE @sql_query NVARCHAR(MAX);
SET @sql_query=N'SELECT [ContinentName], [MaritalStatus], [Gender], [Education], [Occupation]
	, [AgeLevel], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar], [Star] FROM NewCustomer'

EXECUTE sp_execute_external_script @language = N'Python',  
		@script = N'   
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.spatial import distance as sci_distance
from sklearn import cluster as sk_cluster

cdata = customer_data
K = range(1, 20)
KM = (sk_cluster.KMeans(n_clusters=k).fit(cdata) for k in K)
centroids = (k.cluster_centers_ for k in KM)

D_k = (sci_distance.cdist(cdata, cent, "euclidean") for cent in centroids)
dist = (np.min(D, axis=1) for D in D_k)
avgWithinSS = [sum(d) / cdata.shape[0] for d in dist]
plt.plot(K, avgWithinSS, "b*-")
plt.grid(True)
plt.xlabel("Number of clusters")
plt.ylabel("Average within-cluster sum of squares")
plt.title("Elbow for KMeans clustering")
plt.savefig("c:\\PP\\K_Means_Test.png")
'
	,@input_data_1=@sql_query
	,@input_data_1_name = N'customer_data'	
;