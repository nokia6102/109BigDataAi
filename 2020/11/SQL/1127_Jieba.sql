EXEC sp_execute_external_script  
	@language = N'Python'  
	, @script = N'
import jieba
#jieba.set_dictionary("dict.txt.big")

sentence = "�W�߭��ֻݭn�j�a�@�_�ӱ��s�A�w��[�J�ڭ̪���C�I"
print ("Input�G", sentence)
words = jieba.cut(sentence, cut_all=False)
print ("Output ��T�Ҧ� Full Mode�G")
for word in words:
	print (word)'
