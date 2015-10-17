library(igraph)
degree1<- rep(0,35)
for(i in 1:100){
g1<- aging.prefatt.game(1000,pa.exp=1, aging.exp=-1,directed=FALSE)
temp<- degree.distribution(g1)
degree1<-degree1+c(temp,rep(0,35-length(temp)))}
plot(seq(along=degree1)-1,degree1/100,xlab="degree",ylab="density",log="xy")
fit1 <- power.law.fit(degree1/100+1, implementation= "R.mle")
coef(fit1)
