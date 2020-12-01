USE AdventureWorksDW2012
--與以下同義
 
 SELECT * FROM [vTargetMail]

SELECT * INTO [BikeBuyerPredict]
FROM [dbo].[vTargetMail];

--DROP  TABLE BikeBuyerPredict
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

/*
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
*/

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


----判別年齡分組

SELECT TOP(200) * FROM [dbo].[BikeBuyerPredict];
SELECT MAX([Age]), MIN([Age]), AVG([Age]) FROM [dbo].[BikeBuyerPredict];
UPDATE [BikeBuyerPredict] SET Age=Age-20


WITH TT
AS
(SELECT 'AA' AS [CustomerKey],[Age] FROM [BikeBuyerPredict])
SELECT 
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY [Age] ASC) OVER (PARTITION BY [CustomerKey]),
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY [Age] ASC) OVER (PARTITION BY [CustomerKey]),
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY [Age] ASC) OVER (PARTITION BY [CustomerKey])
FROM TT;
	-----
	/*
10~30  1
30~37  2
37~46  3
46~60  4
60~90  5
*/

ALTER TABLE BikeBuyerPredict ADD [AgeLevel] INT;
UPDATE [BikeBuyerPredict] SET [AgeLevel]=IIF([Age]<30,1,IIF([Age]<37,2,IIF([Age]<46,3,IIF([Age]<60,4,5))));

 
---年收入整理
SELECT MAX(YearlyIncome),MIN(YearlyIncome),AVG(YearlyIncome) FROM [BikeBuyerPredict];

SELECT YearlyIncome,COUNT(*)
FROM [BikeBuyerPredict]
GROUP BY YearlyIncome
ORDER BY YearlyIncome

/*
0~3		1
4~7		2
8~10  	3
11~17	4
*/

ALTER TABLE [BikeBuyerPredict] ADD [YearlyIncomeLevel] INT;
UPDATE [BikeBuyerPredict] SET [YearlyIncomeLevel]=
	IIF(YearlyIncome<=30000,1,
		IIF(YearlyIncome<=70000,2,
			IIF(YearlyIncome<=100000,3,
				IIF(YearlyIncome<1700000,4,0))));

SELECT TOP(200) * FROM [dbo].[BikeBuyerPredict];
	

ALTER TABLE [BikeBuyerPredict] ADD [HasChild] INT;
UPDATE [BikeBuyerPredict] SET [HasChild]=IIF([TotalChildren]>0,1,0);
ALTER TABLE [BikeBuyerPredict] ADD [HasChildAtHome] INT;
UPDATE [BikeBuyerPredict] SET [HasChildAtHome]=IIF([NumberChildrenAtHome]>0,1,0);

--星座--
ALTER TABLE [BikeBuyerPredict] ADD [Star] INT;
UPDATE [BikeBuyerPredict] SET [Star]=(SELECT [id] FROM dbo.StarSign([BirthDate]));

SELECT [EduLevel] FROM [BikeBuyerPredict]

ALTER TABLE [BikeBuyerPredict] ADD [EduLevel] INT;
UPDATE [BikeBuyerPredict] SET [EduLevel] =
	CASE [EnglishEducation]
			WHEN 'High School' THEN 1
			WHEN 'Partial High School' THEN 2
			WHEN 'Partial College' THEN 3
			WHEN 'Graduate Degree' THEN 4
			WHEN 'Bachelors' THEN 5
		  END;


ALTER TABLE [BikeBuyerPredict] ADD [JobLevel] INT;
UPDATE [BikeBuyerPredict] SET [JobLevel]=
	CASE [EnglishOccupation]
		WHEN 'Professional' THEN 1
		WHEN 'Clerical' THEN 2
		WHEN 'Manual' THEN 3
		WHEN 'Management' THEN 4
		WHEN 'Skilled Manual' THEN 5
	END;

SELECT [CommuteDistance],COUNT(*)
FROM [BikeBuyerPredict]
GROUP BY [CommuteDistance]
ORDER BY [CommuteDistance]

