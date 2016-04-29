################################################################################
## Code from Kalman Filter exercise

KalmanFilter <- function(M,mu0,P0,Q,R,Y){
  
  ## storage
  nrow(Y) = 36  
  nt = ncol(Y)
  mu.f  = matrix(NA,36,nt+1)  ## forecast mean for time t
  mu.a  = matrix(NA,36,nt)  ## analysis mean for time t
  P.f  = array(NA,c(36,36,nt+1))  ## forecast variance for time t
  P.a  = array(NA,c(36,36,nt))  ## analysis variance for time t
  
  ## initialization
  mu.f[,1] = mu0
  P.f[,,1] = P0
  I = diag(1,36)
  
  ## run updates sequentially for each observation.
  for(t in 1:nt){
    
    ## Analysis step: combine previous forecast with observed data
    obs = !is.na(Y[,t]) ## which Y's were observed?
    if(any(obs)){
      H <- I[obs,]                                                        ## observation matrix
      K <- P.f[,,t] %*% t(H) %*% solve(H%*%P.f[,,t]%*%t(H) + R[obs,obs])  ## Kalman gain
      mu.a[,t] <- mu.f[,t] + K%*%(Y[obs,t] - H %*% mu.f[,t])              ## update mean
      P.a[,,t] <- (1-K %*% H)*P.f[,,t]                                    ## update covariance
    } else {
      ##if there's no data, the posterior is the prior
      mu.a[,t] = mu.f[,t]
      P.a[,,t] = P.f[,,t]
    }
    
    ## Forecast step: predict to next step from current
    mu.f[,t+1] = M%*%mu.a[,t]
    P.f[,,t+1] = Q + M*P.a[,,t]*t(M)
    
  }
  
  return(list(mu.f=mu.f,mu.a=mu.a,P.f=P.f,P.a=P.a))
}

ciEnvelope <- function(x,ylo,yhi,...){
  polygon(cbind(c(x, rev(x), x[1]), c(ylo, rev(yhi),
                                      ylo[1])), border = NA,...) 
}

## log transform data
Y   = log10(xf)

## load parameters (assume known)
#load("data/KFalpha.params.Rdata")

## options for process model 
M = x[t-1,i] + r + dept[i]

## options for process error covariance
Q = tau_add           ## full covariance matrix
#Q = diag(diag(Q))       ## diagonal covariance matrix

## observation error covariance (assumed independent)  
R = diag(tau_obs,36) 

## prior on first step, initialize with long-term mean and covariance
mu0 = apply(Y,1,mean,na.rm=TRUE)
P0 = cov(t(Y),use="pairwise.complete.obs")

## Run Kalman Filter
KF00 = KalmanFilter(M,mu0,P0,Q,R,Y)