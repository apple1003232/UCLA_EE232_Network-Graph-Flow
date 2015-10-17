library(igraph)
library(netrw)

#4.a
g_a<-random.graph.game(1000, 0.01, directed=TRUE)
net1<-netrw(g_a, walker.num=1000,start.node=1:vcount(g_a),damping=0.85,T=1000, output.walk.path=TRUE)
plot(net1$ave.visit.prob,xlab="Nodes",ylab="Visit Probablity",main="Simulate PageRank with Random Walk ",pch=1)

#4.b
pr<-page.rank(g_a,directed=TRUE,damping=0.85)
net2<-netrw(g_a, walker.num=1000,start.node=1:vcount(g_a),damping=0.85,teleport.prob=pr$vector,T=1000, output.walk.path=TRUE)
plot(net2$ave.visit.prob,xlab="Nodes",ylab="Visit Probablity",main="Simulate Personalized PageRank with Random Walk ",pch=1)

#4.c

