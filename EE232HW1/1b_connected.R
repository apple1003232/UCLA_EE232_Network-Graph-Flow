library(igraph)
h<-0
for(i in 1:500){
g1<-erdos.renyi.game(1000,0.01)
if(is.connected(g1)) h<-h+1}
h/500
h<-0
for(i in 1:500){
g1<-erdos.renyi.game(1000,0.05)
if(is.connected(g1)) h<-h+1}
h/500
h<-0
for(i in 1:500){
g1<-erdos.renyi.game(1000,0.1)
if(is.connected(g1)) h<-h+1}
h/500
