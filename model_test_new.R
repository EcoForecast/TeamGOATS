library(rjags)

load("zika.RData")

time = update
y = as.integer(total)
plot(time,y,type='l',ylab="Zika Index",lwd=2,log='y')

RandomWalk = "
model{

#### Data Model
for(i in 1:nd){
for(t in 1:nt){
mu[t,i] <- exp(x[t,i])  #back on linear scale
dept.total[t,i]~dpois(mu[t,i])
ypred[t,i]~dpois(mu[t,i])
}
}

# if dividing data by department (counts), use poisson (parameter is mean background number; need to unlog x; no tau_obs) for data model.  (Could also use negative binomial)

#### Process Model
for(i in 1:nd){
for(t in 2:nt){
z[t,i] = x[t-1,i] + r + dept[i]
x[t,i]~dnorm(z[t,i],tau_add)
}
#### Departmental effect
dept[i] ~ dnorm(0,tau_dept)
}


#### Priors
for(i in 1:nd){
x[1,i] ~ dnorm(x_ic,tau_ic)
}
tau_obs ~ dgamma(a_obs,r_obs)
tau_add ~ dgamma(a_add,r_add)
tau_dept ~ dgamma(a_dept,r_dept)
r ~ dnorm(0,0.02)
}
"

data <- list(dept.total=dept.total,nd=ncol(dept.total),nt=nrow(dept.total),x_ic=log(10000),tau_ic=1,a_add=1,r_add=1,a_obs=1,r_obs=1,r_dept=1,a_dept=1)

nchain = 3
init <- list()
for(i in 1:nchain){
  y.samp = sample(dept.total,length(dept.total),replace=TRUE)
  init[[i]] <- list(tau_add=1/var(as.vector(apply(y.samp,2,diff))))#,tau_obs=5/var(log(y.samp)))
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
                            variable.names = c("x","ypred","tau_add","tau_obs","r","dept"),
                            n.iter = 10000)

#jags.out   <- coda.samples (model = j.model,
#variable.names = c("x","tau_obs","tau_add","tau_dept","r"),
#n.iter = 10000)

ciEnvelope <- function(x,ylo,yhi,...){
  polygon(cbind(c(x, rev(x), x[1]), c(ylo, rev(yhi),
                                      ylo[1])), border = NA,...) 
}
out <- as.matrix(jags.out)
ci <- apply(exp(out[,grep("x",colnames(out))]),2,quantile,c(0.025,0.5,0.975))
pi <- apply(out[,grep("ypred",colnames(out))],2,quantile,c(0.025,0.5,0.975))

for(i in 1:36){
  plot(time,ci[2,(1:7)+(i-1)*7],xlab="Time",ylab="Total Zika Cases",main=colnames(dept.total[i]),ylim=range(pi[,(1:7)+(i-1)*7]))
  ciEnvelope(time,pi[1,(1:7)+(i-1)*7],pi[3,(1:7)+(i-1)*7],col="lightBlue")
  #ciEnvelope(time,ci[1,(1:7)+(i-1)*7],ci[3,(1:7)+(i-1)*7],col="Blue")
  points(time,ci[2,(1:7)+(i-1)*7],ylab="Total Zika Cases")
}
