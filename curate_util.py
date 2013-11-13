#Author: Tristan Tao

from pandas import concat
import pandas as pd
import os
import re


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

def grab_data_frame(catalog_dict, convert_datetime = False, minimum_magnitude = 0.0):
    '''
    Given a catalog_dict, returns the actual corresponding dataframe.
    Does additional conversion when specifying datatime = True. It will
    actually reutrn a column with datetime object in it.
    '''
    data_frame = pd.DataFrame()
    total_processed = 0
    for csv_location, year in catalog_dict.items():
        partial_data = pd.read_csv(csv_location)
        if convert_datetime:
            partial_data["datetime"] = ""
            end_index = len(partial_data["YYYY/MM/DD"])
            print "\nTotal rows in year %s : %s" % (year, end_index)
            for i in xrange(end_index):
                total_processed += 1
                partial_data["datetime"][i] = str(partial_data["YYYY/MM/DD"][i]) + " " +str(partial_data["HH:mm:SS.ss"][i])
                if total_processed % 10000 == 0:
                    print "Cumulative processed %s" % total_processed
            partial_data["datetime"]= pd.to_datetime(partial_data["datetime"])
        data_frame = concat([data_frame, partial_data])
    data_frame = data_frame[data_frame.MAG > minimum_magnitude]
    return data_frame

