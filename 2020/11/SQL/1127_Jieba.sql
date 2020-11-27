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
	print (word)'
