library(igraph)
library(netrw)
edgelistFile <- "/Users/luanzhang/Dropbox/ucla/EE232/project_2/actor_directed.txt"
graph <- read.graph(edgelistFile , format = "ncol" , directed=TRUE)
file = scan(edgelistFile, what=list(0,0,0))

r1<- netrw(graph, walker.num=1000,start.node=1:1000, damping=1, T=1000, output.walk.path=TRUE)
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

#problem 3
#edgelistFile <- "/Users/luanzhang/Dropbox/ucla/EE232/project_2/actor_directed.txt"

#g <- read.graph(edgelistFile , format = "ncol" , directed=T)
file = scan(file.choose(), what=list(0,0,0))
fromNode <- file[[1]]+1
toNode <- file[[2]]+1
el <- cbind(fromNode, toNode)
g <- graph.edgelist(el, directed=TRUE); 
E(g)$weight <- file[[3]];
PageRank<-page.rank(g)$vector
h <- hist(PageRank, breaks=seq(-0.00001, 0.000165, by=0.0000005))
pl <- data.frame(x=h$mids, y=h$density)
plot(pl, type="l", xlab="PageRank",ylab="Density")
for(i in 1:10)
{
  out<-order(PageRank,decreasing = T)[i]
  print(out)
}


#problem 5
#el_movie <- "/Users/luanzhang/Dropbox/ucla/EE232/project_2/movie_undirected.txt"
#movie_undirected <- read.graph(el_movie , format = "ncol" , directed=FALSE)
file = scan(file.choose(), what=list(0,0,0))
fromNode <- file[[1]]+1
toNode <- file[[2]]+1
el <- cbind(fromNode, toNode)
g2 <- graph.edgelist(el, directed=FALSE); 
E(g2)$weight <- file[[3]];


fc <- fastgreedy.community(g2)

index <- which(sizes(fc)>0)
for(i in 1:length(index)){
out<-c()
  communityNodes <- (1:vcount(g2))[fc$membership == index[i]]
out<-c(index[i],communityNodes)
write.table("start", file = "/Users/luanzhang/Dropbox/ucla/EE232/project_2/movie_community.txt", append = T, quote = F, sep = "\t",
            eol = "\n", row.names = F,
            col.names = F)
write.table(out, file = "/Users/luanzhang/Dropbox/ucla/EE232/project_2/movie_community.txt", append = T, quote = F, sep = "\t",
            eol = "\n", row.names = F,
            col.names = F)

}
write.table("start", file = "/Users/luanzhang/Dropbox/ucla/EE232/project_2/movie_community.txt", append = T, quote = F, sep = "\t",
            eol = "\n", row.names = F,
            col.names = F)
