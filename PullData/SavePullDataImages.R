plothist = hist(update,"days",col="grey")
plotplot = plot(update,total,xlab="Time",ylab="Total confirmed and suspected")
plotbar = barplot(as.vector(total),names.arg=update,xlab="Time",ylab="Total confirmed and suspected cases")

jpeg(filename="../web/plothist.jpg")
hist(update,"days",col="grey")
dev.off()

jpeg(filename="../web/plotplot.jpg")
plot(update,total,xlab="Time",ylab="Total confirmed and suspected")
dev.off()

jpeg(filename="../web/barplot.jpg")
barplot(as.vector(total),names.arg=update,xlab="Time",ylab="Total confirmed and suspected cases")
dev.off()