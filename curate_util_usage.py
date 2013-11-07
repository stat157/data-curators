import sys
import urllib
import os
import pandas as pd
import curate_util as CU
import random

if __name__ == "__main__":

    #Simple Version
    catalog_dict = CU.grab_data_dict(1998,1999, 'clean_data/')
    data_frame  = CU.grab_data_frame(catalog_dict)
    print data_frame.tail(10)

    #Not asking to also return datetime row.
    catalog_dict = CU.grab_data_dict(1998,1999, 'clean_data/')
    data_frame  = CU.grab_data_frame(catalog_dict, convert_datetime=True)
    print data_frame.head(10)

    #Sample on actually converting numbers to float and working with them.
    catalog_dict = CU.grab_data_dict(1999,1999, 'clean_data/')
    data_frame  = CU.grab_data_frame(catalog_dict)
    data_frame['MAG'].apply(float)
    average = sum(data_frame['MAG'])/float(len(data_frame['MAG']))
    print "Average Magnitude in 1999: %s" % average


    #return 250 rows 
    catalog_dict = CU.grab_data_dict(1999,1999, 'clean_data/')
    data_frame  = CU.grab_data_frame(catalog_dict)
    rows = random.sample(data_frame.index, 250)
    df_250 = data_frame.ix[rows]
    print df_250
