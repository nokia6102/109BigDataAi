--2020 11 23 Titanic資料分析---
--合併插入到新表-- 
USE Titanic

SELECT x.* 
  INTO [NewTitanic]
  FROM (SELECT * FROM train
        UNION
        SELECT * FROM test) x 
SELECT * FROM NewTitanic

--查出NULL值--
DECLARE @total int
SET @total = (SELECT COUNT(*) FROM NewTitanic)
SELECT 
	@total-COUNT([Survived]) AS [Survived_NULL],
	@total-COUNT([Pclass]) AS [Pclass_NULL],
	@total-COUNT([Name]) AS [Name_NULL],
	@total-COUNT([Sex]) AS [Sex_NULL],
	@total-COUNT([Age]) AS [Age_NULL],
	@total-COUNT([SibSp]) AS [SibSp_NULL],
	@total-COUNT([Parch]) AS [Parch_NULL],
	@total-COUNT([Ticket]) AS [Ticket_NULL],
	@total-COUNT([Fare]) AS [Fare_NULL],
	@total-COUNT([Cabin]) AS [Cabin_NULL],
	@total-COUNT([Embarked]) AS [Embarked_NULL]
FROM NewTitanic
SELECT * FROM NewTitanic

--
SELECT * FROM NewTitanic WHERE [Fare] IS NULL;
ALTER TABLE NewTitanic ALTER COLUMN [Fare] SMALLMONEY;

SELECT [Pclass],AVG([Fare]) FROM NewTitanic GROUP BY [Pclass];
SELECT * FROM NewTitanic WHERE [Pclass]=3 ORDER BY [Fare] DESC

---同張票號的人數
SELECT [Ticket],COUNT([Fare]) AS [Cnt] FROM NewTitanic GROUP BY [Ticket];

--更新同張票號的實際票價
WITH TT
AS
(SELECT  [Ticket],COUNT([Fare]) AS  [Cnt]
FROM NewTitanic GROUP BY [Ticket] )
SELECT A.*,A.[Fare]/B.Cnt AS [NewFare]
--- INTO NewTitanic2
FROM NewTitanic AS A JOIN TT AS B
ON A.Ticket=B.Ticket


SELECT * FROM NewTitanic2 WHERE [Fare] IS NULL;
SELECT [Pclass],AVG([NewFare]) FROM NewTitanic2 GROUP BY [Pclass];
UPDATE [NewTitanic2] SET [NewFare]=7.5 WHERE [Fare] IS NULL; 


SELECT * FROM NewTitanic2 WHERE [NewFare]=0

SELECT * FROM NewTitanic2 WHERE NewFare>10 AND [Pclass]=3
SELECT * FROM NewTitanic2 WHERE NewFare<10 AND [Pclass]=1

SELECT [Survived],COUNT(*) FROM NewTitanic2 GROUP BY [Survived]
SELECT [Pclass],COUNT(*) FROM NewTitanic2 GROUP BY [Pclass]
SELECT [Pclass],COUNT(*) FROM NewTitanic2 WHERE [Survived]=1 GROUP BY [Pclass]
---
ALTER TABLE NewTitanic2 ALTER COLUMN [Fare] FLOAT;
ALTER TABLE NewTitanic2 ALTER COLUMN [Age] FLOAT;

---Master未成年人---
SELECT * FROM NewTitanic2 where [Name] like '%Master%'
UPDATE NewTitanic2 SET [Age]=5 WHERE [Name] LIKE '%Master%' AND [Age] IS NULL 

--女士--
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mrs.%'
--女士    有老公或兄弟  沒有小孩 --
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mrs.%' AND [SibSp]>=1 AND [Parch]=0 AND [Age] IS NULL;
--SELECT * FROM NewTitanic2 WHERE [Sex]='female' AND [SibSp]>=1 AND [Parch]=0 AND [Age] IS NULL ;
--把女士    有老公或兄弟  沒有小孩 --
UPDATE NewTitanic2 SET [Age]=22 WHERE [Name] LIKE '%mrs.%' AND [SibSp]>=1 AND [Parch]=0 AND [Age] IS NULL;

---
--女士 年齡是空的
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mrs.%' AND [Age] IS NULL;
SELECT * FROM NewTitanic2 WHERE [Ticket]='W./C. 6607';
--
UPDATE NewTitanic2 SET [Age]=30 WHERE [Name] LIKE '%mrs.%' AND [SibSp]>=1 AND [Parch]>=1 AND [Age] IS NULL;
UPDATE NewTitanic2 SET [Age]=30 WHERE [Name] LIKE '%mrs.%' AND [Age] IS NULL; 

--==男士==--
-男士-
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [Age] IS NULL;
-男士-有小孩或父母的-
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [Parch]>2 AND [Age] IS NULL;
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mr,%' AND [Parch]=2 AND [Age] IS NULL;

--男的平均 在 class3-
SELECT AVG([Age]) FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [Pclass]=3;
SELECT AVG([Age]) FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [Pclass]=3 AND [SibSp]=0 AND [Parch]=0;
SELECT [Pclass],AVG([Age]) FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [SibSp]=0 AND [Parch]=0 GROUP BY [Pclass]; 

SELECT * FROM NewTitanic2 WHERE [Name] LIKE	


Running under: Windows 10 x64 (build 18363)

Matrix products: default

locale:
[1] LC_COLLATE=Chinese (Traditional)_Taiwan.950 
[2] LC_CTYPE=Chinese (Traditional)_Taiwan.950   
[3] LC_MONETARY=Chinese (Traditional)_Taiwan.950
[4] LC_NUMERIC=C                                
[5] LC_TIME=Chinese (Traditional)_Taiwan.950    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] RevoUtilsMath_11.0.0 RevoUtils_11.0.2     RevoMods_11.0.1     
[4] MicrosoftML_9.4.7    mrsdeploy_1.1.3      RevoScaleR_9.4.7    
[7] lattice_0.20-38      rpart_4.1-13        

loaded via a namespace (and not attached):
 [1] codetools_0.2-15       CompatibilityAPI_1.1.0 foreach_1.5.1         
 [4] grid_3.5.2             R6_2.3.0               jsonlite_1.5          

來自外部指令碼的 STDOUT 訊息: 
 [7] curl_3.3               iterators_1.0.11       tools_3.5.2           
[10] compiler_3.5.2         parallel_3.5.2        


完成時間: 2020-11-24T11:38:08.9706065+08:00
