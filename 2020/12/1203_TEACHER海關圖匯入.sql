--修正 : 取代 Standard 為水果
UPDATE [PicPathData] SET [Type]='水果' WHERE [Type]='Standard'

WITH Temp
AS
(
	SELECT DISTINCT [Type] FROM [PicPathData]
)
SELECT IDENTITY(INT,1,1) AS Id,[Type]
--DROP TABLE  [ObjectType]
INTO [ObjectType]
FROM Temp;

SELECT * FROM [ObjectType];
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE A SET A.[Label]=B.[Id]
FROM [PicPathData] AS A JOIN [ObjectType] AS B ON A.[Type]=B.[Type];

------------取得成7成資料做訓練資料------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH T1
AS
(
	-- 算每個種類中的各數
	SELECT DISTINCT [Type],COUNT(*) AS Cnt
	FROM [PicPathData]
	GROUP BY [Type]
),
T2
AS
(
	--取前7成的數字
	SELECT DISTINCT [Type],ROUND(Cnt*0.7,0) AS Range
	FROM T1
)
--SELECT * FROM T2;
,T3
AS
(
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY [Type] ORDER BY [Pic]) AS [SerId]
	FROM [PicPathData]
)
,T4
AS
(
	SELECT [Pic], A.[Type], [Label]
	FROM T3 AS A JOIN T2 AS B ON A.[Type]=B.[Type]
	WHERE A.SerId<=B.Range
)
--DROP TABLE TrainPic
SELECT * INTO TrainPic FROM T4;

---後3成做測試---
WITH Temp
AS
(
	SELECT * FROM [PicPathData]
	EXCEPT
	SELECT * FROM [TrainPic]
)
--DROP TABLE TestPic
SELECT * INTO TestPic FROM Temp;


--DROP PROC #TempPP
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROC #TempPP @sqlQuery NVARCHAR(MAX),@model VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R'
        ,@script = N' 
		sqlData<-data.frame(InputDataSet,stringsAsFactors = FALSE);
		sqlData[] <- lapply(sqlData, function(x) if (is.factor(x)) as.character(x) else {x})
		imageModel <- rxLogisticRegression( 
			formula = Label~Features
			,data = sqlData, 
			,type = "multiClass", 
			,mlTransforms = list( 
				loadImage(vars = list(Features = "Pic")), 
				resizeImage(vars = "Features", width = 224, height = 224), 
				extractPixels(vars = "Features"), 
				featurizeImage(var = "Features", dnnModel = "Resnet101"))
			,mlTransformVars = "Pic");	
		 model <- rxSerializeModel(imageModel, realtimeScoringOnly = FALSE);
		 print(model)
		'
		,@input_data_1 = @sqlQuery
		,@params = N'@model VARBINARY(MAX) OUTPUT'
		,@model = @model OUTPUT;
GO

DECLARE @model VARBINARY(MAX);
DECLARE @query nvarchar(max) = N'SELECT  [Pic],[Type],[Label] FROM TrainPic';
EXEC #TempPP @query,@model OUTPUT;
INSERT INTO 模型表(模型名稱,模型) VALUES(N'羅吉斯(圖型)',@model);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM 模型表

CREATE TABLE 模型表
(
    編號 INT IDENTITY(1,1) PRIMARY KEY,
	模型名稱 NVARCHAR(20),
	模型 VARBINARY(MAX),
	建檔時間 DATETIME2(2) DEFAULT SYSDATETIME()
)

TRUNCATE TABLE  模型表
SELECT  * FROM 模型表
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @savedmodel VARBINARY(MAX);
SELECT @savedmodel=模型 FROM 模型表 WHERE 編號=6;

DECLARE @query NVARCHAR(MAX);
SET @query=N'SELECT TOP(3) * FROM TestPic ORDER BY NEWID()';

EXEC sp_execute_external_script 
  @language = N'R',
  @script = N'
    mod <- rxUnserializeModel(model);
    
	testdata<-data.frame(InputDataSet,stringsAsFactors = FALSE);
	testdata[] <- lapply(testdata, function(x) if (is.factor(x)) as.character(x) else {x})
	predict_result <- rxPredict(modelObject = mod, data = testdata,extraVarsToWrite = "Label");	
		
	#print(summary(predict_result));
	#print(predict_result);

	OutputDataSet <- predict_result;
  '
  ,@input_data_1 = @query
  ,@params = N'@model varbinary(max)'
  ,@model=@savedmodel
GO


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROC EvalAnimal @PathInfo NVARCHAR(100)
AS
	CREATE TABLE #Test
	(
		[Pic] NVARCHAR(128),
		[Type] NVARCHAR(128),
		[Label] INT
	);			
	INSERT INTO #Test([Pic],[Type],[Label]) VALUES(@PathInfo,N'',0);
		
	CREATE TABLE #TempResult
	(		
		[PredictedLabel] INT,
		Score1 FLOAT,Score2 FLOAT,Score3 FLOAT,
		Score4 FLOAT,Score5 FLOAT,Score6 FLOAT,
		Score7 FLOAT,Score8 FLOAT,Score9 FLOAT,
		Score10 FLOAT,Score11 FLOAT,Score12 FLOAT,
		Score13 FLOAT,Score14 FLOAT,Score15 FLOAT
	);
	
	DECLARE @savedModel varbinary(max);
	SELECT @savedModel = 模型 FROM 模型表_動物 WHERE 編號=3;
	
	INSERT INTO #TempResult
	EXEC sp_rxPredict @model = @savedModel,@inputData = N'SELECT [Pic],[Label] FROM #Test';

	SELECT A.Type,B.*
	FROM AnimalType AS A JOIN #TempResult AS B ON A.Id=B.[PredictedLabel]
GO

EXEC EvalAnimal N'C:\PP\測試動物區\Mike.png';
EXEC EvalAnimal N'C:\PP\測試動物區\KK.jpg';

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------