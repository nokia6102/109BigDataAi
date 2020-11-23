
install.packages("quantmod")
install.packages("dplyr")
install.packages("stringr")

library(quantmod)
library(dplyr)
library(stringr)


data1 <- getSymbols("600519.ss",src = "yahoo",from="2010-01-01",to="2020-11-01",auto.assign = FALSE)
data2 <- getSymbols("600031.ss",src = "yahoo",from="2010-01-01",to="2020-11-01",auto.assign = FALSE)
data3 <- getSymbols("002157.ss",src = "yahoo",from="2010-01-01",to="2020-11-01",auto.assign = FALSE)


write.csv(data1,file = "data/600519.csv")
write.csv(data2,file = "data/600031.csv")
write.csv(data3,file = "data/002157.csv")

#���q�v=�b�Q��/����={ (��-�R) * �ѥ�-����O } /(�R��*�ѥ�+�R�ɶO��)
#���]�̶R����10�~���ʡA���]�w���S���ܤơA�b���Ҽ{����O�ɡA�p�⤽���i�H²�ơG
#���q�v=�b�Q��/����=(���-�R��)/�R��


MT <- to.weekly(data1)
SY <- to.weekly(data2)
ZB <- to.weekly(data3)

MTclose <- Cl(MT)
MTrate10 <- ( as.numeric(MTclose[554,1]) - as.numeric(MTclose[1,1]))*100/as.numeric(MTclose[1,1] )
MTrate10 <- round(MTrate10,2)

SYclose <- Cl(SY)
SYrate10 <- ( as.numeric(SYclose[554,]) - as.numeric(SYclose[1,1]))*100/as.numeric(SYclose[1,] )
SYrate10 <- round(MTrate10,2)


ZBclose <- Cl(ZB)
ZBrate10 <- ( as.numeric(ZBclose[429,]) - as.numeric(ZBclose[1,1]))*100/as.numeric(ZBclose[1,] )
ZBrate10 <- round(ZBrate10,2)

chart_Series(Cl(MT),name = "�Q�w�T�x")
chart_Series(Cl(SY),name = "�T�@���u")
chart_Series(Cl(ZB),name = "�������")



# ��???��ATR�MADX���жi����R
# �ĥ�ATR�MAD���жi����R�ѻ��i�ʤj�p�M�Ͷձj�z�C
# AT�O�u�u��i�ʯB�ʧ��ȡv�C�`�A��,A�i�T��¶���u�W�U�i�ʷ��ݦ污�ɪi�T�W�U�T�׼@�P�[�j�C
# �@��{��,AT���жV��,�����Ͷհf�઺�X�v�V�j�C
# �@���@�Ӫi�ʩʪ�����,A�u���Ѫi�ʩʱҥ�,�L�k�w���ѻ���V�C
# ADX�O�����ͦV���СC���O�t�@�ر`�Ϊ��ͶտŶq���СC
# ���L�k�i�D�A�Ͷժ��o�i��V,���p�G�Ͷզs�b�i�H�Ŷq�Ͷժ��j�סC
# �K�[ATR�u�MADX�u����K�u�ϡC�N�X�p�U

chartSeries(to.monthly(data1),name = "�Q�w�T�x",theme = "white")
addATR()
addADX()
chartSeries(to.monthly(data2),name = "�T�@���u",theme = "white")
addATR()
addADX()
chartSeries(to.monthly(data3),name = "�������",theme = "white")
addATR()
addADX()

ss <- getSymbols(c("000001.ss","600519.ss","600031.ss","002157.sz",src="yahoo",from="2007-08-31",to="2017-08-31"))
AD <- cbind(Ad(`000001.SS`),Ad(`600519.SS`),Ad(`600031.SS`),Ad(`002157.SZ`))
AD <- as.data.frame(AD)

cor(AD[,c(1, 2:3)])
install.packages("psych")
library(psych)
corr.test(AD)