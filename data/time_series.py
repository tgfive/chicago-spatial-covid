# Imports
import pandas as pd
import numpy as np

# Read in csv and convert dates to DateTime format
df = pd.read_csv("chicago_data.csv", parse_dates=["Date"])

cases = df["Daily Cases"] + df["Daily Hospitalizations"] + df["Cumulative Deaths"]
removed = df["Cumulative Deaths"]

t_values = np.linspace(0,1,len(df.loc[:, "Date"]))
