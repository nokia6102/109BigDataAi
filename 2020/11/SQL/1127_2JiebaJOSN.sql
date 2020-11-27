-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER PROC KeyWordToJson @id INT,@result NVARCHAR(1024) OUTPUT
AS
	CREATE TABLE #TT
	(
		[KeyWord] NVARCHAR(100)
	);
	DECLARE @sqlQuery nvarchar(max) = CONCAT(N'SELECT [News] FROM [News] WHERE [NewsId]=',@id)

	INSERT INTO #TT
	EXEC sp_execute_external_script @language = N'Python'  
		, @script = N'
import jieba
import pandas as pd

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
	, @input_data_1 = @sqlQuery;
	
	SET @result=( SELECT [KeyWord],COUNT(*) AS Cnt
		FROM #TT
		GROUP BY [KeyWord]
		HAVING COUNT(*)>=2
		ORDER BY Cnt DESC
		FOR JSON AUTO
	);
	DROP TABLE #TT;
GO

DECLARE @ans NVARCHAR(1024);
EXEC [KeyWordToJson] 60,@ans OUTPUT;
SELECT @ans

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM [News];

ALTER TABLE [News] ADD [KeyWords] NVARCHAR(1024);


DECLARE @id INT=1;
DECLARE @ans NVARCHAR(1024);
EXEC [KeyWordToJson] @id,@ans OUTPUT;
UPDATE [News] SET [KeyWords]=@ans WHERE [NewsId]=@id;