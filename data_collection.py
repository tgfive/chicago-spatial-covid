# Imports
import pandas as pd
import datetime

# Read in csv and convert dates to DateTime format
df = pd.read_csv("COVID-19_Daily_Cases__Deaths__and_Hospitalizations.csv", parse_dates=["Date"])
# Use only the totals (not demographics)
cols = ["Date", "Cases - Total", "Deaths - Total", "Hospitalizations - Total"]
df = df[cols]

# Make the DateTime the index
df = df.set_index("Date")
# Sort by date
df = df.sort_index()

# Rename the columns for clarification
df = df.rename(columns = {"Cases - Total": "Daily Cases", "Deaths - Total": "Daily Deaths", "Hospitalizations - Total": "Daily Hospitalizations"})

# Create a cumulative deaths column
df["Cum Deaths"] = df["Daily Deaths"].cumsum()

# Drop any rows with missing values (note this ordering preserves the original cum deaths)
df = df.dropna()

# Select a date range (also excludes any missing dates)
df = df.loc["2020-03-01":"2021-07-16"]

# Export to a csv
df.to_csv("chicago_data.csv")
