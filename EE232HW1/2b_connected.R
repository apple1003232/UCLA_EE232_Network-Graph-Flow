library(igraph)
h<-0
for(i in 1:200){
  g<-barabasi.game(1000,directed=FALSE)
  if(is.connected(g)) h<-h+1}
h/200
