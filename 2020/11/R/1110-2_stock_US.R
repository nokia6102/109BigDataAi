# 玩美股
#7
install.packages("quantmod")
library(quantmod)
getSymbols("AAPL")
chartSeries(AAPL)
chartSeries(AAPL["2016-01::2020-11"],theme = "white")

均線20 <- runMean(AAPL[ ,4],n = 20)
均線60 <- runMean(AAPL[ ,4],n = 60)
addTA(均線20 ,on=1 ,col="blue")
addTA(均線60 ,on=1 ,col="red")

#8
# 均線策略:當20ma大於60m時全壓買進;當20ma小於60ma時,空手。輸入指令:
position <- Lag(ifelse(均線20>均線60,1,0))
# 解說:positio為一個時間序列???以日為單位如果20m大於60ma,設值為1;
# 否則設值為0由於我們是日資料,訊號發生時只能隔天做交易,
# 故將這向量全部往後遞延一天。

return <- ROC(Cl(AAPL))*position
#解說:ROC計算:10g(今天收盤價/昨天收盤價)乘上poistion代表。
#若1則持有,若0則空手。

return <- return['2017-03-30/2020-11-09']
#解說:由於我們策略條件是60ma>20m之後才會交易故統計值從2017-03-30開始;

return <- exp(cumsum(return))
# 解說:cumsu計算累計值即將每一分量之前的值累加起來。
# 取exp函數是要計算累計損亦。
# (這裡運用數學:1og(a)+1og(b)=1og(ab) sexp(1og(ab))-ab)


plot(return)
# 解說:將累計損益圖畫出來。
# 此策略的損益圖形如下,橫軸為時間軸,縱軸為報酬率,1代表原始自有資金100%。
# 由圖可知,用這最簡單的策略資產整整翻了將近2.5倍!


#其他技術指標
#套件quantmod也包含了其技術指標，???常用的我想就是布靈通道。

#再畫出股價走勢圖後，再輸入指令 addBBands()
  addBBands()
#畫在下方
addBBands(draw="p")

#當1.0代表股價碰到布靈通到上緣，0.0代表股價碰到布靈通到下緣。
#Bollinger%b公式為(Close-LowerBound) / (UpperBound-LowerBound)
