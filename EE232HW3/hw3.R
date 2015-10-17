library("igraph")

#Part 1 
file = scan("D:/Rtemp/sorted_directed_net.txt", what=list(0,0,0))
fromNode <- file[[1]] + 1
toNode <- file[[2]] + 1
el <- cbind(fromNode, toNode)
g <- graph.edgelist(el, directed=TRUE); 
E(g)$weight <- file[[3]];
is.connected(g)# FALSE: the graph is not connected

#find the gcc
cl <- clusters(g, mode="strong")
gccIndex = which.max(cl$csize)
nonGccNodes <- (1:vcount(g))[cl$membership != gccIndex]
gcc <- delete.vertices(g, nonGccNodes)
gccNodes <- (1:vcount(g))[cl$membership == gccIndex]

#Part 2
outDegree<-degree(gcc, mode="out")
inDegree<-degree(gcc, mode="in")

#degree distribution of out-degree
oh <- hist(outDegree, breaks=seq(-0.5, by=1 , length.out=max(outDegree)+2))
opl <- data.frame(x=oh$mids, y=oh$density)
plot(opl , type="o", xlab="Nodes",ylab="In-degree",main="Degree distribution of in-degree of the nodes")

#degree distribution of in-degree
ih <- hist(inDegree, breaks=seq(-0.5, by=1 , length.out=max(inDegree)+2))
ipl <- data.frame(x=ih$mids, y=ih$density)
plot(ipl , type="o", xlab="Nodes",ylab="In-degree",main="Degree distribution of in-degree of the nodes")

#Part 3
g2undirected <- as.undirected(gcc,mode="collapse", edge.attr.comb=list(weight=function(x) sqrt(prod(x))))
#option2: merge edges
#fastgreedy
community_fast <- fastgreedy.community(g2undirected)
cmsize_fast<- sizes(community_fast)
hist(community_fast$membership, xlab="Community Membership Number", ylab="Frequency")

h_fast <- hist(cmsize_fast, breaks=seq(-0.5, by=1 , length.out=max(cmsize_fast)+2))
pl_fast <- data.frame(x=h_fast$mids, y=h_fast$density)
plot(pl_fast,type="p",xlab="size of community",ylab="density",main="Size of community using fastgreedy.community")
mean(community_fast$modularity)#0.2622914

#option 2
#label.propagation
community_label <- label.propagation.community(g2undirected)
cmsize_label<- sizes(community_label)
#hist(community_label$membership, xlab="Community Membership Number", ylab="Frequency")

h_label <- hist(cmsize_label, breaks=seq(-0.5, by=1 , length.out=max(cmsize_label)+2))
pl_label <- data.frame(x=h_label$mids, y=h_label$density)
plot(pl_label,type="p",xlab="size of community",ylab="density",main="Size of community using label.propagation.community")
mean(community_label$modularity)#0.0001698002
hist(community_label$membership, xlab="Community Membership Number", ylab="Frequency")

#Part 4 
cmIndex = which.max(sizes(community_fast))[[1]]
gccNodes <- (1:vcount(g))[cl$membership == gccIndex]
cm_largestNodes <- gccNodes[community_fast$membership == cmIndex]

sub_graph <- induced.subgraph(g, vids=cm_largestNodes)
sub_g2undirected <- as.undirected(sub_graph,mode="collapse", edge.attr.comb=list(weight=function(x) sqrt(prod(x))))

sub_community <- fastgreedy.community(sub_g2undirected)
sub_size<- sizes(sub_community)
h_sub <- hist(sub_size, breaks=seq(-0.5, by=1 , length.out=max(sub_size)+2))
pl_sub <- data.frame(x=h_sub$mids, y=h_sub$density)
plot(pl_sub,type="p",xlab="size of community",ylab="density",main="Size of sub-community of the largest community using fastgreedy.community")
modularity(sub_community)#0.3626932

#Part 5
cm100Index = which(sizes(community_fast)>100)
sub_graph100 <- c()
sub_community100 <- c()
sub_g2undirected100 <- c()

 
for(i in 1:length(cm100Index)){
cmNodes <- gccNodes[community_fast$membership == cm100Index[[i]]]
sub_graph100[[i]] <- induced.subgraph(g, vids=cmNodes)
sub_g2undirected100[[i]] <- as.undirected(sub_graph100[[i]],mode="collapse", edge.attr.comb=list(weight=function(x) sqrt(prod(x))))

sub_community100[[i]] <- fastgreedy.community(sub_g2undirected100[[i]])
}
sub_community100

for(k in 1:length(cm100Index))
{
  hist(sub_community100[[k]]$membership, xlab="Community Membership Number", ylab="Frequency", main=paste("Histogram of Community Structure",k))
  cmsize_100<- sizes(sub_community100[[k]])
  h_100<- hist(cmsize_100, breaks=seq(-0.5, by=1 , length.out=max(cmsize_100)+2))
  pl_100 <- data.frame(x=h_100$mids, y=h_100$density)
  plot(pl_100,type="p",xlab="size of community",ylab="density",main=paste("Histogram of Community Structure",k))
}
modu<-c()
for(k in 1:length(cm100Index))
{
modu[k]<-mean(sub_community100[[k]]$modularity)
}
modu
#Part 6

library("netrw")
#install.packages("hash")
library("hash")

rw <- netrw(graph=gcc, walker.num=length(V(gcc)), start.node=sample(1:(vcount(gcc))), damping=0.85, T=length(V(gcc)), output.walk.path=TRUE, output.visit.prob=TRUE) 

master_hash <- hash(V(gcc), rep(0,length(V(gcc))))
node_multi_comm <- c()

for(i in 1:length(V(gcc)))
{
  h <- hash(1:15, rep(0,15))
  
  c1 <- 1:length(V(gcc))
  c2 <- rw$visit.prob[,i]
  mat <- cbind(c1,c2)
  mat <- mat[order(mat[,2], decreasing=TRUE), ]
  for(j in 1:30)
  {
    m <- community_fast$membership[mat[j,][1]]
    v <- mat[j,][2]
    curr_value <- values(h, keys=m)
    curr_value <- curr_value + (m*v) 
    .set(h, keys=m, values=curr_value)
  }
  for (j in 1:15) 
  {
    val <- values(h, keys=j)
    if (val < 0.01)
    {
      .set(h, keys=j, values=0)
    }
  }
  .set(master_hash, keys=i,values=h)
  if(length(which(values(values(master_hash, keys = i)[[1]]) > 0)) > 1)
    node_multi_comm <- append(node_multi_comm,i)
}

#display 3 nodes belonging to different communities
length(node_multi_comm)
node_values = sample(node_multi_comm,3)
node_values

for (i in node_values) {
  print (values(master_hash, keys=i))
}

