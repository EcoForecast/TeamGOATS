i=5 #department (choose whichever has most/best data)
rand=sample.int(nmc,nmcmc)

for (k in 1:nmn){
  m=rand[k]
  xf[t,i,k] = x[time] #setting initial conditions --> first time from MCMC, later from analysis
  for(t in start:end){
    z[t,i,k] = xf[t,i,k]+ r[m] + dept[i,m]
    xf[t,i,k] = rnorm(z[t,i,k],tau_add[m])
  }
}

#note: modeling x on a log scale

#iterative forecast will be basically this same code, just different start point that has different posterior (from analysis)

#in anaysis: choice btw PF and EnKF
  #PF - likelihood to calculate weights, resample using weights
  #EnKF- calculate forecast mean and forecast covariance, apply math from KF analysis, sample from that 