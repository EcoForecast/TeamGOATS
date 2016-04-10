## Included get_data.R and get_googletrends_data.R to have everything in once place

## Google Trends Data (get_googletrends_data.R)

setwd("/home/carya/TeamGOATS")

#install gtrendsR package that pulls Google trend data
install.packages("gtrendsR")
library(gtrendsR)

#Data Source: Google Zika Trends (https://www.google.com/trends/explore#q=zika&geo=CO&date=9%2F2015%207m&cmpt=q&tz=Etc%2FGMT%2B5)

gconnect("zikaforecast@gmail.com","ge585zika")

#Pulling Google trend data for Colombia from September 2015 to present
## Change start date to within the last 3 months to get daily updates (using February 1st, 2016 below)
zika_trend.old=gtrends("zika",geo=c("CO"), start_date="2015-11-01",end_date= "2016-01-31")
zika_trend=gtrends("zika",geo=c("CO"), start_date= "2016-02-01")

zika = rbind(zika_trend.old$trend,zika_trend$trend)
plot(zika)

save.image("googleZika.RData")
#######################################################################################


## Buzzfeed Data (get_data.R)
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
jpeg("web/Cases.jpg")
plot(update,total,xlab="Time",ylab="Total confirmed and suspected")
dev.off()


save.image("zika.RData")
#save

time = update
y = as.integer(total)
#######################################################################################

## Combine Buzzfeed and Google Trends data 

# Create new column for buzzfeed data
x = NA
new.column = rep(x,times = 146)
# Create new matrix with both data sources
combined.data = cbind(zika,new.column)
colnames(combined.data) = c("Date","Searches","Cases")
google.time = as.Date(combined.data$Date)
combined.data[,1] = google.time
search.sum = cumsum(combined.data$Searches) # Make google data sum up to match format of buzzfeed data
combined.data[,2] = search.sum
# Add buzzfeed data to combined.data matrix
for(i in 1:146){
  for(j in 1:7){
    if(combined.data$Date[i] == time[j]) {
      combined.data$Cases[i] = total[j] # Add buzzfeed data in when dates match, the rest are NA
    } 
  }
}


