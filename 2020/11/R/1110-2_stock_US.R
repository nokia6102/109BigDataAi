# ������
#7
install.packages("quantmod")
library(quantmod)
getSymbols("AAPL")
chartSeries(AAPL)
chartSeries(AAPL["2016-01::2020-11"],theme = "white")

���u20 <- runMean(AAPL[ ,4],n = 20)
���u60 <- runMean(AAPL[ ,4],n = 60)
addTA(���u20 ,on=1 ,col="blue")
addTA(���u60 ,on=1 ,col="red")

#8
# ���u����:��20ma�j��60m�ɥ����R�i;��20ma�p��60ma��,�Ť�C��J���O:
position <- Lag(ifelse(���u20>���u60,1,0))
# �ѻ�:positio���@�Ӯɶ��ǦC???�H�鬰���p�G20m�j��60ma,�]�Ȭ�1;
# �_�h�]�Ȭ�0�ѩ�ڭ̬O����,�T���o�ͮɥu��j�Ѱ����,
# �G�N�o�V�q�������Ỽ���@�ѡC

return <- ROC(Cl(AAPL))*position
#�ѻ�:ROC�p��:10g(���Ѧ��L��/�Q�Ѧ��L��)���Wpoistion�N���C
#�Y1�h����,�Y0�h�Ť�C

return <- return['2017-03-30/2020-11-09']
#�ѻ�:�ѩ�ڭ̵�������O60ma>20m����~�|����G�έp�ȱq2017-03-30�}�l;

return <- exp(cumsum(return))
# �ѻ�:cumsu�p��֭p�ȧY�N�C�@���q���e���Ȳ֥[�_�ӡC
# ��exp��ƬO�n�p��֭p�l��C
# (�o�̹B�μƾ�:1og(a)+1og(b)=1og(ab) sexp(1og(ab))-ab)


plot(return)
# �ѻ�:�N�֭p�l�q�ϵe�X�ӡC
# ���������l�q�ϧΦp�U,��b���ɶ��b,�a�b�����S�v,1�N����l�ۦ����100%�C
# �ѹϥi��,�γo��²�檺�����겣���½�F�N��2.5��!


#��L�޳N����
#�M��quantmod�]�]�t�F��޳N���СA???�`�Ϊ��ڷQ�N�O���F�q�D�C

#�A�e�X�ѻ����չϫ�A�A��J���O addBBands()
  addBBands()
#�e�b�U��
addBBands(draw="p")

#��1.0�N���ѻ��I�쥬�F�q��W�t�A0.0�N���ѻ��I�쥬�F�q��U�t�C
#Bollinger%b������(Close-LowerBound) / (UpperBound-LowerBound)