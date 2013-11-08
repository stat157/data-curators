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

Sample <-read.csv("/Users/runliang/Desktop/250.csv")

### Notice Sample["HH.mm.SS.ss"] does not contain real numbers,  by looking at jap.quakes,  we need to create a time variable
dates <-Sample[["YYYY.MM.DD"]]
times <-Sample[["HH.mm.SS.ss"]]

datatime <-as.POSIXct(strptime(paste(dates, times), "%Y/%m/%d %H:%M:%OS"))

newtime <-as.numeric(difftime(datatime,datatime[1],units="days"))


NewSample <-data.frame(long=Sample[["LON"]], lat=Sample[["LAT"]], 
                          time=newtime, mag =Sample[["MAG"]], 
                          mag.type=Sample[["M"]], depth=Sample[["DEPTH"]], 
                          ref=Sample[["EVID"]], date=Sample[["YYYY.MM.DD"]])

timedomain = c(floor(min(NewSample$time)),ceiling(max(NewSample$time)))
longdomain = c(floor(min(NewSample$long)),ceiling(max(NewSample$long)))
latdomain = c(floor(min(NewSample$lat)),ceiling(max(NewSample$lat)))
ppxdomain = boxx(t=timedomain,lon=longdomain,lat=latdomain)

CalPPX = ppx(data=NewSample,domain=ppxdomain,
             coord.type =c("s", "s", "t", "m", "m", "m", "m", "m"))

CalPPX
### Multidimensional point pattern
### 250 points 
### 2-dimensional space coordinates (long,lat)
### 1-dimensional time coordinates (time)
### 5 columns of marks: ‘mag’, ‘mag.type’, ‘depth’, ‘ref’ and ‘date’ 
### Domain:
###  3-dimensional box:
###  [0, 250] x [-122, -114] x [32, 37] units  

### DATAFRAME FOR SAPP ============================

### GOALS: Generate a dataframe for the SAPP Package 

# Examples
data(main2003JUL26)
head(main2003JUL26)

Sample <-read.csv("/Users/runliang/Desktop/250.csv")

### Notice Sample["HH.mm.SS.ss"] does not contain real numbers,  by looking at jap.quakes,  we need to create a time variable
numbers <- c(1:nrow(Sample))
long <-Sample[["LON"]]
lat <-Sample[["LAT"]]
magnitude <-Sample[["MAG"]]
dates <-Sample[["YYYY.MM.DD"]]
times <-Sample[["HH.mm.SS.ss"]]
datatime <-as.POSIXct(strptime(paste(dates, times), "%Y/%m/%d %H:%M:%OS"))
newtime <-as.numeric(difftime(datatime,datatime[1],units="days"))

depth <- Sample[["DEPTH"]]
year <- as.numeric(strftime(datatime, format="%Y"))
month <- as.numeric(strftime(datatime, format="%m"))
day <- as.numeric(strftime(datatime, format="%d"))

sappdf = data.frame(no.= numbers,longitude=long,latitude=lat,magnitude=magnitude,
           time=newtime,depth=depth,year=year,month=month,day=day)

head(sappdf)
###     no. longitude latitude magnitude       time depth year month day
### 1   1  -115.969   32.662      1.69   0.000000   5.4 1999     3  27
### 2   2  -118.174   35.124      1.22 161.968950  10.7 1999     9   5
### 3   3  -118.895   33.886      1.90   2.111628  12.0 1999     3  29
### 4   4  -115.574   33.056      2.35 205.645957  12.4 1999    10  18
### 5   5  -116.319   34.863      2.00 262.157378   2.3 1999    12  14
### 6   6  -117.036   34.117      1.32 242.535724  12.4 1999    11  24

tail(sappdf)
###      no. longitude latitude magnitude      time depth year month day
### 245 245  -116.254   34.478      3.48 204.18014   0.0 1999    10  17
### 246 246  -116.585   34.385      1.36 224.34187   6.0 1999    11   6
### 247 247  -116.448   34.265      1.76 206.10031   2.6 1999    10  19
### 248 248  -116.285   34.643      2.23 213.86433   6.0 1999    10  27
### 249 249  -116.842   34.332      1.17 -14.02178   8.4 1999     3  13
### 250 250  -116.278   34.657      1.70 265.21398  11.8 1999    12  17