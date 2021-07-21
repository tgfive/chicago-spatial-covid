# Imports
import pandas as pd
import numpy as np

# Read in csv and convert dates to DateTime format
df = pd.read_csv("chicago_data.csv", parse_dates=["Date"])

# Create a new dataframe
series = pd.DataFrame()

# Create uniform time values and put them in the dataframe
t_values = np.linspace(0,1,len(df.loc[:, "Date"]))
series["Time"] = pd.Series(t_values)

# Create cases values and put them in the dataframe
series["Cases"] = df["Daily Cases"] + df["Daily Hospitalizations"] + df["Cumulative Deaths"]

# Create removed values and put them in the dataframe
series["Removed"] = df["Cumulative Deaths"]

# Export new dataframe to a csv
series.to_csv("time_series.csv", header=False, index=False)
