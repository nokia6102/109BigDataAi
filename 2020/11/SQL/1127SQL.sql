

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

sentence = "總統大選今天決勝負，親民黨總統候選人宋楚瑜昨天在雙北掃街、晚上在總部前舉行「選前之夜」；宋楚瑜表示，操作棄保只會幫到他，因為國民黨候選人太弱，要棄就棄那個沒經驗、沒能力的，他也很同情韓國瑜被國民黨派系、高層當作傀儡耍。  宋楚瑜受訪指出，趙少康二○○○年時作假民調、讓前總統馬英九發布，呼攏國民黨支持者棄保，如今故技重施，但棄誰保誰大家都知道，韓國瑜的體力、經驗比得上宋楚瑜嗎？  宋楚瑜還說，很同情韓國瑜被國民黨這些派系、高層當作傀儡耍，不就是國民黨內鬥把韓拱出來選總統？韓有那個能力嗎？當選一兩個月的市長就要跳槽，有正當性嗎？國民黨內鬥、推出候選人不就是那幾個人在操縱？「郭台銘曾告訴我這過程，我需要把這些狗屁倒灶講出來嗎？太丟臉了！」  親民黨選前之夜活動除了區域立委、不分區立委候選人上場催票，也邀請歌手葉璦菱等人演出，最後宋楚瑜及親民黨副總統候選人余湘壓軸登場，全場「宋楚瑜凍蒜」、「棄韓保宋」呼喊聲不絕於耳，宋楚瑜的女兒宋鎮邁也現身助陣，一同高唱《我相信》。  宋楚瑜強調，這次選舉全世界都在看，要讓全世界刮目相看，知道台灣的選舉是台灣人當家作主，沒有任何國家、政黨可以干預、操作，兩岸要和平，但對方也要了解中華民國政府存在的事實。  宋楚瑜哽咽說，他會大破大立、撥亂反正，且只做一任、沒有包袱。最後他帶頭高喊「台灣自由民主萬歲，中華民國萬歲」，並宣讀政務官就職誓詞。  宋鎮邁表示，很多人覺得這位伯伯很老，其實他不老，只是出道得早，她相信父親可以傳承經驗、組成堅強團隊為大家貢獻，「這是最好的老爸，也會是最好的總統」。  宋鎮邁感嘆，這次選舉有很多謾罵、誤解，很多人說「我討厭你、想要下架你」其實很不健康，與公民素養背道而馳，她爸爸會堅持中道，讓每個人都能放心衝自己的夢想，發揚台灣，「We’re very small but we’re great.」"
print ("Input：", sentence)
words = jieba.cut(sentence, cut_all=False)

#比對停用詞，保留剩餘詞彙
remainderWords=[]
remainderWords = list(filter(lambda a: a not in stopWords and a != "\n", words))

print(remainderWords)

'
DECLARE @ss NVARCHAR(1024)=  (
SELECT
       [News]
  FROM [MyNews].[dbo].[News]
  WHERE [NewsId]=3  )
 SELECT @ss 

EXEC #TempPP @ss;

ALTER PROC #TempPP @ss NVARCHAR(MAX) 
AS
	EXECUTE sp_execute_external_script @language = N'Python',  
	  @script = N'   
import jieba
#jieba.set_dictionary("dict.txt.big")

#讀入停用詞
stopWords=[]
with open("C:\\PP\\MyStopWords.txt", "r", encoding="UTF-8") as file:
    for data in file.readlines():
        data = data.strip()
        stopWords.append(data)

print ("ss = ", sentence)
print ("Input：", sentence)
words = jieba.cut(sentence, cut_all=False)

#比對停用詞，保留剩餘詞彙
remainderWords=[]
remainderWords = list(filter(lambda a: a not in stopWords and a != "\n", words))

print(remainderWords)
';
GO