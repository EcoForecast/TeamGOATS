##sensitivity analysis using MC (Monte Carlo) approach (for estimates of buzzfeed
#data and actual values of google trends data)
#sample from posterior distribution of google "hits" of zika virus 

#load jags library 
library(rjags)
load("googleZika.RData")

#define model parameters used to run sensitivity analysis 
## y= hits by department of colombia
## x= time over which data spans (in this case we are picking an arbitrary 
#subregion for the length of time component)
y= dept.total
x=length(dept.total$AMAZONAS)

##create list of parameters used in analysis
data <- list(y=log(y),n=length(y),x_ic=log(1000),tau_ic=100,a_obs=1,r_obs=1,a_add=1,r_add=1)

##using a 'for-loop' loop over all individual departments

for (i in 1:length(dept.total)){

time.rng = c(1,length(time)) ## adjust to zoom in and out
ciEnvelope <- function(x,ylo,yhi,...){
  polygon(cbind(c(x, rev(x), x[1]), c(ylo, rev(yhi),
                                      ylo[1])), border = NA,...) 
}
out <- as.matrix(jags.out)
ci <- apply(exp(out[,3:ncol(out)]),2,quantile,c(0.025,0.5,0.975))

plot(time,ci[2,],type='n',ylim=range(y,na.rm=TRUE),ylab="Flu Index",log='y',xlim=time[time.rng])
## adjust x-axis label to be monthly if zoomed
if(diff(time.rng) < 100){ 
  axis.Date(1, at=seq(time[time.rng[1]],time[time.rng[2]],by='month'), format = "%Y-%m")
}
ciEnvelope(time,ci[1,],ci[3,],col="lightBlue")
points(time,y,pch="+",cex=0.5)}