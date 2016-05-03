library(mvtnorm)

EnKF <- function(X.f,Y){
  
  ## do analysis
  mu.f = apply(X.f,1,mean)
  P.f = var(t(X.f))
  I = diag(1,36)
  R = diag(mean(tau_obs),36)
  #KF Math
  
  ## Analysis step: combine previous forecast with observed data
  obs = !is.na(Y) ## which Y's were observed?
  if(any(obs)){
    H <- I[obs,]                                                        ## observation matrix
    K <- P.f %*% t(H) %*% solve(H%*%P.f%*%t(H) + R[obs,obs])  ## Kalman gain
    mu.a <- mu.f + K%*%(Y[obs] - H %*% mu.f)              ## update mean
    P.a <- (1-K %*% H)*P.f                                  ## update covariance
  } else {
    ##if there's no data, the posterior is the prior
    mu.a = mu.f
    P.a = P.f
  }
  
  X.a = t(rmvnorm(nmc,mu.a,P.a))
  X.f.new = X.f*NA
  #note: modeling x on a log scale
  
  #iterative forecast will be basically this same code, just different start point that has different posterior (from analysis)
  for(i in 1:36){  
    r = out[,grep("r",colnames(out),fixed=TRUE)]
    dept = out[,grep(paste0("dept[",i,"]"),colnames(out),fixed=TRUE)]
    tau_add = 1/sqrt(out[,grep("tau_add",colnames(out),fixed=TRUE)])
    tau_obs = 1/sqrt(out[,grep("tau_obs",colnames(out),fixed=TRUE)])  
    
    for (k in 1:nmc){
      m=rand[k]
      for(t in start:end){
        z = X.a[i,k]+ r[m] + dept[m]
        X.f.new[i,k] = rnorm(1,z,tau_add[m])
      }
    }
  }
  
  #in anaysis: choice btw PF and EnKF
  #PF - likelihood to calculate weights, resample using weights
  #EnKF- calculate forecast mean and forecast covariance, apply math from KF analysis, sample from that 
  
  return(list(X.f = X.f.new,mu.a=mu.a,P.a=P.a))
}

fx = list()
for(start in 8:end){
  print(start)
  fx[[start]]<- EnKF(xf[start,,],Y[,start])
}

######## EMILY
end.forecast = 20

xf.new = array(NA,dim = c(end.forecast,36,nmc)) # Define a matrix to hold X.f values
for(i in 1:36){
  for(j in 8:end.forecast){
    xf.new[j,i,] = as.matrix(fx[[j]]$X.f[i,]) # Convert list to a matrix in order to plot X.f
  }
}

x.new=seq(1,end.forecast,1) # Time vector 
ci.f.new=array(NA,dim=c(3,end.forecast,36))
for(i in 1:36){
  ci.f.new[,,i] <- apply(exp(xf.new[,i,]),1,quantile,c(0.025,0.5,0.975),na.rm=TRUE)
  plot(ci.f.new[2,,i],ylim=range(ci.f.new[,,i],na.rm=TRUE),xlab="Week",ylab="Total Cases",main=colnames(dept.total[i]))
  ciEnvelope(x.new,ci.f.new[1,,i],ci.f.new[3,,i],col="lightBlue")
  points(ci.f.new[2,,i])
}
######## EMILY

time.f.new=seq(1,end.forecast,1)
for(i in 1:36){
  ylim=range(cbind(ci[,(1:20)+(i-1)*20],ci.f.new[,,i]),na.rm=TRUE)
  plot(time.f.new,c(ci[2,(1:20)+(i-1)*20],ci.f.new[2,start:end.forecast,i]),xlab="Time",ylab="Zika Index",main=colnames(dept.total[i]),log="y",ylim=ylim,na.rm=TRUE)
  #ciEnvelope(time,pi[1,(1:7)+(i-1)*7],pi[3,(1:7)+(i-1)*7],col="lightBlue")
  ciEnvelope(time.f.new[1:(start-1)],pi[1,(1:20)+(i-1)*20],pi[3,(1:20)+(i-1)*20],col="lightBlue")
  #ciEnvelope(time.f,c(ci[1,(1:7)+(i-1)*7],ci.f[1,,i]),c(ci[3,(1:7)+(i-1)*7],ci.f[3,,i]),col="Blue")
  ciEnvelope(time.f.new,ci.f.new[1,,i],ci.f.new[3,,i],col="lightGreen")
  points(time.f.ew,c(ci[2,(1:20)+(i-1)*20],ci.f[2,start:end.forecast,i]))
  points(ci.f.new[2,,i],pch="+",col="darkGreen")
}

time.f=seq(1,end,1)
for(i in 1:36){
  ylim=range(cbind(ci[,(1:7)+(i-1)*7],ci.f[,,i]),na.rm=TRUE)
  plot(time.f.new,c(ci[2,(1:7)+(i-1)*7],ci.f[2,start:end.forecast,i]),xlab="Time",ylab="Zika Index",main=colnames(dept.total[i]),log="y",ylim=ylim,na.rm=TRUE)
  #ciEnvelope(time,pi[1,(1:7)+(i-1)*7],pi[3,(1:7)+(i-1)*7],col="lightBlue")
  ciEnvelope(time.f[1:(start-1)],pi[1,(1:7)+(i-1)*7],pi[3,(1:7)+(i-1)*7],col="lightBlue")
  #ciEnvelope(time.f,c(ci[1,(1:7)+(i-1)*7],ci.f[1,,i]),c(ci[3,(1:7)+(i-1)*7],ci.f[3,,i]),col="Blue")
  ciEnvelope(time.f,ci.f[1,,i],ci.f[3,,i],col="lightGreen")
  points(time.f,c(ci[2,(1:7)+(i-1)*7],ci.f[2,start:end,i]))
  points(ci.f[2,,i],pch="+",col="darkGreen")
  ciEnvelope(time.f.new,ci.f.new[1,,i],ci.f[3,,i],col="lightGray")
  points(ci.f.new[2,,i],pch="+",col="darkGreen")
}
