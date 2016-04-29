library(rjags)

load("zika.RData")

time = update
y = as.integer(total)
plot(time,y,type='l',ylab="Zika Index",lwd=2,log='y')

RandomWalk = "
model{

#### Data Model
for(i in 1:n){
#y[i] ~ dnorm(x[i],tau_obs)
mu[i] <- exp(x[i])  #back on linear scale
y[i]~dpois(mu[i])
ypred[i]~dpois(mu[i])
}

# if dividing data by department (counts), use poisson (parameter is mean background number; need to unlog x; no tau_obs) for data model.  (Could also use negative binomial)

#### Process Model
for(i in 2:n){
z[i] = x[i-1] + r
x[i]~dnorm(z[i],tau_add)
}

#### Priors
x[1] ~ dnorm(x_ic,tau_ic)
#tau_obs ~ dgamma(a_obs,r_obs)
tau_add ~ dgamma(a_add,r_add)
r ~ dnorm(0,0.02)
}
"

data <- list(y=y,n=length(y),x_ic=log(10000),tau_ic=1,a_add=1,r_add=1)#a_obs=1,r_obs=1

nchain = 3
init <- list()
for(i in 1:nchain){
  y.samp = sample(y,length(y),replace=TRUE)
  init[[i]] <- list(tau_add=1/var(diff(log(y.samp))))#,tau_obs=5/var(log(y.samp)))
}

j.model   <- jags.model (file = textConnection(RandomWalk),
                         data = data,
                         inits = init,
                         n.chains = 3)

## burn-in
jags.out   <- coda.samples (model = j.model,
                            variable.names = c("tau_add","r"),
                            n.iter = 1000)
plot(jags.out)

# Now that the model has converged we'll want to take a much larger sample from the MCMC and include the full vector of X's in the output
jags.out   <- coda.samples (model = j.model,
                            variable.names = c("x","ypred","tau_add"),#,"tau_obs"), # No tau_obs if using dpois for Data Model
                            n.iter = 10000)

ciEnvelope <- function(x,ylo,yhi,...){
  polygon(cbind(c(x, rev(x), x[1]), c(ylo, rev(yhi),
                                      ylo[1])), border = NA,...) 
}
out <- as.matrix(jags.out)
ci <- apply(exp(out[,grep("x",colnames(out))]),2,quantile,c(0.025,0.5,0.975))
pi <- apply(out[,grep("ypred",colnames(out))],2,quantile,c(0.025,0.5,0.975))

plot(time,ci[2,],type='n',ylim=range(pi,na.rm=TRUE),ylab="Zika Index",log='y')
ciEnvelope(time,pi[1,],pi[3,],col="lightBlue")
ciEnvelope(time,ci[1,],ci[3,],col="Blue")
points(time,y,pch="+",cex=0.5)

plot(time,ci[2,],type='n',ylim=range(ci,na.rm=TRUE),ylab="Zika Index")
ciEnvelope(time,ci[1,],ci[3,],col="lightBlue")
points(time,y,pch="+",cex=0.5)

#https://github.com/BuzzFeedNews/zika-data/tree/master/data/parsed/colombia



