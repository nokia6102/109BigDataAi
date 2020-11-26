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