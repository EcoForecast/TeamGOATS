#i=1 #department (choose whichever has most/best data)

nmc = 5000 # 1000 to 5000
nmcmc = nrow(out) # = rows in out
rand=sample.int(nmcmc,nmc)
start = 8
end=10

for(i in 1:36){  
xf = array(NA,dim = c(end,i,nmc))

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

ci = apply(xf[,i,],2,quantile,c(0.025,0.5,0.975),na.rm=TRUE)
plot(time,ci[2,(start:end)+(i-1)*7],xlab="Time",ylab="Estimated Cases",
     main=colnames(dept.total[i]),ylim=range(pi[,(start:end)+(i-1)*7]))
ciEnvelope(time,ci[1,(start:end)+(i-1)*7],ci[3,(start:end)+(i-1)*7],col="Blue")
points(time,ci[2,(start:end)+(i-1)*7],ylab="Estimated Cases")
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