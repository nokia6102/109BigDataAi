#install.packages("ggplot2")
#install.packages("GGally")
library(ggplot2)
library(GGally)
head(economics)
print ("使用函數算相關系數")
cor(economics$pce,economics$psavert)

xPart <- economics$pce - mean(economics$pce)
yPart <- economics$psavert - mean(economics$psavert)
nMinuseOne <- (nrow(economics) -1 )
xSD <- sd(economics$pce)
ySD <- sd(economics$psavert)
print ("自己用公式算出相關系數")
sum (xPart * yPart) / (nMinuseOne * xSD * ySD)

cor(economics[, c(2,4:6)])
GGally::ggpairs(economics[, c(2, 4:6)])

#----
 
#install.packages("reshape2")
library(reshape2)

#install.packages("scales")
library(scales)
econCor <- cor(economics[,c(2, 4:6)])
econMelt <- melt(econCor,varnames = c("x","y"), value.name="Correlation")
econMelt <- econMelt[order(econMelt$Correlation), ]
ggplot(econMelt,aes(x = x,y = y) ) + 
  geom_tile(aes(fill=Correlation))+
  scale_fill_gradient2(low="black", mid="white", high="steelblue",guide = guide_colorbar(ticks = FALSE,barheight = 10), limits=c(-1,1)) +
  theme_minimal()+
  labs(x=NULL,y=NULL)

