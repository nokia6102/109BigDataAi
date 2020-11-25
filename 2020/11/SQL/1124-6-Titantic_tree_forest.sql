
SELECT [Survived], [Pclass], [Sex],[IsGroup], [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910;

SELECT [Survived],COUNT(*)
FROM [Titantic].[dbo].[NewTitanic2]
WHERE [PassengerId]<=910
GROUP BY [Survived];



DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2]';

EXECUTE sp_execute_external_script @language = N'R',  
  @script = N'   
	inputData<-data.frame(InputDataSet)
	trainData<-inputData[0:910,]
	testData<-inputData[911:1309,]

	frm <- Survived~ Pclass+Sex+IsGroup+IsFamilyHasChild+IsMomOrDad+AgeLevel
	model <- rxDTree(frm, trainData) 
	print(model)


	result<-rxPredict(model, data= testData)
	print(str(result))
	OutputDataSet<-result;	
'
	,@input_data_1=@sql_query
	WITH RESULT SETS (( "死亡機率" FLOAT,"存活機率" FLOAT ))
;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',  
	  @script = N'   
		inputData<-data.frame(InputDataSet)	
		cs<-colnames(inputData)		#取出欄位名
		frm<-paste(cs[1], paste(cs[2:length(cs)], collapse=" + "), sep=" ~ ")	
		#frm <- Survived~Pclass+Sex+IsGroup+IsFamilyHasChild+IsMomOrDad+AgeLevel
		model <- rxDTree(frm, inputData)
		trainedModel<-rxSerializeModel(model)
	'
		,@input_data_1=@sqlQuery
		,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
		,@trainedModel=@trainedModel OUTPUT
	;
GO

/*
DECLARE @ss NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910';
DECLARE @mm VARBINARY(MAX);

EXEC #TempPP @ss,@mm OUTPUT;
SELECT @mm
*/


USE [Titantic]
--DROP TABLE 模型表
CREATE TABLE 模型表
(
    編號 INT IDENTITY(1,1) PRIMARY KEY,
	模型名稱 NVARCHAR(20),
	模型 VARBINARY(MAX),
	建檔時間 DATETIME2(2) DEFAULT SYSDATETIME()
)

DECLARE @ss NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910';
DECLARE @mm VARBINARY(MAX);

EXEC #TempPP @ss,@mm OUTPUT;
INSERT INTO 模型表(模型名稱,模型) VALUES(N'決策樹',@mm);

SELECT * FROM 模型表

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]>910';

DECLARE @mm VARBINARY(MAX);
SELECT @mm=模型 FROM 模型表 WHERE 編號=1;

EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		testData<-data.frame(InputDataSet)				#傳入測試組
		trainedModel<-rxUnserializeModel(inputModel)	#傳入訓練過的模型

		#result<-rxPredict(trainedModel, data= testData,writeModelVars=TRUE)			
		result<-rxPredict(trainedModel, data= testData,extraVarsToWrite=c("Survived"))			
		OutputDataSet<-result;	
	'
	,@input_data_1=@sql_query
	,@params=N'@inputModel VARBINARY(MAX)'
	,@inputModel=@mm	
;

-----------------------------------------------------------------------------------------------------


CREATE TABLE #TT
(
    死亡機率 FLOAT,
	存活機率 FLOAT,
	原始存活 INT
)
GO


DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]>910';

DECLARE @mm VARBINARY(MAX);
SELECT @mm=模型 FROM 模型表 WHERE 編號=1;

INSERT INTO #TT
EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		testData<-data.frame(InputDataSet)				#傳入測試組
		trainedModel<-rxUnserializeModel(inputModel)	#傳入訓練過的模型

		result<-rxPredict(trainedModel, data= testData,extraVarsToWrite=c("Survived"))
		OutputDataSet<-result;	
	'
	,@input_data_1=@sql_query
	,@params=N'@inputModel VARBINARY(MAX)'
	,@inputModel=@mm
;

SELECT * FROM #TT
ALTER TABLE #TT ADD 預測存活 INT;
UPDATE #TT SET 預測存活=IIF(存活機率>=0.6,1,0)


DECLARE @tt INT,@tf INT,@ft INT,@ff INT;
SELECT @tt=COUNT(*) FROM #TT WHERE 原始存活=1 AND 預測存活=1;
SELECT @tf=COUNT(*) FROM #TT WHERE 原始存活=1 AND 預測存活=0;
SELECT @ft=COUNT(*) FROM #TT WHERE 原始存活=0 AND 預測存活=1;
SELECT @ff=COUNT(*) FROM #TT WHERE 原始存活=0 AND 預測存活=0;
SELECT @tt,@tf,@ft,@ff;
SELECT (@tt+@ff)/399.0
SELECT 1.0*@tt/(@tt+@tf)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',  
	  @script = N'   
		inputData<-data.frame(InputDataSet)	
		cs<-colnames(inputData)		#取出欄位名
		frm<-paste(cs[1], paste(cs[2:length(cs)], collapse=" + "), sep=" ~ ")			
		print(str(inputData))
		model <- rxDForest(frm, inputData)
		trainedModel<-rxSerializeModel(model)
	'
		,@input_data_1=@sqlQuery
		,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
		,@trainedModel=@trainedModel OUTPUT
	;
GO

DECLARE @ss NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910';
DECLARE @mm VARBINARY(MAX);

EXEC #TempPP @ss,@mm OUTPUT;
INSERT INTO 模型表(模型名稱,模型) VALUES(N'決策森林',@mm);
SELECT * FROM 模型表


