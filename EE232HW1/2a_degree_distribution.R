
library(igraph)
d<- rep(0,200)
dd<- rep(0,200)
for(i in 1:100){
  g<- barabasi.game(1000,directed=FALSE)
  ddtemp<- degree.distribution(g)
  dd<-dd+c(ddtemp,rep(0,200-length(ddtemp)))}
plot(seq(along=dd)-1,dd/100,log="xy",xlab="degree",ylab="density")

x<-seq(along=dd)-1
y<-3*x^(-3)
lines(x,y,col='red')
