library(igraph)
dd1<-rep(0,220)
dd2<-rep(0,220)
for(i in 1:100){
  g <- forest.fire.game(1000, fw.prob=0.37, bw.factor=0.32/0.37)
  temp1<- degree.distribution(g, mode="in")
  temp2<- degree.distribution(g, mode="out")
  dd1 <-dd1+c(temp1,rep(0,220-length(temp1)))
  dd2 <-dd2+c(temp2,rep(0,220-length(temp2)))}
if (interactive()) {
  plot(seq(along=dd1)-1, dd1/100, log="xy", xlab="degree",ylab="density")
  points(seq(along=dd2)-1, dd2/100, col=2, pch=2)
}
