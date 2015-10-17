library(igraph)
mod<-0
for(i in 1:200){
  g<-barabasi.game(10000,directed=FALSE)
  fc<-fastgreedy.community(g)
  mod<-mod+modularity(fc)
}
mod/200
