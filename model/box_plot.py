# Imports
import pandas as pd
import matplotlib.pyplot as plt

# LaTeX font for matplotlib
import matplotlib
matplotlib.rcParams['mathtext.fontset'] = 'stix'
matplotlib.rcParams['font.family'] = 'STIXGeneral'

# Read in csv and label the columns
df = pd.read_csv("pEst1.csv")
columns = [r'$\omega_0 \beta_A$', r'$\omega_0 \beta_I$', r'$\eta$', r'$\gamma_A$', r'$\gamma_I$', r'$\delta$']
df.columns = columns

# Create a boxplot
boxplot = df.boxplot(column=columns)
boxplot.plot()

# Export plot
plt.savefig('/home/trent/Documents/GitHub/chicago-spatial-covid/version3/images/box-plot.pdf')

# Plot the boxplot
plt.show()
