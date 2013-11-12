################### FURTHER DATA CLEAN UP: GENERATE PPX BASED ON CLEANED DATA ##################

# Load the data provided by data curators
cleandata=read.csv("~/CleanData1938-2013.csv")

# Load ETAS package
# Uncomment next line to install the package if necessary
# install.packages("ETAS")
library(ETAS)
library(scatterplot3d)

FlexibleEpicPPX=function(original_data, select_function=NA) {
  if(is.function(select_function)) {
    # Convert data in the frame to vectors
    str_date  = as.character(original_data$YYYY.MM.DD)
    str_hms   = as.character(original_data$HH.mm.SS.ss)
    list_date = strsplit(str_date, "/")
    list_hms  = strsplit(str_hms, ".")
    YEAR      = sapply(list_date, function(x) {as.numeric(x[1])})
    MONTH     = sapply(list_date, function(x) {as.numeric(x[2])})
    DAY       = sapply(list_date, function(x) {as.numeric(x[3])})
    HOUR      = sapply(list_hms , function(x) {as.numeric(x[1])})
    MIN       = sapply(list_hms , function(x) {as.numeric(x[2])})
    SEC       = sapply(list_hms , function(x) {as.numeric(x[3])}) +
                sapply(list_hms , function(x) {as.numeric(x[4])*0.01})
    MAG       = as.numeric(cleandata$MAG)
    DEPTH     = as.numeric(cleandata$DEPTH)
    LAT       = as.numeric(cleandata$LAT)
    LON       = as.numeric(cleandata$LON)
    # Call the select_function provided by analyzer to filter data
    data=original_data[select_function(year=YEAR, month=MONTH, day=DAY,
                                       hour=HOUR, min  =MIN  , sec=SEC,
                                       mag =MAG , depth=DEPTH, lat=LAT, lon=LON), ]
  } else {
    data=original_data
  }
  
  # Prepare for PPX Generation
  event_date  = as.character(data$YYYY.MM.DD)
  event_hms   = as.character(data$HH.mm.SS.ss)
  event_time  = paste(event_date, event_hms)
  event_year  = as.numeric(gsub("/.*","",event_date))
  start_date  = paste(as.character(min(event_year)),sep="/","01/01 00:00:00")
  event_time1 = date2day(event_time, start_date, tz="GMT") 
  
  data_ppx = ppx(data=data.frame(time=event_time1, long=data$LON, lat=data$LAT,
                                 mag=data$MAG, depth=data$DEPTH, date=event_time),
                 domain=c(c(min(event_time1),max(event_time1)),
                          c(min(data$LON),max(data$LON)),
                          c(min(data$LAT),max(data$LAT))),
                 coord.type =c("temporal","spatial","spatial","mark","mark","mark"))
}

####################### Sample selection_function ##########################
year_min=1960
year_max=2000
months=c(1:6)
depth_min=0
depth_max=5
mag_min=3
mag_max=10
# The select_function suppose to return a vector, records associated with "true" will be kept.
sample_select_func=function(year, month, day, hour, min, sec, mag, depth, lat, lon) {
  (year >= year_min) & (year <= year_max) & ( month %in% months ) & 
  ( depth >= depth_min ) & (depth <= depth_max) & (mag>=mag_min) & (mag<mag_max) 
}


################################ Demo ######################################
ppx_all     = FlexibleEpicPPX(cleandata)
ppx_partial = FlexibleEpicPPX(cleandata, sample_select_func)
plot(ppx_all, main="Scatter Plot of Epic Records", pch=20)
plot(ppx_partial, main="Scatter Plot of Partial Epic Records", pch=20)
