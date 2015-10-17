library(igraph)
m<-0
for(i in 1:100){
g1<- aging.prefatt.game(1000,pa.exp=1, aging.exp=-1,directed=FALSE)
fc <- fastgreedy.community(g1)
m<-m+ modularity (fc)}
m/100
