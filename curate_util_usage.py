import sys
import urllib
import os
import pandas as pd
import curate_util as CU

if __name__ == "__main__":

    catalog_dict = CU.grab_data_dict(1998,1999, 'clean_data/')
    data_frame  = CU.grab_data_frame(catalog_dict)
    print data_frame

    catalog_dict = CU.grab_data_dict(1998,1998, 'clean_data/')
    data_frame  = CU.grab_data_frame(catalog_dict)
    print data_frame

    catalog_dict = CU.grab_data_dict(1999,1999, 'clean_data/')
    data_frame  = CU.grab_data_frame(catalog_dict)
    print data_frame