--DELETE FROM 模型表 WHERE 編號=3;
SELECT * FROM 模型表

-----------------------------------------------------
SELECT * FROM #TT
DROP TABLE #TT
CREATE TABLE #TT
(
    死亡機率 FLOAT,
	存活機率 FLOAT,
	推測存活 INT,
	實際存活 INT
)
GO



DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]>910';

DECLARE @mm VARBINARY(MAX);
SELECT @mm=模型 FROM 模型表 WHERE 編號=2;

INSERT INTO #TT
EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		testData<-data.frame(InputDataSet)				#傳入測試組
		trainedModel<-rxUnserializeModel(inputModel)	#傳入訓練過的模型

		result<-rxPredict(trainedModel, data= testData,extraVarsToWrite=c("Survived"),type=c("prob"))
		OutputDataSet<-result;	
	'
	,@input_data_1=@sql_query
	,@params=N'@inputModel VARBINARY(MAX)'
	,@inputModel=@mm
;


SELECT * FROM #TT
ALTER TABLE #TT ADD 推測存活2 INT;
UPDATE #TT SET 推測存活2=IIF(存活機率>=0.6,1,0)


DECLARE @tt INT,@tf INT,@ft INT,@ff INT;
SELECT @tt=COUNT(*) FROM #TT WHERE 實際存活=1 AND 推測存活2=1;
SELECT @tf=COUNT(*) FROM #TT WHERE 實際存活=1 AND 推測存活2=0;
SELECT @ft=COUNT(*) FROM #TT WHERE 實際存活=0 AND 推測存活2=1;
SELECT @ff=COUNT(*) FROM #TT WHERE 實際存活=0 AND 推測存活2=0;
SELECT @tt,@tf,@ft,@ff;
SELECT (@tt+@ff)/399.0
SELECT 1.0*@tt/(@tt+@tf)

--1124
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--貝式機率

ALTER PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',  
	  @script = N'   
		inputData<-data.frame(InputDataSet)	
		cs<-colnames(inputData)		
		#print(str(inputData))
		#frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")			
		#model <- rxNaiveBayes(frm, inputData)
		model <- rxNaiveBayes(Survived~Pclass+Sex+IsGroup+IsFamilyHasChild+IsMomOrDad+AgeLevel, inputData)		
		trainedModel<-rxSerializeModel(model)
	'
		,@input_data_1=@sqlQuery
		,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
		,@trainedModel=@trainedModel OUTPUT
	;
GO

DECLARE @ss NVARCHAR(1024)=N'SELECT [Survived]
	, [Pclass]
	, [Sex]		
	, CAST([IsGroup] AS NVARCHAR) AS [IsGroup]
	, CAST([IsFamilyHasChild] AS NVARCHAR) AS [IsFamilyHasChild]
	, CAST([IsMomOrDad] AS NVARCHAR) AS [IsMomOrDad]
	, CAST([AgeLevel] AS NVARCHAR) AS [AgeLevel]
	FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910';
DECLARE @mm VARBINARY(MAX);

EXEC #TempPP @ss,@mm OUTPUT;
INSERT INTO 模型表(模型名稱,模型) VALUES(N'貝氏機率',@mm);

--DELETE FROM 模型表 WHERE 編號=5;
SELECT * FROM 模型表

-----------------------------------------------------

DROP TABLE #TT;

CREATE TABLE #TT
(
	實際存活 NVARCHAR(2),
    死亡機率 FLOAT,
	存活機率 FLOAT	
)
GO

DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived]
	, [Pclass]
	, [Sex]		
	, CAST([IsGroup] AS NVARCHAR) AS [IsGroup]
	, CAST([IsFamilyHasChild] AS NVARCHAR) AS [IsFamilyHasChild]
	, CAST([IsMomOrDad] AS NVARCHAR) AS [IsMomOrDad]
	, CAST([AgeLevel] AS NVARCHAR) AS [AgeLevel]
	FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]>910';

DECLARE @mm VARBINARY(MAX);
SELECT @mm=模型 FROM 模型表 WHERE 編號=6;

INSERT INTO #TT    --以下結果存入#TT表
EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		testData<-data.frame(InputDataSet)				#傳入測試組
		trainedModel<-rxUnserializeModel(inputModel)	#傳入訓練過的模型

		result<-rxPredict(trainedModel, data= testData,type=c("prob"),extraVarsToWrite=c("Survived"))
		print(str(result))
		OutputDataSet<-result;	
	'
	,@input_data_1=@sql_query
	,@params=N'@inputModel VARBINARY(MAX)'
	,@inputModel=@mm
;


SELECT * FROM #TT
ALTER TABLE #TT ADD 推測存活 INT;
UPDATE #TT SET 推測存活=IIF(存活機率>=0.6,1,0)


DECLARE @tt INT,@tf INT,@ft INT,@ff INT;
SELECT @tt=COUNT(*) FROM #TT WHERE 實際存活='1' AND 推測存活=1;
SELECT @tf=COUNT(*) FROM #TT WHERE 實際存活='1' AND 推測存活=0;
SELECT @ft=COUNT(*) FROM #TT WHERE 實際存活='0' AND 推測存活=1;
SELECT @ff=COUNT(*) FROM #TT WHERE 實際存活='0' AND 推測存活=0;
SELECT @tt,@tf,@ft,@ff;
SELECT (@tt+@ff)/399.0
SELECT 1.0*@tt/(@tt+@tf)









