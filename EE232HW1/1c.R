library(igraph)
h<-rep(0,11)
p<-seq(0.0072,0.0073,0.00001)
for(i in 1:length(p)){
h[i]<-0
for(j in 1:500){
g<- erdos.renyi.game(1000,p[i])
if(is.connected(g)) h[i]<-h[i]+1}
h[i]<-h[i]/500}
h
