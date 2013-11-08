install.packages("spatstat")
library(spatstat)
install.packages("SAPP")
library(sapp)

# Examples
data(main2003JUL26)
head(main2003JUL26)

### GOALS: Generate a dataframe for the SAPP Package 

### DATAFRAME FOR SAPP ==========================================================================

cleandata <-read.csv("./data-curators/CleanData1938-2013.csv")

### Notice cleandata["HH.mm.SS.ss"] does not contain real numbers,  by looking at jap.quakes,  we need to create a time variable
numbers <- c(1:nrow(cleandata))
long <-cleandata[["LON"]]
lat <-cleandata[["LAT"]]
magnitude <-cleandata[["MAG"]]

times <-cleandata[["HH.mm.SS.ss"]]
dates <-cleandata[["YYYY.MM.DD"]]
datatime <-as.POSIXct(strptime(paste(dates, times), "%Y/%m/%d %H:%M:%OS"))
newtime <-as.numeric(difftime(datatime,datatime[1],units="days"))

depth <- cleandata[["DEPTH"]]
year <- as.numeric(strftime(datatime, format="%Y"))
month <- as.numeric(strftime(datatime, format="%m"))
day <- as.numeric(strftime(datatime, format="%d"))

sappdf = data.frame(no.= numbers,longitude=long,latitude=lat,magnitude=magnitude,
           time=newtime,depth=depth,year=year,month=month,day=day)

head(sappdf)