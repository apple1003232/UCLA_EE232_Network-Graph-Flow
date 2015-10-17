library(igraph)
g1<- aging.prefatt.game(1000,pa.exp=1, aging.exp=-1,directed=FALSE)
fc <- fastgreedy.community(g1)
m<- sizes(fc)
for(i in 1:99){
g1<- aging.prefatt.game(1000,pa.exp=1, aging.exp=-1,directed=FALSE)
fc <- fastgreedy.community(g1)
temp<- sizes(fc)
m<-rbind(m,temp)}
h <- hist(m, breaks=seq(-0.5, by=1 , length.out=max(m)+2))
pl <- data.frame(x=h$mids, y=h$density)
plot(pl,type="p",xlab="size of community",ylab="density",main="size of community")