ALTER TABLE [BikeBuyerPredict] ADD [DistanceLevel] INT;
UPDATE [BikeBuyerPredict] SET [DistanceLevel]=
	CASE [CommuteDistance]
		WHEN '0-1 Miles' THEN 1
		WHEN '1-2 Miles' THEN 2
		WHEN '2-5 Miles' THEN 3
		WHEN '5-10 Miles' THEN 4
		WHEN '10+ Miles' THEN 5
	END;


SELECT [Region],COUNT(*)
FROM [BikeBuyerPredict]
GROUP BY [Region]
ORDER BY [Region]

ALTER TABLE [BikeBuyerPredict] ADD [RegionLevel] INT;
UPDATE [BikeBuyerPredict] SET [RegionLevel]=
	CASE [Region]
		WHEN 'North America' THEN 1
		WHEN 'Europe' THEN 2
		WHEN 'Pacific' THEN 3		
	END;

ALTER TABLE [BikeBuyerPredict] ADD [NewGender] INT;
UPDATE [BikeBuyerPredict] SET [NewGender]=IIF([Gender]='F',0,1);


ALTER TABLE [BikeBuyerPredict] ADD [NewMarital] INT;
UPDATE [BikeBuyerPredict] SET [NewMarital]=IIF([MaritalStatus]='S',0,1);

SELECT * FROM [BikeBuyerPredict];
------
--DROP TABLE [BikeBuyerPredict_New]
SELECT [BikeBuyer], [AgeLevel], [YearlyIncomeLevel],CAST([HouseOwnerFlag] AS INT) AS [HouseOwned]
	, CAST([NumberCarsOwned] AS INT) AS [NumberCarsOwned], [HasChild], [HasChildAtHome], [Star]
	, [EduLevel], [JobLevel], [DistanceLevel], [RegionLevel], [NewGender], [NewMarital], ROW_NUMBER() OVER(ORDER BY CustomerKey ASC)  AS[RowId]
INTO [BikeBuyerPredict_New]
FROM [BikeBuyerPredict];


SELECT * FROM [BikeBuyerPredict_New]; 

SELECT [BikeBuyer],COUNT(*)
FROM [BikeBuyerPredict_New]
GROUP BY [BikeBuyer]
------


CREATE TABLE 模型表
(
    編號 INT IDENTITY(1,1) PRIMARY KEY,
	模型名稱 NVARCHAR(20),
	模型 VARBINARY(MAX),
	建檔時間 DATETIME2(2) DEFAULT SYSDATETIME()
)
GO
ALTER  PROC  PUTMM @modelName NVARCHAR(20)
AS
  BEGIN 
	  DECLARE @ss NVARCHAR(1024)=N'SELECT [BikeBuyer], [NewGender], [NewMarital], [AgeLevel], [YearlyIncomeLevel], [Star]
			, [HouseOwned], [NumberCarsOwned], [HasChild], [HasChildAtHome], [EduLevel], [JobLevel], [DistanceLevel], [RegionLevel]
			FROM [BikeBuyerPredict_New] WHERE [RowId]<=13000';
		DECLARE @mm VARBINARY(MAX);

		EXEC #TempPP @ss,@mm OUTPUT;
		INSERT INTO 模型表(模型名稱,模型) VALUES(@modelName,@mm);
		SELECT * FROM 模型表;
		-- truncate TABLE 模型表;
  END 

--Revo第一團對
ALTER PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		inputData<-data.frame(InputDataSet)	
		cs<-colnames(inputData)		#取出欄位名		
		frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")
		model <- rxDForest(frm,inputData)		
		trainedModel<-rxSerializeModel(model)
	'
	,@input_data_1=@sqlQuery
	,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
	,@trainedModel=@trainedModel OUTPUT
;
 
--TRUNCATE TABLE  模型表
EXEC PUTMM  N'決策森林';
SELECT * FROM 模型表

--Revo第一團對 rxLogit
ALTER PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		inputData<-data.frame(InputDataSet)	
		cs<-colnames(inputData)		#取出欄位名		
		frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")
		model <- rxLogit(frm,inputData)		
		trainedModel<-rxSerializeModel(model)
	'
	,@input_data_1=@sqlQuery
	,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
	,@trainedModel=@trainedModel OUTPUT
;
 
