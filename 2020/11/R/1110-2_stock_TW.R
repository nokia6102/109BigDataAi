#玩台股
install.packages("quantmod")
library(quantmod)
#前10 年
s_day <- Sys.Date() - 3600
e_day <- Sys.Date()
區間 <- "2018-01::2020-11"
getSymbols("2330.TW", from = s_day, to = e_day)
TSMC <- ("2330.TW")
x <- get(TSMC)
barChart(X)

my_name <- paste("台積趨勢","目前價值",sep = '-')
chartSeries(x[區間], theme = "black" ,name = my_name)

均線20 <- runMean(x[,4],n = 20)
均線60 <- runMean(x[,4],n = 60)
addTA(均線20 ,on=1 ,col="yellow")
addTA(均線60 ,on=1 ,col="red")
position <- Lag(ifelse(均線20 > 均線60, 1, 0))
return <- ROC(C1(X)) * position
plot(return)

