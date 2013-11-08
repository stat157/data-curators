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
cleandata=cleandata[cleandata["MAG"]>4,]


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
### 1528 points 
### 2-dimensional space coordinates (long,lat)
### 1-dimensional time coordinates (time)
### 5 columns of marks: ‘mag’, ‘mag.type’, ‘depth’, ‘ref’ and ‘date’ 
### Domain:
###  3-dimensional box:
###  [0, 21754] x [-122, -114] x [32, 37] units  

### DATAFRAME FOR SAPP ==============================================================

### GOALS: Generate a dataframe for the SAPP Package 

# Examples
data(main2003JUL26)
head(main2003JUL26)

cleandata <-read.csv("/Users/runliang/Desktop/CleanData1938-2013.csv")
cleandata=cleandata[cleandata["MAG"]>4,]
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
write.csv(cleandata,file="DataFrameWithMag>4.csv")

head(sappdf)
### no. longitude latitude magnitude     time depth year month day
### 1   1  -116.382   33.383      4.41  0.00000     6 1938     1   4
### 2   2  -116.114   34.160      4.05 35.29864     6 1938     2   8
### 3   3  -116.165   34.216      4.27 42.30296     6 1938     2  15
### 4   4  -116.194   34.638      4.07 86.69050     6 1938     3  31
### 5   5  -115.047   32.560      4.81 98.66332     6 1938     4  12
### 6   6  -115.272   32.480      4.84 99.79192     6 1938     4  13

tail(sappdf)

### no. longitude latitude magnitude     time depth year month day
### 1523 1523  -118.109   32.681      4.76 21717.13   6.0 1997     6  20
### 1524 1524  -118.137   32.685      4.18 21717.17   6.0 1997     6  20
### 1525 1525  -118.151   32.626      4.53 21717.27   6.0 1997     6  20
### 1526 1526  -117.336   34.168      4.18 21725.84  10.0 1997     6  28
### 1527 1527  -117.638   35.791      4.25 21730.68   4.7 1997     7   3
### 1528 1528  -116.349   33.398      4.89 21753.07  12.2 1997     7  26