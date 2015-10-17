library(igraph)
d1<-0
for(i in 1:200){
g1<-erdos.renyi.game(1000,0.01)
d1<- d1+diameter(g1)}
d1/200
d2<-0
for(i in 1:200){
g2<-erdos.renyi.game(1000,0.05)
d2<- d2+diameter(g2)}
d2/200
d3<-0
for(i in 1:200){
g3<-erdos.renyi.game(1000,0.1)
d3<- d3+diameter(g3)}
d3/200
