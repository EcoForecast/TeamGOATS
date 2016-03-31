#!/usr/bin/env Rscript
.libPaths(c("/home/carya/R/library",.libPaths()))
.libPaths()
setwd("/home/carya/TeamGOATS")

## since libraries will be pulled, make sure repository is set
repos = "http://cran.us.r-project.org"
get.pkg <- function(pkg){
  loaded <- do.call("require",list(package=pkg))
  if(!loaded){
    print(paste("trying to install",pkg))
    install.packages(pkg,dependencies=TRUE,repos=repos)
    loaded <- do.call("require",list(package=pkg))
    if(loaded){
      print(paste(pkg,"installed and loaded"))
    } 
    else {
      stop(paste("could not install",pkg))
    }    
  }
}
get.pkg("RCurl")
print(require("XML"))
get.pkg("ncdf4")
get.pkg("devtools")
get.pkg("MODISTools")

print("loaded packages")

load("zika.RData")
update.old = update

data.repo = "https://github.com/BuzzFeedNews/zika-data/tree/master/data/parsed/colombia"

# Scrape Github for new data
## Grab raw html
zika_URL <- getURL(data.repo)

## Read the Github reference table data into R
zika_table = readHTMLTable(zika_URL)[[1]]
muni_data = as.matrix(zika_table[3:nrow(zika_table),]) # Extract the municipal data

## Store the dates of when each file was updated in the object "update"
update = as.Date(substr(muni_data[,2],20,29)) # Extract dates from .csv file names

## Plot histogram of when new files were uploaded
#hist(update,"days",col="grey")

raw.path = "https://raw.githubusercontent.com/BuzzFeedNews/zika-data/master/data/parsed/colombia"
data = list()
total = matrix(data=NA,nrow=length(update))
for(i in 1:length(update)){
  data[[i]] = read.csv(paste0(raw.path,"/",muni_data[i,2]))
  total[i] = sum(data[[i]][,"zika_total"])
  #myfile = file.path("C:/Users/Emily/Documents/TeamGOATS/",paste0("file",i,".csv"))
  #datafile = read.csv(paste0(raw.path,"/",muni_data[i,2]))
  #write.csv(datafile,file=myfile)
}

# Divide up totals by department
num.depts = length(levels(data[[1]][,1]))
dept.names = levels(data[[1]][,1])
dept.total = data.frame(matrix(data=NA,nrow=length(update),ncol=num.depts))
rownames(dept.total) = update
colnames(dept.total) = dept.names
for(i in 1:length(update)){
  dept.total[i,] = tapply(data[[i]]$zika_total,data[[i]]$department,FUN=sum) 
}    
dept.total
for(i in 1:num.depts){
  plot(as.factor(update),dept.total[,i],main=colnames(dept.total)[i],las=1,xlab="Time",ylab="Total confirmed and suspected cases")
}

jpeg("web/Cases.jpg")
plot(update,total,xlab="Time",ylab="Total confirmed and suspected")
dev.off()
#barplot(as.vector(total),names.arg=update,xlab="Time",ylab="Total confirmed and suspected cases")

#############################################################################################
# TRY LATER: Only downloading new data
# If a new data file has been added, download it
#if(length(update) > length(update.old)) {
  ## Create a subset of the FIA reference table which includes only the files that were updated more recently than our specified download date
  #new_data = muni_data[which(update > update.old),] # Only include files updated more recently than our last download date
  # Pull the data off the web
  ## Loop over the files in our subsetted reference table and grab these files off the website 
  #raw.data = "https://raw.githubusercontent.com/BuzzFeedNews/zika-data/master/data/parsed/colombia"
  #total <- matrix(data=NA,nrow=nrow(new_data))
  #for(i in 1:nrow(new_data)){
    #data = read.csv(paste0(raw.data,"/",new_data[i,2]))
    #total[i] = sum(data[,"zika_total"])
  #}
#}
#############################################################################################
#check if the cron job is running
file_before= file("buzzfeedCronLastUpdate")
cat("JAG IS UP AND RUNNING",date(),file= file_before, append=TRUE)
close(file_before)


save.image("zika.RData")
#save

### Later, once server is working, need to make this script executable by using chmod
# Cron job directory: /home/carya/TeamGOATS/get_data.R
