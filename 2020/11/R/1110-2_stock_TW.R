#���x��
install.packages("quantmod")
library(quantmod)
#�e10 �~
s_day <- Sys.Date() - 3600
e_day <- Sys.Date()
�϶� <- "2018-01::2020-11"
getSymbols("2330.TW", from = s_day, to = e_day)
TSMC <- ("2330.TW")
x <- get(TSMC)
barChart(X)

my_name <- paste("�x�n�Ͷ�","�ثe����",sep = '-')
chartSeries(x[�϶�], theme = "black" ,name = my_name)

���u20 <- runMean(x[,4],n = 20)
���u60 <- runMean(x[,4],n = 60)
addTA(���u20 ,on=1 ,col="yellow")
addTA(���u60 ,on=1 ,col="red")
position <- Lag(ifelse(���u20 > ���u60, 1, 0))
return <- ROC(C1(X)) * position
plot(return)
