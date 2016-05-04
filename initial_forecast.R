library(mvtnorm)
nmc = 500 # 1000 to 5000
nmcmc = nrow(out) # = rows in out
rand=sample.int(nmcmc,nmc)
start = 8
end=16

xf = array(NA,dim = c(end,36,nmc))

for(i in 1:36){  
  x = out[,grep(paste0("x[7,",i,"]"),colnames(out),fixed=TRUE)] #fix so this "x[7,1]" is not hard coded
  r = out[,grep("r",colnames(out),fixed=TRUE)]
  dept = out[,grep(paste0("dept[",i,"]"),colnames(out),fixed=TRUE)]
  tau_add = 1/sqrt(out[,grep("tau_add",colnames(out),fixed=TRUE)])
  tau_obs = 1/sqrt(out[,grep("tau_obs",colnames(out),fixed=TRUE)])  
  
  for (k in 1:nmc){
    m=rand[k]
    xf[7,i,k] = x[m] #setting initial conditions --> first time from MCMC, later from analysis
    for(t in start:end){
      z = xf[t-1,i,k]+ r[m] + dept[m]
      xf[t,i,k] = rnorm(1,z,tau_add[m])
    }
  }
}

data=apply(exp(out[,grep("x",colnames(out))]),2,quantile,c(0.025,0.5,0.975))
x=seq(1,end,1) # Time vector 
ci.f=array(NA,dim=c(3,end,36))
for(i in 1:36){
  ci.f[,,i] <- apply(exp(xf[,i,]),1,quantile,c(0.025,0.5,0.975),na.rm=TRUE)
  #plot(ci.f[2,,i],ylim=range(ci.f[,,i],na.rm=TRUE),xlab="Week",ylab="Total Zika Cases",main=colnames(dept.total[i]))
  #ciEnvelope(x,ci.f[1,,i],ci.f[3,,i],col="lightBlue")
  #points(ci.f[2,,i])
}

start=8
time.f=seq(1,end,1)
for(i in 1:36){
  ylim=range(cbind(ci[,(1:7)+(i-1)*7],ci.f[,,i]),na.rm=TRUE)
  plot(time.f,c(ci[2,(1:7)+(i-1)*7],ci.f[2,start:end,i]),xlab="Week",ylab="Total Zika Cases",main=colnames(dept.total[i]),log="y",ylim=ylim,na.rm=TRUE)
  ciEnvelope(time.f[1:(start-1)],pi[1,(1:7)+(i-1)*7],pi[3,(1:7)+(i-1)*7],col="lightBlue")
  ciEnvelope(time.f,ci.f[1,,i],ci.f[3,,i],col="lightGrey")
  points(time.f,c(ci[2,(1:7)+(i-1)*7],ci.f[2,start:end,i]))
  points(ci.f[2,,i],pch="+",col="darkGreen")
}

#sensitivity and uncertainty 

#pseudodata
Y = matrix(NA,36,end)
for(i in 1:36){
  Y[i,] = xf[,i,sample.int(nmc,1)]
}

### STOP HERE, GO TO ENKF.R ####

