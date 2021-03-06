
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

#收益率=淨利潤/成本={ (賣-買) * 股份-手續費 } /(買價*股份+買時費用)
#假設們買持有10年不動，假設定份沒有變化，在不考慮手續費時，計算公式可以簡化：
#收益率=淨利潤/成本=(賣價-買價)/買價


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

chart_Series(Cl(MT),name = "貴洲茅台")
chart_Series(Cl(SY),name = "三一重工")
chart_Series(Cl(ZB),name = "正邦科技")



# 分???用ATR和ADX指標進行分析
# 採用ATR和AD指標進行分析股價波動大小和趨勢強弱。
# AT是「真實波動浮動均值」。常態時,A波幅圍繞均線上下波動極端行情時波幅上下幅度劇烈加大。
# 一般認為,AT指標越高,價格趨勢逆轉的幾率越大。
# 作為一個波動性的指標,A只提供波動性啟示,無法預測股價方向。
# ADX是平均趨向指標。它是另一種常用的趨勢衡量指標。
# 它無法告訴你趨勢的發展方向,但如果趨勢存在可以衡量趨勢的強度。
# 添加ATR線和ADX線的月K線圖。代碼如下

chartSeries(to.monthly(data1),name = "貴洲茅台",theme = "white")
addATR()
addADX()
chartSeries(to.monthly(data2),name = "三一重工",theme = "white")
addATR()
addADX()
chartSeries(to.monthly(data3),name = "正邦科技",theme = "white")
addATR()
addADX()

ss <- getSymbols(c("000001.ss","600519.ss","600031.ss","002157.sz",src="yahoo",from="2007-08-31",to="2017-08-31"))
AD <- cbind(Ad(`000001.SS`),Ad(`600519.SS`),Ad(`600031.SS`),Ad(`002157.SZ`))
AD <- as.data.frame(AD)

cor(AD[,c(1, 2:3)])
install.packages("psych")
library(psych)
corr.test(AD)
