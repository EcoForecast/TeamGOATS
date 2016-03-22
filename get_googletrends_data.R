#!/usr/bin/env Rscript
.libPaths(c("/home/carya/R/library",.libPaths()))
.libPaths()
setwd("/home/carya/TeamGOATS")

#install gtrendsR package that pulls Google trend data
install.packages("gtrendsR")
library(gtrendsR)

#Data Source: Google Zika Trends (https://www.google.com/trends/explore#q=zika&geo=CO&date=9%2F2015%207m&cmpt=q&tz=Etc%2FGMT%2B5)

gconnect("zikaforecast@gmail.com","ge585zika")

#Pulling Google trend data for Colombia from September 2015 to present
## Change start date to within the last 3 months to get daily updates (using February 1st, 2016 below)
zika_trend=gtrends("zika",geo=c("CO"), start_date= "2016-02-01")

plot(zika_trend)

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
