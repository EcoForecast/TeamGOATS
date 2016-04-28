i=1 #department (choose whichever has most/best data)

nmc = 10 # 1000 to 5000
nmcmc = nrow(out) # = rows in out
rand=sample.int(nmcmc,nmc)
start = 8
end=10
xf = array(NA,dim = c(end,1,nmc))
x = out[,grep("x[7,1]",colnames(out),fixed=TRUE)] # use paste to not hardcode
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

#note: modeling x on a log scale

#iterative forecast will be basically this same code, just different start point that has different posterior (from analysis)

#in anaysis: choice btw PF and EnKF
  #PF - likelihood to calculate weights, resample using weights
  #EnKF- calculate forecast mean and forecast covariance, apply math from KF analysis, sample from that 