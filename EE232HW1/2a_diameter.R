library(igraph)
d<-0
for(i in 1:200){
  g<-barabasi.game(1000,directed=FALSE)
  d<- d+diameter(g)}
d/200
