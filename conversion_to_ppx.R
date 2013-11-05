install.packages("spatstat")
library(spatstat)
install.packages("ETAS")
library(ETAS)

### EXAMPLE ON HOW TO CREATE PPX ============================================
# Example 1
df <-data.frame(x <-runif(4), y <-runif(4), t <-runif(4), 
                 age <-rep(c("old",  "new"),  2), 
                 size <-runif(4))
X <-ppx(data <-df,  coord.type <-c("s", "s", "t", "m", "m"))
X

# Example 2
val <- 20 * runif(4)
E <- lapply(val, function(s) { rpoispp(s) })
hf <- hyperframe(t=val, e=as.listof(E))
Z <- ppx(data=hf, domain=c(0,1))
Z

# Example 3-4
jap.quakes 
iran.quakes

### GOALS: We will try to convert the clear data into a "ppx".
### "ppx": A dataframe with spatio-temporal observations 
### In this case time,  long,  lat,  mag,  mag.type,  depth,  ref,  date
### as well as setting a specified domain of data

###  CONVERTING CLEAN DATA INTO PPX ====================================================

data1933 <-read.csv("./clean_data/1933.catalog.csv")
data1933 = data1933[1:(nrow(data1933)-2),]

### Notice data1933["HH.mm.SS.ss"] does not contain real numbers,  by looking at jap.quakes,  we need to create a time variable
dates <-data1933[["YYYY.MM.DD"]]
times <-data1933[["HH.mm.SS.ss"]]

datatime <-as.POSIXct(strptime(paste(dates, times), "%Y/%m/%d %H:%M:%OS"))

newtime <-as.numeric(difftime(datatime,datatime[1],units="days"))

NewData1933 <-data.frame(long=data1933[["LON"]], lat=data1933[["LAT"]], 
                          time=newtime, mag =data1933[["MAG"]], 
                          mag.type=data1933[["M"]], depth=data1933[["DEPTH"]], 
                          ref=data1933[["EVID"]], date=data1933[["YYYY.MM.DD"]])
PPX1933 = ppx(data=NewData1933,domain=c(c(1,2),c(2,3),c(3,4)),
                coord.type =c("s", "s", "t", "m", "m", "m", "m", "m"))
PPX1933

### ROADBLOCKS ==========================================================================
# Data is not clean. Last two rows have non-relevant content
