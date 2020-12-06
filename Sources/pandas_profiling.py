# -*- coding: utf-8 -*-
"""
Created on Fri Dec  4 10:53:57 2020

@author: Gabry
"""

import pandas as pd
import pandas_profiling

df = pd.read_csv("data/spotify_data.csv")

ttt = pandas_profiling.ProfileReport(df)
ttt.to_file('profile_report.html')
