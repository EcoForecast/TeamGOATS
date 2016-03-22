library(rjags)

load("zika.RData")

time = update
y = as.integer(total)
plot(time,y,type='l',ylab="Zika Index",lwd=2,log='y')

RandomWalk = "
model{

#### Data Model
for(i in 1:n){
y[i] ~ dnorm(x[i],tau_obs)
}

#### Process Model
for(i in 2:n){
x[i]~dnorm(x[i-1],tau_add)
}

#### Priors
x[1] ~ dnorm(x_ic,tau_ic)
tau_obs ~ dgamma(a_obs,r_obs)
tau_add ~ dgamma(a_add,r_add)
}
"

data <- list(y=log(y),n=length(y),x_ic=log(1000),tau_ic=100,a_obs=1,r_obs=1,a_add=1,r_add=1)

nchain = 3
init <- list()
for(i in 1:nchain){
  y.samp = sample(y,length(y),replace=TRUE)
  init[[i]] <- list(tau_add=1/var(diff(log(y.samp))),tau_obs=5/var(log(y.samp)))
}

j.model   <- jags.model (file = textConnection(RandomWalk),
                         data = data,
                         inits = init,
                         n.chains = 3)

## burn-in
jags.out   <- coda.samples (model = j.model,
                            variable.names = c("tau_add","tau_obs"),
                            n.iter = 1000)
plot(jags.out)

# Now that the model has converged we'll want to take a much larger sample from the MCMC and include the full vector of X's in the output
jags.out   <- coda.samples (model = j.model,
                            variable.names = c("x","tau_add","tau_obs"),
                            n.iter = 10000)

ciEnvelope <- function(x,ylo,yhi,...){
  polygon(cbind(c(x, rev(x), x[1]), c(ylo, rev(yhi),
                                      ylo[1])), border = NA,...) 
}
out <- as.matrix(jags.out)
ci <- apply(exp(out[,3:ncol(out)]),2,quantile,c(0.025,0.5,0.975))

plot(time,ci[2,],type='n',ylim=range(y,na.rm=TRUE),ylab="Zika Index",log='y')
ciEnvelope(time,ci[1,],ci[3,],col="lightBlue")
points(time,y,pch="+",cex=0.5)

#https://github.com/BuzzFeedNews/zika-data/tree/master/data/parsed/colombia



