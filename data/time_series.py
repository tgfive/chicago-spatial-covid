# Imports
import pandas as pd
import numpy as np

# Read in csv and convert dates to DateTime format
df = pd.read_csv("chicago_data.csv", parse_dates=["Date"])
df = df.set_index(["Date"])

# Select the date range
start = '2020-03-18' # start of data collection
end = '2020-09-30' # end of first wave

# Reform dataframe to date range
df = df.loc[start:end]

# Create a new dataframe
series = pd.DataFrame()

# Set dates to be index of the dataframe
series["Date"] = df.index
series = series.set_index(["Date"])

# Create cases values and put them in the dataframe
series["Cases"] = df["Daily Cases"] + df["Daily Hospitalizations"] + df["Cumulative Deaths"]

# Create removed values and put them in the dataframe
series["Removed"] = df["Cumulative Deaths"]

# Export new dataframe to a csv
series.to_csv("../local-model/time_series.csv", header=False, index=False)
