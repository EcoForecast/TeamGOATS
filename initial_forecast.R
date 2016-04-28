#i=1 #department (choose whichever has most/best data)

nmc = 5000 # 1000 to 5000
nmcmc = nrow(out) # = rows in out
rand=sample.int(nmcmc,nmc)
start = 8
end=10

xf = array(NA,dim = c(end,36,nmc))

for(i in 1:36){  
x = out[,grep("x[7,1]",colnames(out),fixed=TRUE)] #fix so this "x[7,1]" is not hard coded
r = out[,grep("r",colnames(out),fixed=TRUE)]
dept = out[,grep("dept[1]",colnames(out),fixed=TRUE)]
tau_add = out[,grep("tau_add",colnames(out),fixed=TRUE)]
  

   for (k in 1:nmc){
      m=rand[k]
      xf[7,i,k] = x[m] #setting initial conditions --> first time from MCMC, later from analysis
      for(t in start:end){
        z = xf[t-1,i,k]+ r[m] + dept[m]
        xf[t,i,k] = rnorm(1,z,tau_add[m])
        }
   }
}

x=seq(1,end,1) # Time vector 
ci=array(NA,dim=c(3,end,36))
for(i in 1:36){
ci[,,i] <- apply(exp(xf[,i,]),1,quantile,c(0.025,0.5,0.975),na.rm=TRUE)
plot(ci[2,,i],ylim=range(ci[,,i],na.rm=TRUE),xlab="Day",ylab="Total Cases",main=colnames(dept.total[i]))
ciEnvelope(x,ci[1,,i],ci[3,,i],col="lightBlue")
points(ci[2,,i])
}

#sensitivity and uncertainty 

## do analysis
muf = mean()
Pf = var()
KF Math
x = sample from rnorm(ne,mua,pa)

#note: modeling x on a log scale

#iterative forecast will be basically this same code, just different start point that has different posterior (from analysis)

#in anaysis: choice btw PF and EnKF
  #PF - likelihood to calculate weights, resample using weights
  #EnKF- calculate forecast mean and forecast covariance, apply math from KF analysis, sample from that 