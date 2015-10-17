library(igraph)
d<- rep(0,10000)
dd<- rep(0,1000)
for(i in 1:200){
  g<- barabasi.game(10000,directed=FALSE)
  dtemp<-degree(g)
  ddtemp<- degree.distribution(g)
  d<-d+c(dtemp)
  dd<-dd+c(ddtemp,rep(0,1000-length(ddtemp)))}
x<-seq(along=dd)-1
plot(x,dd/200,xlab="degree",ylab="density",log="xy")
x<-seq(along=dd)-1
y<-3*x^(-3)
lines(x,y,col='red')
