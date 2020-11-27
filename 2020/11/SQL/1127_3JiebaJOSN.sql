-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @jj NVARCHAR(1024);
SELECT @jj=[KeyWords] FROM [News] WHERE [NewsId]=210;
SELECT * FROM OPENJSON(@jj)
WITH(
	[KeyWords] NVARCHAR(10) '$.KeyWord',
	[Cnt] INT '$.Cnt'
)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE FUNCTION GetKeyWords(@id INT) 
RETURNS @tt TABLE
(
	[KeyWords] NVARCHAR(10),  
    [Cnts] INT
)
AS
  BEGIN
	DECLARE @json NVARCHAR(MAX)	
	SELECT @json=[KeyWords] FROM [News] WHERE [NewsId]=@id;
	INSERT INTO @tt
	SELECT * FROM OPENJSON(@json)
	WITH(
		[KeyWords] NVARCHAR(10) '$.KeyWord',
		[Cnt] INT '$.Cnt'
	)
	RETURN;
  END
GO



SELECT * FROM News
SELECT * FROM GetKeyWords(4)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
SELECT B.KeyWords,B.[Cnts] AS [Total]
FROM [News] AS A CROSS APPLY GetKeyWords(A.NewsId) AS B
WHERE SUBSTRING(A.Label,1,1)='1'
*/

SELECT B.KeyWords,SUM(B.[Cnts]) AS [Total]
FROM [News] AS A CROSS APPLY GetKeyWords(A.NewsId) AS B
WHERE SUBSTRING(A.Label,1,1)='5' AND LEN(B.KeyWords)>1
GROUP BY B.[KeyWords]
ORDER BY [Total] DESC

SELECT B.KeyWords,SUM(B.[Cnts]) AS [Total]
FROM [News] AS A CROSS APPLY GetKeyWords(A.NewsId) AS B
WHERE A.Label='11' AND LEN(B.KeyWords)>1
GROUP BY B.[KeyWords]
ORDER BY [Total] DESC

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--pip.exe install WordCloud
--文字雲


--DROP TABLE #Temp
SELECT B.KeyWords,SUM(B.[Cnts]) AS [TotalCnt]
INTO #Temp
FROM [News] AS A CROSS APPLY GetKeyWords(A.NewsId) AS B
WHERE SUBSTRING(A.Label,1,1)='3' AND LEN(B.KeyWords)>1
GROUP BY B.[KeyWords]
HAVING SUM(B.[Cnts])>=20

--SELECT * FROM #Temp ORDER BY [TotalCnt] DESC



EXEC sp_execute_external_script  
	@language = N'Python'  
	, @script = N'
import matplotlib.pyplot as plt
from wordcloud import WordCloud
import pandas as pd

input_data = InputDataSet
df=pd.DataFrame(input_data)
nn = list(df.KeyWords)	
vv = list(df.TotalCnt)
my_dict=dict(zip(nn,vv))

#設定中文字體
font_path = "C:\Windows\Fonts\kaiu.ttf"  

wc = WordCloud(font_path = font_path,width = 800, height = 800,background_color ="white",stopwords=None,min_font_size = 10)
wc.generate_from_frequencies(my_dict)
wc.to_file("C:\\PP\\p3.png")
'
, @input_data_1 = N'SELECT [KeyWords],[TotalCnt] FROM #Temp'

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------