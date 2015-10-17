library(igraph)
library(netrw)

#2.a)
g2_a = barabasi.game(1000,directed=FALSE)
diameter(g2_a)
#2.b)

st<-rep(NA,1000)#average
dev<-rep(NA,1000)#standard deviation
for(t in (1:1000)){#step
net<-netrw(g2_a, walker.num=1000,start.node=1:vcount(g2_a), T=t, damping=1, output.walk.path=TRUE)
d<-rep(NA,1000)#distance
  for(w in (1:1000)){#walker
    from_node<-net$walk.path[1,w]
    to_node<-net$walk.path[t,w]
    short_d<-get.shortest.paths(g2_a, from=from_node, to=to_node)
    d[w]<-length(short_d$vpath[[1]])-1
  }
st[t] = mean(d)
dev[t] = sd(d)
}
plot(1:1000,st,xlab="Number of Steps",ylab="Average Distance",main="Fat-tailed Network of 1000 Nodes")
plot(1:1000,dev,xlab="Number of Steps",ylab="Standard Deviation of the Distance",main="Fat-tailed Network of 1000 Nodes")

#2.d)
g2_d1 <- barabasi.game(100,directed=FALSE)#100 nodes fat-tailed
st<-rep(NA,100)#average
dev<-rep(NA,100)#standard deviation
for(t in (1:100)){#step
  net<-netrw(g2_d1, walker.num=100,start.node=1:vcount(g2_d1), T=t, damping=1, output.walk.path=TRUE)
  d<-rep(NA,100)#distance
  for(w in (1:100)){#walker
    from_node<-net$walk.path[1,w]
    to_node<-net$walk.path[t,w]
    short_d<-get.shortest.paths(g2_d1,from=from_node,to=to_node)
    d[w]<-length(short_d$vpath[[1]])-1
  }
  st[t] = mean(d)
  dev[t] = sd(d)
}
plot(1:100,st,xlab="Number of Steps",ylab="Average Distance",main="Fat-tailed Network of 100 Nodes")
plot(1:100,dev,xlab="Number of Steps",ylab="Standard Deviation of the Distance",main="Fat-tailed Network of 100 Nodes")

# fat-tailed network of 10000nodes
g2_d2 <- barabasi.game(10000,directed=FALSE)#10000 nodes fat-tailed
st<-rep(NA,10000)#average
dev<-rep(NA,10000)#standard deviation
for(t in (1:10000)){#step
  net<-netrw(g2_d2, walker.num=100,start.node=1:100, T=t, damping=1, output.walk.path=TRUE)
  d<-rep(NA,100)#distance
  for(w in (1:100)){#walker
    from_node<-net$walk.path[1,w]
    to_node<-net$walk.path[t,w]
    short_d<-get.shortest.paths(g2_d2,from=from_node,to=to_node)
    d[w]<-length(short_d$vpath[[1]])-1
  }
  st[t] = mean(d)
  dev[t] = sd(d)
}
plot(1:10000,st,xlab="Number of Steps",ylab="Average Distance",main="Fat-tailed Network of 10000 Nodes")
plot(1:10000,dev,xlab="Number of Steps",ylab="Standard Deviation of the Distance",main="Fat-tailed Network of 10000 Nodes")
#print Diameters for q2
diameter(g2_d1)
diameter(g2_d2)

#2.e) 
#degree distribution of graph

dd<-rep(0,200*1000)
for(i in 1:200){#200 samples
  g2_e1 <- barabasi.game(1000,directed=FALSE)#1000 nodes fat-tailed  
  for(w in 1:1000)
    dd[1000*(i-1)+w]<-degree(g2_e1,w)
}
h<-hist(dd,breaks=seq(-0.5, by=1 , length.out=max(dd)+2))
pl <- data.frame(x=h$mids, y=h$density)
plot(pl,log="xy",xlab="Degree",ylab="Density",main="Degree Distribution of Graph of 1000 Nodes Network")


x<-seq(along=dd)-1
y<-3*x^(-3)
lines(x,y,col='red')

#degree distribution of random walk
ddrw<-rep(NA,200*1000)
for(i in 1:200){
g2_e1 <- barabasi.game(1000,directed=FALSE)#1000 nodes fat-tailed  
net<-netrw(g2_e1, walker.num=1000,start.node=1:vcount(g2_e1), T=1000, damping=1, output.walk.path=TRUE)
  for(w in 1:1000)
    ddrw[1000*(i-1)+w]<-degree(g2_e1,net$walk.path[1000,w])
}
h<-hist(ddrw,breaks=seq(-0.5, by=1 , length.out=max(ddrw)+2))
pl <- data.frame(x=h$mids, y=h$density)
plot(pl,log="xy",type="p",xlab="Degree",ylab="Density",main="Degree Distribution of the Nodes Reached at the End of the Random Walk")
x<-seq(along=dd)-1
y<-1.5*x^(-2)
lines(x,y,col='red')
