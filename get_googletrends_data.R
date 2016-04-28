#!/usr/bin/env Rscript
.libPaths(c("/home/carya/R/library",.libPaths()))
.libPaths()
setwd("/home/carya/TeamGOATS")

#install gtrendsR package that pulls Google trend data
install.packages("gtrendsR")
library(gtrendsR)

#Data Source: Google Zika Trends (https://www.google.com/trends/explore#q=zika&geo=CO&date=9%2F2015%207m&cmpt=q&tz=Etc%2FGMT%2B5)

#group email set up to download Google Trend data
gconnect("zikaforecast@gmail.com","ge585zika")

<<<<<<< HEAD
#Pulling Google trend data for Colombia from September 2015 to present
## Change start date to within the last 3 months to get daily updates (using February 1st, 2016 below)
zika_trend.old=gtrends("zika",geo=c("CO"), start_date="2015-11-01",end_date= "2016-01-31")
=======
## Using trend data from from February 1, 2016 to get daily updates on Colombia 
>>>>>>> 6815c3ad57c0853d5066cd068da66c4f3d18227d
zika_trend=gtrends("zika",geo=c("CO"), start_date= "2016-02-01")

zika = rbind(zika_trend.old$trend,zika_trend$trend)
plot(zika)

## Creating matrix that stores daily department trend data. Departments with not enough search volume appear as NA 

subcode = countries[countries$code=="CO",]$subcode
zika_trend = matrix(NA,nrow = length(subcode),ncol=nrow(zika_trend$trend))

for(j in seq_along(subcode)){
  z=try(gtrends("zika",geo=c(subcode[j]), start_date= "2016-02-01"))
  if(class(z) != "try-error"){
    zika_trend[j,] = z$trend[,2]
  }
}

# Actual search numbers per day stored in zika_trend$trend

#make script executable using chmod
# cron job table
# MAILTO=zikaforecast@gmail.com
# * * 7 * */home/carya/TeamGOATS/get_googletrends_data.R

#check if the cron job is running
file_before= file("GoogleTrendsCronLastUpdate")
cat("JAG IS UP AND RUNNING",date(),file= file_before, append=TRUE)
close(file_before)

save.image("googleZika.RData")
#save

