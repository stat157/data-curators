install.packages("spatstat")
library(spatstat)
install.packages("ETAS")
library(ETAS)

# Examples
jap.quakes 
iran.quakes

### GOALS: We will try to convert the clear data into a "ppx".
### "ppx": A dataframe with spatio-temporal observations 
### In this case time,  long,  lat,  mag,  mag.type,  depth,  ref,  date
### as well as setting a specified domain of data

###  CONVERTING CLEAN DATA INTO PPX ====================================================

cleandata <-read.csv("./CleanData1938-2013.csv")

### Notice cleandata["HH.mm.SS.ss"] does not contain real numbers,  by looking at jap.quakes,  we need to create a time variable
dates <-cleandata[["YYYY.MM.DD"]]
times <-cleandata[["HH.mm.SS.ss"]]

datatime <-as.POSIXct(strptime(paste(dates, times), "%Y/%m/%d %H:%M:%OS"))

newtime <-as.numeric(difftime(datatime,datatime[1],units="days"))


Newcleandata <-data.frame(long=cleandata[["LON"]], lat=cleandata[["LAT"]], 
                          time=newtime, mag =cleandata[["MAG"]], 
                          mag.type=cleandata[["M"]], depth=cleandata[["DEPTH"]], 
                          ref=cleandata[["EVID"]], date=cleandata[["YYYY.MM.DD"]])

timedomain = c(floor(min(Newcleandata$time)),ceiling(max(Newcleandata$time)))
longdomain = c(floor(min(Newcleandata$long)),ceiling(max(Newcleandata$long)))
latdomain = c(floor(min(Newcleandata$lat)),ceiling(max(Newcleandata$lat)))
ppxdomain = boxx(t=timedomain,lon=longdomain,lat=latdomain)

CalPPX = ppx(data=Newcleandata,domain=ppxdomain,
             coord.type =c("s", "s", "t", "m", "m", "m", "m", "m"))

CalPPX

### ROADBLOCKS ==========================================================================
