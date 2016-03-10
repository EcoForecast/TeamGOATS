setwd("C:/Users/Emily/Documents/TeamGOATS")

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
get.pkg("XML")
get.pkg("ncdf4")
get.pkg("devtools")
get.pkg("MODISTools")

# Scrape Github for new data
## Grab raw html
zika_URL <- getURL("https://github.com/BuzzFeedNews/zika-data/tree/master/data/parsed/colombia")

## Read the Github reference table data into R
zika_table = readHTMLTable(zika_URL)[[1]]

## Store the dates of when each file was updated in the object "update"
update = as.Date(zika_table[,4],"%b%d,%Y")

## Plot histogram of when new files were uploaded
hist(update,"days",col="grey")

## Create a subset of the FIA reference table which includes only the files that were updated more recently than our specified download date
#zika_table[which(update > ),] # Only include files updated more recently than our last download date

# Pull the data off the web
## Loop over the files in our subsetted reference table and grab these files off the website using wget
wlef = read.csv("colombia-municipal-2016-01-09.csv")
total = sum(wlef[,"zika_total"])
total
