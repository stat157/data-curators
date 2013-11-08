rm(list = ls(all = TRUE))
install.packages("spatstat")
library(spatstat)
install.packages("SAPP")
library(SAPP)
install.packages("ETAS")
library(ETAS)


###  CONVERTING CLEAN DATA INTO PPX ====================================================

### GOALS: We will try to convert the clear data into a "ppx".
### "ppx": A dataframe with spatio-temporal observations 
### In this case time,  long,  lat,  mag,  mag.type,  depth,  ref,  date
### as well as setting a specified domain of data

# Examples
jap.quakes
### Multidimensional point pattern
### 13724 points 
### 2-dimensional space coordinates (long,lat)
### 1-dimensional time coordinates (time)
### 3 columns of marks: ‘mag’, ‘depth’ and ‘date’ 
### Domain:
###  Box: [0, 29943] x [128, 145] x [27, 45] units  
iran.quakes
### Multidimensional point pattern
### 3775 points 
### 2-dimensional space coordinates (long,lat)
### 1-dimensional time coordinates (time)
### 5 columns of marks: ‘mag’, ‘mag.type’, ‘depth’, ‘ref’ and ‘date’ 
### Domain:
###  Box: [0, 40329] x [41, 69] x [20.5, 44.5] units  

cleandata <-read.csv("/Users/runliang/Desktop/CleanData1938-2013.csv")
cleandata=cleandata[cleandata["MAG"]>4.5,]
write.csv(cleandata,file="DataFrameWithMag4_5.csv")


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
### Multidimensional point pattern
### 640 points 
### 2-dimensional space coordinates (long,lat)
### 1-dimensional time coordinates (time)
### 5 columns of marks: ‘mag’, ‘mag.type’, ‘depth’, ‘ref’ and ‘date’ 
### Domain:
###  3-dimensional box:
###  [0, 27441] x [-122, -114] x [32, 37] units  

### DATAFRAME FOR SAPP ==============================================================

### GOALS: Generate a dataframe for the SAPP Package 

# Examples
data(main2003JUL26)
head(main2003JUL26)

cleandata <-read.csv("/Users/runliang/Desktop/CleanData1938-2013.csv")
cleandata=cleandata[cleandata["MAG"]>4.5,]
write.csv(cleandata,file="DataFrameWithMag>4.csv")

### Notice cleandata["HH.mm.SS.ss"] does not contain real numbers,  by looking at jap.quakes,  we need to create a time variable
numbers <- c(1:nrow(cleandata))
long <-cleandata[["LON"]]
lat <-cleandata[["LAT"]]
magnitude <-cleandata[["MAG"]]
dates <-cleandata[["YYYY.MM.DD"]]
times <-cleandata[["HH.mm.SS.ss"]]
datatime <-as.POSIXct(strptime(paste(dates, times), "%Y/%m/%d %H:%M:%OS"))
newtime <-as.numeric(difftime(datatime,datatime[1],units="days"))

depth <- cleandata[["DEPTH"]]
year <- as.numeric(strftime(datatime, format="%Y"))
month <- as.numeric(strftime(datatime, format="%m"))
day <- as.numeric(strftime(datatime, format="%d"))

sappdf = data.frame(no.= numbers,longitude=long,latitude=lat,magnitude=magnitude,
           time=newtime,depth=depth,year=year,month=month,day=day)

head(sappdf)
###     no. longitude latitude magnitude       time depth year month day
### 1   1  -115.047   32.560      4.81   0.000000   6.0 1938     4  12
### 2   2  -115.272   32.480      4.84   1.128604   6.0 1938     4  13
### 3   3  -118.200   32.600      4.68  15.571450   6.0 1938     4  28
### 4   4  -117.511   33.699      5.23  48.673868  10.2 1938     5  31
### 5   5  -115.191   32.273      4.92  54.429268   6.0 1938     6   6
### 6   6  -116.047   34.818      4.54 127.635547   6.0 1938     8  18

tail(sappdf)
###     no. longitude latitude magnitude     time depth year month day
### 635 635  -115.540   33.019      5.44 27165.15   8.2 2012     8  26
### 636 636  -115.531   33.028      4.61 27165.26   7.4 2012     8  26
### 637 637  -115.519   33.021      4.90 27165.47   4.1 2012     8  27
### 638 638  -120.847   36.324      5.30 27220.56  15.8 2012    10  21
### 639 639  -116.457   33.502      4.70 27361.98  13.1 2013     3  11
### 640 640  -119.926   34.413      4.80 27440.88   8.0 2013     5  29