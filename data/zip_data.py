import pandas as pd
import datetime

df = pd.read_csv("COVID-19_Cases__Tests__and_Deaths_by_ZIP_Code.csv")

cols = ["ZIP Code", "Week Number", "Cases - Weekly", "Deaths - Cumulative", "Population"]
df = df[cols]
