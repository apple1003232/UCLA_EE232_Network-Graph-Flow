library(igraph)
g<- forest.fire.game(1000, fw.prob=0.37, bw.factor=0.32/0.37)
fc <- walktrap.community(g)
m<- sizes(fc)
for(i in 1:99){
  g<- forest.fire.game(1000, fw.prob=0.37, bw.factor=0.32/0.37)
  fc <- walktrap.community(g)
  temp<- sizes(fc)
  m<-rbind(m,temp)}
h <- hist(m, breaks=seq(-0.5, by=1 , length.out=max(m)+2))
pl <- data.frame(x=h$mids, y=h$density)
plot(pl,type="p",xlab="size of community",ylab="density",main="size of community")
