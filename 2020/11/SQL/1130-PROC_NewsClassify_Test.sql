CREATE PROC NewsClassify_Test @NewsContent NVARCHAR(MAX)
AS
	CREATE TABLE #Temp(NewsId INT,News NVARCHAR(MAX));
	INSERT INTO #Temp VALUES(1,@NewsContent);

	CREATE TABLE #TT
	(
		[KeyWord] NVARCHAR(100)
	);
	DECLARE @sqlQuery nvarchar(max) = N'SELECT [News] FROM #Temp WHERE [NewsId]=1';

	INSERT INTO #TT
	EXEC sp_execute_external_script  
		@language = N'Python'  
		, @script = N'
import pandas as pd
import jieba

stopWords=[]
with open("C:\\PP\\MyStopWords.txt", "r", encoding="UTF-8") as file:
    for data in file.readlines():
        data = data.strip()
        stopWords.append(data)

#載入自訂關鍵字
jieba.load_userdict("C:\\PP\\MyKeyWords.txt")

train_data = InputDataSet
df=pd.DataFrame(train_data)
sentence=df.iloc[0,0]
words = jieba.cut(sentence, cut_all=False)

remainderWords=[]
remainderWords = list(filter(lambda a: a not in stopWords and a!= "\n" and a!="\r\n" and a!=" ", words))

#移除數值文字
for ss in remainderWords:
	try:
		f=float(ss)  
		remainderWords.remove(ss)		
	except ValueError:
		continue

OutputDataSet=pd.DataFrame(remainderWords)
	'
	, @input_data_1 = N'SELECT [News] FROM #Temp WHERE [NewsId]=1';

	DECLARE @result NVARCHAR(MAX);
	SET @result=( SELECT [KeyWord],COUNT(*) AS Cnt
		FROM #TT
		GROUP BY [KeyWord]
		HAVING COUNT(*)>=2
		ORDER BY Cnt DESC
		FOR JSON AUTO
	);
	DROP TABLE #TT;
	DROP TABLE #Temp;

	WITH T1
	AS
	(
		SELECT * FROM OPENJSON(@result)
		WITH(
			[KeyWords] NVARCHAR(10) '$.KeyWord',
			[Cnts] INT '$.Cnt'
		)
	)
	,T2 
	AS
	(
		SELECT [KeyWords],[Cnts]  FROM T1 WHERE LEN([KeyWords])>1
	)
	,T3
	AS
	(
		SELECT A.KeyWords,A.Cnts,B.[Label]
		FROM T2 AS A JOIN [FinalCheckList] AS B ON A.KeyWords=B.KeyWords	
	)
	SELECT [Label],(COUNT([Label])*1.0)/(SELECT COUNT(*) FROM T3) AS [Freq]
	FROM T3
	GROUP BY [Label]
	ORDER BY [Freq] DESC;
GO