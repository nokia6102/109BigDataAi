
ALTER PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',  
	  @script = N'   
		inputData<-data.frame(InputDataSet)	
		cs<-colnames(inputData)				
		frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")			
		model <- rxLogisticRegression(frm, inputData,type = c("binary"))
		trainedModel<-rxSerializeModel(model,realtimeScoringOnly=TRUE)
	'
		,@input_data_1=@sqlQuery
		,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
		,@trainedModel=@trainedModel OUTPUT
	;
GO

DECLARE @ss NVARCHAR(1024)=N'SELECT CAST([Survived] AS INT) AS [Survived]
	, CONVERT(INT,[Pclass]) AS [Pclass]
	, IIF([Sex]=''female'',0,1) AS [Sex]
	, [IsGroup], [IsFamilyHasChild], [IsMomOrDad], [AgeLevel]
	FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910';
DECLARE @mm VARBINARY(MAX);

EXEC #TempPP @ss,@mm OUTPUT;
INSERT INTO 家(家嘿,家) VALUES(N'霉吹癹耴()',@mm);

SELECT * FROM 家

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'Python',  
	  @script = N'   
import pandas as pd
import microsoftml as mml
import revoscalepy as revo

inputData=pd.DataFrame(in_data)	

cns=inputData.columns.values.tolist()
frm=cns[0]+"~"
for a in cns[1:]:
	frm+=a+"+"
frm=frm[0:-1]

model=mml.rx_fast_forest(formula=frm,data=inputData,method="binary")
trainedModel=revo.rx_serialize_model(model,realtime_scoring_only=True)
	'
	,@input_data_1=@sqlQuery
	,@input_data_1_name = N'in_data'		
	,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
	,@trainedModel=@trainedModel OUTPUT
	;
GO

DECLARE @ss NVARCHAR(1024)=N'SELECT [Survived]
	, CONVERT(INT,[Pclass]) AS [Pclass]
	, IIF([Sex]=''female'',0,1) AS [Sex]
	, [IsGroup], [IsFamilyHasChild], [IsMomOrDad], [AgeLevel]
	FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910';
DECLARE @mm VARBINARY(MAX);

EXEC #TempPP @ss,@mm OUTPUT;
INSERT INTO 家(家嘿,家) VALUES(N'Pythonе硉此狶()',@mm);

SELECT * FROM 家








---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--蝶だ 杆

1. cd C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\R_SERVICES\library\RevoScaleR\rxLibs\x64

2. RegisterRExt.exe /installRts [/instance:name] /database:databasename
   RegisterRExt.exe /installRts /instance:MSSQLSERVER
   RegisterRExt.exe /uninstallRts /database:Titantic

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--EXEC dbo.sp_rxPredict @model = @家, @inputData = 琩高戈;

DECLARE @mm VARBINARY(MAX);
SELECT @mm=家 FROM 家 WHERE 絪腹=11;

DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived]
	,CONVERT(INT,Pclass) AS Pclass
	,IIF([Sex]=''female'',0,1) AS [Sex]
	,[IsGroup],[IsFamilyHasChild],[IsMomOrDad],[AgeLevel]
	FROM [Titantic].[dbo].[NewTitanic2] WHERE PassengerId>910';
EXEC sp_rxPredict @model=@mm, @inputData=@sql_query;



DECLARE @mm VARBINARY(MAX);
SELECT @mm=家 FROM 家 WHERE 絪腹=10;

DECLARE @sql_query NVARCHAR(1024)=N'SELECT CONVERT(INT,[Survived]) AS [Survived]
	,CONVERT(INT,Pclass) AS Pclass
	,IIF([Sex]=''female'',0,1) AS [Sex]
	,[IsGroup],[IsFamilyHasChild],[IsMomOrDad],[AgeLevel]
	FROM [Titantic].[dbo].[NewTitanic2] WHERE PassengerId>910';
EXEC sp_rxPredict @model=@mm, @inputData=@sql_query;

------------------------------------
---硂娩﹚璶ノ
SELECT [Survived],[Pclass],[Sex], [IsGroup], [IsFamilyHasChild], [IsMomOrDad], [AgeLevel]
INTO #Test
FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<0

INSERT INTO #Test VALUES('0','3','male',0,0,0,2);		--Jack
INSERT INTO #Test VALUES('0','1','female',1,0,0,2);		--Rose




SELECT * FROM 家

DECLARE @mm VARBINARY(MAX);
SELECT @mm=家 FROM 家 WHERE 絪腹=20;

DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived]
	,CONVERT(INT,Pclass) AS Pclass
	,IIF([Sex]=''female'',0,1) AS [Sex]
	,[IsGroup],[IsFamilyHasChild],[IsMomOrDad],[AgeLevel]
	FROM #Test';
EXEC sp_rxPredict @model=@mm, @inputData=@sql_query;



DECLARE @mm VARBINARY(MAX);
SELECT @mm=家 FROM 家 WHERE 絪腹=23;

DECLARE @sql_query NVARCHAR(1024)=N'SELECT CONVERT(INT,[Survived]) AS [Survived]
	,CONVERT(INT,Pclass) AS Pclass
	,IIF([Sex]=''female'',0,1) AS [Sex]
	,[IsGroup],[IsFamilyHasChild],[IsMomOrDad],[AgeLevel]
	FROM #Test';
EXEC sp_rxPredict @model=@mm, @inputData=@sql_query;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
