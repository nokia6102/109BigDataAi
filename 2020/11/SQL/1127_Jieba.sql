EXEC sp_execute_external_script  
	@language = N'Python'  
	, @script = N'
import jieba
#jieba.set_dictionary("dict.txt.big")

sentence = "獨立音樂需要大家一起來推廣，歡迎加入我們的行列！"
print ("Input：", sentence)
words = jieba.cut(sentence, cut_all=False)
print ("Output 精確模式 Full Mode：")
for word in words:
	print (word)
'
----
EXEC sp_execute_external_script  
	@language = N'Python'  
	, @script = N'
import jieba
#jieba.set_dictionary("dict.txt.big")

#讀入停用詞
stopWords=[]
with open("C:\\PP\\MyStopWords.txt", "r", encoding="UTF-8") as file:
    for data in file.readlines():
        data = data.strip()
        stopWords.append(data)

sentence = "獨立音樂需要大家一起來推廣，歡迎加入我們的行列！"
print ("Input：", sentence)
words = jieba.cut(sentence, cut_all=False)

#比對停用詞，保留剩餘詞彙
remainderWords=[]
remainderWords = list(filter(lambda a: a not in stopWords and a != "\n", words))

print(remainderWords)
'
-----
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE DATABASE MyNews
USE MyNews;

--DROP TABLE MainCatalog;
CREATE TABLE MainCatalog
(
    MainId INT PRIMARY KEY,
	CatalogName NVARCHAR(20)
);
 
INSERT INTO MainCatalog VALUES(1,'政治'),(2,'科技'),(3,'財經'),(4,'健康'),(5,'運動');
INSERT INTO MainCatalog VALUES(11,'非藍非綠'),(12,'綠營'),(13,'藍營')
INSERT INTO MainCatalog VALUES(21,'手機'),(22,'電腦_遊戲'),(23,'天文')
INSERT INTO MainCatalog VALUES(31,'房地產'),(32,'股市'),(33,'理財')
INSERT INTO MainCatalog VALUES(41,'疾病'),(42,'減重'),(43,'養身')
INSERT INTO MainCatalog VALUES(51,'棒球'),(52,'網球'),(53,'籃球')
SELECT * FROM MainCatalog
 




CREATE TABLE News
(
	NewsId INT IDENTITY PRIMARY KEY,
	[Label] NVARCHAR(10),
	[News] NVARCHAR(MAX)
)

--TRUNCATE TABLE News
SELECT * FROM News
----
DECLARE @sqlQuery nvarchar(max) = N'SELECT [News] FROM [MyNews].[dbo].[News] WHERE [NewsId]=3'
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

print ("Output 精確模式 Full Mode：")
for w in remainderWords:
    print (w)
'
, @input_data_1 = @sqlQuery
