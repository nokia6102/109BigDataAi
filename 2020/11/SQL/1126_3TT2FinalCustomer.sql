
DECLARE @sql_query NVARCHAR(MAX);
SET @sql_query=N'SELECT * FROM NewCustomer'
INSERT INTO #TT
EXECUTE sp_execute_external_script @language = N'R',  
		@script = N'   

	sqlData <- data.frame(InputDataSet)
	cs<-colnames(sqlData)		#取出欄位名
	frm<-paste("", paste(cs[2:length(cs)], collapse="+"), sep="~")
	#print(frm)
	z <- rxKmeans(~ContinentName+MaritalStatus+Gender+Education+Occupation+AgeLevel
		+YearlyIncomeLevel+HasChild+HasHouse+HasCar+Star		
		, data=sqlData, numClusters = 5, seed=12345)
	#print(z)
	#print(str(z))
	OutputDataSet <- data.frame(cbind(sqlData$CustomerKey,z$cluster))
	'
	,@input_data_1=@sql_query	
;

-----
SELECT * FROM #TT
DROP TABLE #TT;

CREATE TABLE #TT 
(
	CustomerKey INT,
	GroupID INT
)

SELECT * FROM NewCustomer

SELECT A.* ,B.GroupId
INTO FinalCustomer
FROM NewCustomer AS A JOIN #TT AS B ON A.CustomerKey=B.CustomerKey;

SELECT * FROM	 FinalCustomer
----
DECLARE @sqlQuery NVARCHAR(MAX);
SET @sqlQuery=N'SELECT [GroupId],[ContinentName], [MaritalStatus], [Gender], [Education], [Occupation]
	, [AgeLevel], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar], [Star] FROM FinalCustomer WHERE [CustomerKey]<=12940'
DECLARE @mm VARBINARY(MAX);

EXECUTE sp_execute_external_script @language = N'R',  
    @script = N'   		
	sqlData <- data.frame(InputDataSet)
	cs<-colnames(sqlData)		#取出欄位名
	frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")
	model<-rxLogisticRegression(frm,sqlData,type="multiClass")
	print(model)
	'
	,@input_data_1=@sqlQuery
GO

CREATE TABLE 模型表
(
    編號 INT IDENTITY(1,1) PRIMARY KEY,
	模型名稱 NVARCHAR(20),
	模型 VARBINARY(MAX),
	建檔時間 DATETIME2(2) DEFAULT SYSDATETIME()
)
GO

CREATE PROC #PP @sqlQuery NVARCHAR(MAX),@model VARBINARY(MAX) OUTPUT
AS
EXECUTE sp_execute_external_script @language = N'R',  
		@script = N'   		
	sqlData <- data.frame(InputDataSet)
	cs<-colnames(sqlData)		#取出欄位名
	frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")
	model<-rxLogisticRegression(frm,sqlData,type="multiClass")
	#print(model)
	trainedModel <- rxSerializeModel(model,realtimeScoringOnly=TRUE)
	'
	,@input_data_1=@sqlQuery	
	,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
	,@trainedModel=@model OUTPUT;
GO

DECLARE @ss NVARCHAR(MAX);
SET @ss=N'SELECT [GroupId],[ContinentName], [MaritalStatus], [Gender], [Education], [Occupation]
	, [AgeLevel], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar], [Star] FROM FinalCustomer WHERE [CustomerKey]<=12940'
DECLARE @mm VARBINARY(MAX);
EXEC #PP @ss,@mm OUTPUT;
INSERT INTO 模型表(模型名稱,模型) VALUES(N'羅吉斯迴歸(多分類)(即時)',@mm);

SELECT * FROM 模型表

ALTER PROC #PP @sqlQuery NVARCHAR(MAX),@model VARBINARY(MAX) OUTPUT
AS
EXECUTE sp_execute_external_script @language = N'R',  
		@script = N'   		
	sqlData <- data.frame(InputDataSet)
	cs<-colnames(sqlData)		#取出欄位名
	frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")
	model<-rxNeuralNet(frm,sqlData,type="multiClass")
	#print(model)
	trainedModel <- rxSerializeModel(model,realtimeScoringOnly=TRUE)
	'
	,@input_data_1=@sqlQuery	
	,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
	,@trainedModel=@model OUTPUT;
GO

DECLARE @ss NVARCHAR(MAX);
SET @ss=N'SELECT [GroupId],[ContinentName], [MaritalStatus], [Gender], [Education], [Occupation]
	, [AgeLevel], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar], [Star] FROM FinalCustomer WHERE [CustomerKey]<=12940'
DECLARE @mm VARBINARY(MAX);
EXEC #PP @ss,@mm OUTPUT;
INSERT INTO 模型表(模型名稱,模型) VALUES(N'類神經(多分類)(即時)',@mm);

DECLARE @ss NVARCHAR(MAX);
SET @ss=N'SELECT [GroupId],[ContinentName], [MaritalStatus], [Gender], [Education], [Occupation]
	, [AgeLevel], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar], [Star] FROM FinalCustomer WHERE [CustomerKey]>12940'
DECLARE @mm VARBINARY(MAX);
SELECT @mm=模型 FROM 模型表 WHERE 編號=1

EXECUTE sp_execute_external_script @language = N'R',  
		@script = N'   		
	sqlData <- data.frame(InputDataSet)
	model <- rxUnserializeModel(trainedModel)
	result<-rxPredict(model,sqlData,extraVarsToWrite=c("GroupId"))	
	OutputDataSet<-result	
	'
	,@input_data_1=@ss	
	,@params=N'@trainedModel VARBINARY(MAX)'
	,@trainedModel=@mm;

SELECT * FROM #TT

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE #TT
CREATE TABLE #TT
(
    實際組別 INT,
	推薦組別 INT
)
GO

DECLARE @ss NVARCHAR(MAX);
SET @ss=N'SELECT [GroupId],[ContinentName], [MaritalStatus], [Gender], [Education], [Occupation]
	, [AgeLevel], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar], [Star] FROM FinalCustomer WHERE [CustomerKey]>12940'
DECLARE @mm VARBINARY(MAX);
SELECT @mm=模型 FROM 模型表 WHERE 編號=1

INSERT INTO #TT
EXECUTE sp_execute_external_script @language = N'R',  
		@script = N'   		
	sqlData <- data.frame(InputDataSet)
	model <- rxUnserializeModel(trainedModel)
	result<-rxPredict(model,sqlData,extraVarsToWrite=c("GroupId"))	
	#OutputDataSet<-result
	OutputDataSet<-result[,1:2]
	'
	,@input_data_1=@ss	
	,@params=N'@trainedModel VARBINARY(MAX)'
	,@trainedModel=@mm;

SELECT * FROM #TT

 SELECT * FROM 模型表
ALTER TABLE #TT ADD [Bingo] INT;
UPDATE #TT SET [Bingo]=0;
UPDATE #TT SET [Bingo]=1 WHERE 實際組別=推薦組別;

SELECT [實際組別],COUNT(*) AS Cnt,SUM([Bingo]) AS [Correct]
	,1.0*SUM([Bingo])/COUNT(*) AS [羅吉斯迴歸(多分類)(即時)命中機率]
FROM #TT
GROUP BY [實際組別];