#Author: Tristan Tao

from pandas import read_csv
from pandas import concat
import pandas as pd
import re
import os


def grab_data_dict(start_year, end_year, target_dir):
    '''
    Return a dict of catalogs: <relative_path:year>
    The catalogs will fall in the years between start_year and end_year.
    '''

    target_years = range(start_year, end_year+1)
    print "working with the following years %s" % target_years
    catalog_extraction = {}

    for curdir, dirs, files in os.walk(target_dir):
        for check_file in files:
            regex_res = re.findall('\d+', check_file)
            if len(regex_res) == 1: #only one number
                extracted_year = int(regex_res[0])
                if extracted_year in target_years:
                    catalog_extraction[os.path.join(curdir, check_file)] = extracted_year
    return catalog_extraction

def grab_data_frame(catalog_dict):
    '''
    Given a catalog_dict, 
    '''
    data_frame = pd.DataFrame()
    for csv_location, year in catalog_dict.items():
        partial_data = pd.read_csv(csv_location)
        data_frame = concat([data_frame, partial_data])
    return data_frame

