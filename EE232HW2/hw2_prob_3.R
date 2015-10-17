library(igraph)
library(netrw)

#prob_3_a
graph1 <- random.graph.game(1000, 0.01, directed=FALSE); #1000 nodes, undirected

  r1<- netrw(graph1, walker.num=1000,start.node=1:1000, damping=1, T=1000, output.walk.path=TRUE)
  plot(r1$ave.visit.prob,xlab="Nodes",ylab="Visit Probablity",pch=1)
  
  dgr<- c()
  vProb <- c()

  for(j in r1$walk.path[,1])
  {
    dgr<-append(dgr,degree(graph1,j))
    vProb<-append(vProb,r1$ave.visit.prob[j])
  }


  relation<- rbind(dgr,vProb)
  relation<- relation[,order(relation[1,])]  #order by degree
  plot(relation[1,],relation[2,],xlab="Degree",ylab="Visit Probablity", main="Relation Between Degree and Visit Probability for Undirected Network")

#prob_3_b
graph2 <- random.graph.game(1000, 0.01, directed=TRUE); #1000 nodes, directed
r1<- netrw(graph2, walker.num=1000,start.node=1:1000, damping=1, T=1000, output.walk.path=TRUE)
plot(r1$ave.visit.prob,xlab="Nodes",ylab="Visit Probablity",pch=1)

dgr<- c()
vProb <- c()
  for(j in r1$walk.path[,1])
  {
    dgr<-append(dgr,degree(graph2,j))
    vProb<-append(vProb,r1$ave.visit.prob[j])
  }

relation<- rbind(dgr,vProb)
relation<- relation[,order(relation[1,])]  #order by degree
plot(relation[1,],relation[2,],xlab="Degree",ylab="Visit Probablity", main="Relation Between Degree and Visit Probability for Directed Network")

#prob_3_c
r1<- netrw(graph1, walker.num=1000,start.node=1:1000, damping=0.85, T=1000, output.walk.path=TRUE)
plot(r1$ave.visit.prob,xlab="Nodes",ylab="Visit Probablity",pch=1)

dgr<- c()
vProb <- c()
  for(j in r1$walk.path[,1])
  {
    dgr<-append(dgr,degree(graph1,j))
    vProb<-append(vProb,r1$ave.visit.prob[j])
  }


relation<- rbind(dgr,vProb)
relation<- relation[,order(relation[1,])]  #order by degree
plot(relation[1,],relation[2,],xlab="Degree",ylab="Visit Probablity", main="Relation Between Degree and Visit Probability for Undirected Network")

