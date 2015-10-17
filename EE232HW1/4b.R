library(igraph)
d<-0
for(i in 1:100){
  g<-forest.fire.game(1000, fw.prob=0.37, bw.factor=0.32/0.37)
  d<- d+diameter(g)}
d/100
