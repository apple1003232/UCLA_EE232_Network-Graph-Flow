library(igraph)
library(netrw)

#prob_1_a
graph1 <- random.graph.game(1000, 0.01, directed=FALSE) #1000 nodes
diameter(graph1)

#prob_1_b
  avg<-rep(NA,1000)#average
  dev<-rep(NA,1000)#standard deviation
  for(i in (1:1000))
  {
    r1<- netrw(graph1, walker.num=1000, start.node=1:1000, damping=1, T=i, output.walk.path=TRUE)
    temp <- rep(NA,1000)
    for(j in (1:1000))
    {
      a <-get.shortest.paths(graph1, from=r1$walk.path[1,j], to=r1$walk.path[i,j])
      temp[j]<-length(a$vpath[[1]])-1
    }
    avg[i] = mean(temp)
    dev[i] = sd(temp)
  }
  
  plot(1:1000,avg,xlab="Number of Steps",ylab="Average Distance",main="Random Network of 1000 Nodes")
  plot(1:1000,dev,xlab="Number of Steps",ylab="Standard Deviation of the Distance",main="Random Network of 1000 Nodes")
  
#prob_1_d
graph2 <- random.graph.game(100, 0.01, directed=FALSE) #100 nodes
avg2<-rep(NA,100)#average
dev2<-rep(NA,100)#standard deviation   
for(i in (1:100))
{
  r2<- netrw(graph2, walker.num=100, start.node=1:100, damping=1, T=i, output.walk.path=TRUE)
  temp2 <- rep(NA,100)
  for(j in (1:100))
  {
    a2 <-get.shortest.paths(graph2, from=r2$walk.path[1,j], to=r2$walk.path[i,j])
    temp2[j]<-length(a2$vpath[[1]])-1
  }
  avg2[i] = mean(temp2)
  dev2[i] = sd(temp2)
}

plot(1:100,avg2,xlab="Number of Steps",ylab="Average Distance",main="Random Network of 100 Nodes")
plot(1:100,dev2,xlab="Number of Steps",ylab="Standard Deviation of the Distance",main="Random Network of 100 Nodes")

graph3<- random.graph.game(10000, 0.01, directed=FALSE) #10000 nodes
avg<-rep(NA,10000)#average
dev<-rep(NA,10000)#standard deviation
for(i in (1:10000))
{
  r1<- netrw(graph3, walker.num=100, start.node=1:100, damping=1, T=i, output.walk.path=TRUE)
  temp <- rep(NA,100)
  for(j in (1:100))
  {
    a <-get.shortest.paths(graph3, from=r1$walk.path[1,j], to=r1$walk.path[i,j])
    temp[j]<-length(a$vpath[[1]])-1
  }
  avg[i] = mean(temp)
  dev[i] = sd(temp)
}

plot(1:10000,avg,xlab="Number of Steps",ylab="Average Distance",main="Random Network of 10000 Nodes")
plot(1:10000,dev,xlab="Number of Steps",ylab="Standard Deviation of the Distance",main="Random Network of 10000 Nodes")

print(diameter(graph2))
print(diameter(graph1))

#prob_1_e

dd<-rep(0,200*1000)
for(j in 1:200){
  graph1 <- random.graph.game(1000, 0.01, directed=FALSE)
  for(i in 1:1000)
    dd[1000*(j-1)+i]<-degree(graph1,i)
}
h<-hist(dd,breaks=seq(-0.5, by=1 , length.out=max(dd)+2))
pl <- data.frame(x=h$mids, y=h$density)
plot(pl,xlab="Degree",ylab="Density",main="Degree Distribution of Graph of 1000 Nodes Network")

dgr <- rep(NA,200*1000)
for(j in 1:200){
  graph1 <- random.graph.game(1000, 0.01, directed=FALSE)
  r1<- netrw(graph1, walker.num=1000,start.node=1:1000, damping=1, T=1000, output.walk.path=TRUE)

for(i in (1:1000))
  dgr[1000*(j-1)+i] = degree(graph1,r1$walk.path[1000,i])
}
h<-hist(dgr,breaks=seq(-0.5, by=1 , length.out=max(dgr)+2))
pl <- data.frame(x=h$mids, y=h$density)
plot(pl,type="p",xlab="Degree",ylab="Density",main="Degree Distribution of the Nodes Reached at the End of the Random Walk")

