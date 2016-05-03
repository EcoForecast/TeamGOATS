#Sensitivity and Uncertainty Analysis of Initial Forecast

xf.new=xf[10,,]

#Department

dept.new=sample(dept,500)
dept_stats= matrix(nrow=36,ncol=2)
colnames(dept_stats)<-c("r squared","slope")
for(i in 1:36){
  plot(dept.new,xf.new[i,])
  fit.dept=lm(xf.new[i,]~dept.new)
  abline(fit.dept, col="red")
  summary(fit.dept)
  dept_stats[i,1]=summary(fit.dept)$r.squared
  dept_stats[i,2]=summary(fit.dept)$coefficients[[2]]
  
}

#r

r_values=r[,1]
r.new=sample(r_values,500)
r_stats=matrix(nrow=36,ncol=2)
colnames(r_stats)=c("r squared","slope")

for (i in 1:36){
  plot(r.new,xf.new[i,])
  fit.r=lm(xf.new[i,]~r.new)
  abline(fit.r, col="red")
  summary(fit.r)
  r_stats[i,1]=summary(fit.r)$r.squared
  r_stats[i,2]=summary(fit.r)$coefficients[[2]]
  
}




