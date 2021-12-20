import pandas as pd
import numpy as np

path = "/home/trent/Documents/GitHub/chicago-spatial-covid/version3/"

df = pd.read_csv("COVID-19_Cases__Tests__and_Deaths_by_ZIP_Code.csv")

cols = ["ZIP Code", "Week Start", "Cases - Weekly", "Deaths - Cumulative", "Population"]
df = df[cols]

#df = df[df["Week Start"] == "04/19/2020"]
#df = df[df["Week Start"] == "03/29/2020"]
#df = df[df["Week Start"] == "06/21/2020"]
df = df[df["Week Start"] == "03/15/2020"]
df = df[df["ZIP Code"] != "Unknown"]
df["Cases - Weekly"] = df["Cases - Weekly"].replace(np.nan, 0)

cols = ["ZIP Code", "Cases - Weekly", "Deaths - Cumulative", "Population"]
df = df[cols]

df.to_csv(path + "t0_data.csv", index=False, header=False)
