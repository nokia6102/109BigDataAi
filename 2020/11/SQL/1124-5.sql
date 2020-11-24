
SELECT [Survived], [Pclass], [Sex],[IsGroup], [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910;

SELECT [Survived],COUNT(*)
FROM [Titantic].[dbo].[NewTitanic2]
WHERE [PassengerId]<=910
GROUP BY [Survived];

DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2]';

EXECUTE sp_execute_external_script @language = N'R',
@script =  N'   
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
	WITH RESULT SETS (( "诀瞯" FLOAT,"诀瞯" FLOAT ))
;


CREATE PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',  
	  @script = N'   
		inputData<-data.frame(InputDataSet)	
		cs<-colnames(inputData)		#逆
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

USE [Titantic]
--DROP TABLE 家
CREATE TABLE 家
(
    絪腹 INT IDENTITY(1,1) PRIMARY KEY,
	家嘿 NVARCHAR(20),
	家 VARBINARY(MAX),
	郎丁 DATETIME2(2) DEFAULT SYSDATETIME()
)

DECLARE @ss NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910';
DECLARE @mm VARBINARY(MAX);

EXEC #TempPP @ss,@mm OUTPUT;
INSERT INTO 家(家嘿,家) VALUES(N'∕郸攫',@mm);

SELECT * FROM 家
----

DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]>910';

DECLARE @mm VARBINARY(MAX);
SELECT @mm=家 FROM 家 WHERE 絪腹=1;

EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		testData<-data.frame(InputDataSet)				#肚代刚舱
		trainedModel<-rxUnserializeModel(inputModel)	#肚癡絤筁家

		#result<-rxPredict(trainedModel, data= testData,writeModelVars=TRUE)			
		result<-rxPredict(trainedModel, data= testData,extraVarsToWrite=c("Survived"))			
		OutputDataSet<-result;	
	'
	,@input_data_1=@sql_query
	,@params=N'@inputModel VARBINARY(MAX)'
	,@inputModel=@mm	
;

----

CREATE TABLE #TT
(
    诀瞯 FLOAT,
	诀瞯 FLOAT,
	﹍ INT
)
GO

DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]>910';

DECLARE @mm VARBINARY(MAX);
SELECT @mm=家 FROM 家 WHERE 絪腹=1;

INSERT INTO #TT
EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		testData<-data.frame(InputDataSet)				#肚代刚舱
		trainedModel<-rxUnserializeModel(inputModel)	#肚癡絤筁家

		result<-rxPredict(trainedModel, data= testData,extraVarsToWrite=c("Survived"))
		OutputDataSet<-result;	
	'
	,@input_data_1=@sql_query
	,@params=N'@inputModel VARBINARY(MAX)'
	,@inputModel=@mm
;

SELECT * FROM #TT

ALTER TABLE #TT ADD 箇代 INT;
UPDATE #TT SET 箇代=IIF(诀瞯>=0.6,1,0)


DECLARE @tt INT,@tf INT,@ft INT,@ff INT;
SELECT @tt=COUNT(*) FROM #TT WHERE ﹍=1 AND 箇代=1;
SELECT @tf=COUNT(*) FROM #TT WHERE ﹍=1 AND 箇代=0;
SELECT @ft=COUNT(*) FROM #TT WHERE ﹍=0 AND 箇代=1;
SELECT @ff=COUNT(*) FROM #TT WHERE ﹍=0 AND 箇代=0;
SELECT @tt,@tf,@ft,@ff;
SELECT (@tt+@ff)/399.0
SELECT 1.0*@tt/(@tt+@tf)