--TRUNCATE TABLE  模型表
EXEC PUTMM  N'羅吉斯迴歸';


--Revo第一團對 rxLogit
ALTER PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		inputData<-data.frame(InputDataSet)	
		cs<-colnames(inputData)		#取出欄位名		
		frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")
		model <- rxLogit(frm,inputData)		
		trainedModel<-rxSerializeModel(model)
	'
	,@input_data_1=@sqlQuery
	,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
	,@trainedModel=@trainedModel OUTPUT
;
 
--TRUNCATE TABLE  模型表
EXEC PUTMM  N'羅吉斯迴歸';





---插入決策森林
----
--=========
--ML第二團對
ALTER PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		inputData<-data.frame(InputDataSet)	
		cs<-colnames(inputData)		#取出欄位名
		frm<-paste(cs[1], paste(cs[2:length(cs)], collapse=" + "), sep=" ~ ")			
		model <- rxFastForest(frm, inputData,type = c("binary"))		
		trainedModel<-rxSerializeModel(model,realtimeScoringOnly=TRUE)
	'
	,@input_data_1=@sqlQuery
	,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
	,@trainedModel=@trainedModel OUTPUT
	;
 
EXEC PUTMM  N'快速決策森林';
GO


 
---解出來計算
DECLARE @query nvarchar(max) = N'SELECT [BikeBuyer], [NewGender], [NewMarital], [AgeLevel], [YearlyIncomeLevel], [Star]
	, [HouseOwned], [NumberCarsOwned], [HasChild], [HasChildAtHome], [EduLevel], [JobLevel], [DistanceLevel], [RegionLevel]
	FROM [BikeBuyerPredict_New] WHERE [RowId]>13000';
DECLARE @mm VARBINARY(MAX) = (SELECT 模型 FROM 模型表 WHERE 編號=1);

EXEC sp_execute_external_script 
  @language = N'R',
  @script = N'
    trainedModel <- rxUnserializeModel(model);
	test_data <- data.frame(InputDataSet);
	result <- rxPredict(trainedModel, data=test_data,predVarNames=c("Pred_Value"));		
	result2<-data.frame(cbind(test_data$BikeBuyer,result$Pred_Value));	
	names(result2)<-c("Actual_Buy","Pred_Buy");
	print(str(result2))
	OutputDataSet <- result2
  ',
  @input_data_1 = @query,
  @params = N'@model varbinary(max)',
  @model = @mm


 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 --快速評分
DECLARE @query nvarchar(max) = N'SELECT [BikeBuyer], [NewGender], [NewMarital], [AgeLevel], [YearlyIncomeLevel], [Star]
	, [HouseOwned], [NumberCarsOwned], [HasChild], [HasChildAtHome], [EduLevel], [JobLevel], [DistanceLevel], [RegionLevel]
	FROM [BikeBuyerPredict_New] WHERE [RowId]>13000';
DECLARE @mm VARBINARY(MAX) = (SELECT 模型 FROM 模型表 WHERE 編號=1);

EXEC sp_execute_external_script 
  @language = N'R',
  @script = N'
    trainedModel <- rxUnserializeModel(model);
	test_data <- data.frame(InputDataSet);
	result <- rxPredict(trainedModel, data=test_data,predVarNames=c("Pred_Value"));		
	result2<-data.frame(cbind(test_data$BikeBuyer,result$Pred_Value));	
	names(result2)<-c("Actual_Buy","Pred_Buy");	
	OutputDataSet <- result2

	#輸出ROC圖檔
	mainDir <- "C:\\PP" 
	dest_filename = tempfile(pattern = "My_ROC_Curve_DForest_Plots", tmpdir = mainDir)  
	dest_filename = paste(dest_filename, ''.jpg'',sep="")      
	jpeg(filename=dest_filename);
	rxRocCurveObject <- rxRocCurve(
			actualVarName="Actual_Buy"
			,predVarNames=c("Pred_Buy")
			,data=result2
			,title="ROC Curve For DForest Model");
	plot(rxRocCurveObject);
	dev.off();	
  ',
  @input_data_1 = @query,
  @params = N'@model varbinary(max)',
  @model = @mm
 ;