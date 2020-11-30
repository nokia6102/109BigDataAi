WITH Temp
AS
(
	SELECT B.KeyWords,'1' AS [Label]
	FROM [News] AS A CROSS APPLY GetKeyWords(A.NewsId) AS B
	WHERE SUBSTRING(A.Label,1,1)='1' AND LEN(B.KeyWords)>1
	GROUP BY B.[KeyWords]
	UNION ALL
	SELECT B.KeyWords,'2' AS [Label]
	FROM [News] AS A CROSS APPLY GetKeyWords(A.NewsId) AS B
	WHERE SUBSTRING(A.Label,1,1)='2' AND LEN(B.KeyWords)>1
	GROUP BY B.[KeyWords]
	UNION ALL
	SELECT B.KeyWords,'3' AS [Label]
	FROM [News] AS A CROSS APPLY GetKeyWords(A.NewsId) AS B
	WHERE SUBSTRING(A.Label,1,1)='3' AND LEN(B.KeyWords)>1
	GROUP BY B.[KeyWords]
	UNION ALL
	SELECT B.KeyWords,'4' AS [Label]
	FROM [News] AS A CROSS APPLY GetKeyWords(A.NewsId) AS B
	WHERE SUBSTRING(A.Label,1,1)='4' AND LEN(B.KeyWords)>1
	GROUP BY B.[KeyWords]
	UNION ALL
	SELECT B.KeyWords,'5' AS [Label]
	FROM [News] AS A CROSS APPLY GetKeyWords(A.NewsId) AS B
	WHERE SUBSTRING(A.Label,1,1)='5' AND LEN(B.KeyWords)>1
	GROUP BY B.[KeyWords]
)
SELECT * INTO #KeyWord_Temp FROM Temp;


--找出全部的使用次數---
SELECT * FROM #KeyWord_Temp

--找出全部的使用次數，用關鍵字GROUP然後倒序排序---
SELECT [KeyWords],COUNT([Label]) AS Cnt
FROM #KeyWord_Temp
GROUP BY [KeyWords]
ORDER BY Cnt DESC;


WITH Temp
AS
(
--過濾出大於2次以上的全關鍵字
 SELECT [Keywords],COUNT([Label]) AS Cnt
 FROM #KeyWord_Temp
 GROUP BY [KeyWords]
 HAVING COUNT([Label])<=2
 )
SELECT A.keyWords,B.Label
INTO [FinalCheckList]
FROM Temp AS A JOIN #KeyWord_Temp AS B
	ON A.KeyWords=B.KeyWords;

SELECT * FROM [FinalCheckList]

SELECT * FROM [News] WHERE [NewsId]=320
SELECT * FROM GetKeyWords(320) WHERE LEN([keyWords])>1

WITH Temp
AS
(
	SELECT * FROM GetKeyWords(320) WHERE LEN([KeyWords])>1
)
SELECT A.KeyWords,A.Cnts,B.[Label]
FROM Temp AS A JOIN [FinalCheckList] AS B ON A.KeyWords=B.KeyWords
																			    
ORDER BY [Cnts] Desc;
---
--在那幾類別的的機率
WITH Temp
AS
(
SELECT * FROM GetKeyWords(420) WHERE LEN([KeyWords])>1
)
,Temp2
AS
(
SELECT A.KeyWords,A.Cnts,B.[Label]
FROM Temp AS A JOIN [FinalCheckList] AS B ON A.KeyWords=B.KeyWords
)
SELECT [Label],(COUNT([Label])*1.0)/(SELECT COUNT(*) FROM Temp2)AS [Freq]
 
FROM Temp2
GROUP BY [Label]
ORDER BY [Freq] DESC;