# Imports
import pandas as pd
import datetime
import matplotlib.pyplot as plt

# LaTeX font for matplotlib
import matplotlib
matplotlib.rcParams['mathtext.fontset'] = 'stix'
matplotlib.rcParams['font.family'] = 'STIXGeneral'

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
df["Cumulative Deaths"] = df["Daily Deaths"].cumsum()

# Drop any rows with missing values (note this ordering preserves the original cum deaths)
df = df.dropna()

# Select a date range (also excludes any missing dates)
df = df.loc["2020-03-01":"2021-10-26"]

# Export to a csv
df.to_csv("chicago_data.csv")

# Create labels
label_list = [
    (pd.to_datetime("2020-03-21"), 'Shelter-in-place\nbegins.', 'm', 1000),
    (pd.to_datetime("2020-04-24"), 'Mask mandate\nbegins.', 'brown', 1550),
    (pd.to_datetime("2020-05-5"), 'Phase 2', 'c', 200),
    (pd.to_datetime("2020-05-29"), 'Shelter-in-place\nends.', 'm', 1000),
    (pd.to_datetime("2020-06-3"), 'Phase 3', 'c', 550),
    (pd.to_datetime("2020-06-26"), 'Phase 4', 'c', 200),
    (pd.to_datetime("2021-01-25"), 'Limited vaccination begins.', 'indigo', 1000),
    (pd.to_datetime("2021-04-12"), 'General vaccination\nbegins.', 'indigo', 500),
    (pd.to_datetime("2021-05-18"), 'Mask mandate\nends.', 'brown', 1050),
    (pd.to_datetime("2021-06-11"), 'Phase 5', 'c', 200),
    (pd.to_datetime("2021-08-30"), 'Mask mandate\nreinstated.', 'brown', 1000)
]

# Create plot
df.plot(figsize=(12,8))

ax = plt.gca()
for date_point, label, clr, y in label_list:
    plt.axvline(x=date_point, color=clr)
    plt.text(date_point, ax.get_ylim()[1]-y, label,
             horizontalalignment='center',
             verticalalignment='center',
             color=clr,
             bbox=dict(facecolor='white', alpha=0.9))
plt.show()

# Export plot
plt.savefig('chicago-data.pdf')
