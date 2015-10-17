library(igraph)
degree1<- rep(0,250)
for(i in 1:100){
g1<-erdos.renyi.game(1000,0.01)
temp<- degree.distribution(g1)
degree1<-degree1+c(temp,rep(0,250-length(temp)))}
plot(seq(along=degree1)-1,degree1/100,xlab="degree",ylab="density")
degree2<- rep(0,250)
for(i in 1:100){
g2<-erdos.renyi.game(1000,0.05)
temp<- degree.distribution(g2)
degree2<-degree2+c(temp,rep(0,250-length(temp)))}
points(seq(along=degree2)-1,degree2/100,col=2)
degree3<- rep(0,250)
for(i in 1:100){
g3<-erdos.renyi.game(1000,0.1)
temp<- degree.distribution(g3)
degree3<-degree3+c(temp,rep(0,250-length(temp)))}
points(seq(along=degree3)-1,degree3/100,col=3)
