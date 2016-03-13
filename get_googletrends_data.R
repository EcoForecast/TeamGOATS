#install gtrendsR package that pulls Google trend data
install.packages("gtrendsR")
library(gtrendsR)

#Data Source: Google Zika Trends (https://www.google.com/trends/explore#q=zika&geo=CO&date=9%2F2015%207m&cmpt=q&tz=Etc%2FGMT%2B5)

gconnect("zikaforecast@gmail.com","ge585zika")

#Pulling Google trend data for Colombia from September 2015 to present
zika_trend=gtrends("zika",geo=c("CO"), start_date= "2015-09-01")

plot(zika_trend)


