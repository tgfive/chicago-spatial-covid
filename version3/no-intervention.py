# Imports
from skfdiff import Model, Simulation
import numpy as np
import csv
import matplotlib.pyplot as plt

# LaTeX font for matplotlib
import matplotlib
matplotlib.rcParams['mathtext.fontset'] = 'stix'
matplotlib.rcParams['font.family'] = 'STIXGeneral'


# Time points
tq = 11 # Lockdown point tq = (tbol + teol) / 5
tmid = 35 # Test point in the middle of fitting
tfin = 99 # Last day of fitting

# Parameters
eta = 0.5514 # Lockdown scale factor
D = 1.105 # Diffusivity
omegaA = 0.1969 # Transmission rate due to A (initial)
omegaI = 0.3061 # Transmission rate due to I (initial)
gammaA = 0.3632 # Removal rate of A
gammaI = 0.1385 # Removal rate of I
l = 0.0939 # Symptom onset rate


## PDE Model

# Model setup
model = Model(["D * (dxxs + dyys) - (omegaA * a + omegaI * i) * s",
               "D * (dxxa + dyya) + (omegaA * a + omegaI * i) * s - (gammaA - l) * a",
               "- gammaI * i + l * a"], # Governing equations
              ["s(x, y)", "a(x, y)", "i(x, y)"], # Population variables
              parameters=["D", "omegaA", "omegaI", "gammaA", "gammaI", "l"], # Parameters
              boundary_conditions="noflux") # No flux boundary condition (homogeneous Neumann)

# Computational domain
L = 40 # Space points
x = y = np.linspace(0, L, L) # Domain space


## Simulation 1: t=0 -> t=tq

# Import the initial populations
s1 = np.genfromtxt('initialS.csv', dtype=float, delimiter=",")
a1 = np.genfromtxt('initialA.csv', dtype=float, delimiter=",")
i1 = np.genfromtxt('initialI.csv', dtype=float, delimiter=",")

# Populate the model fields
initial_fields1 = model.Fields(x=x, y=y, s=s1, a=a1, i=i1, D=D, omegaA=omegaA, omegaI=omegaI, gammaA=gammaA, gammaI=gammaI, l=l)

# Create and run the simulation
simulation1 = Simulation(model, initial_fields1, dt=.1, tmax=tq)
container1 = simulation1.attach_container()
tmax1, final_fields1 = simulation1.run()

# Export results
initial_fields1["i"].plot()
plt.gca().invert_yaxis()
plt.gca().axes.xaxis.set_visible(False)
plt.gca().axes.yaxis.set_visible(False)
plt.savefig('ni-infected-t0.pdf')
plt.show()

final_fields1["i"].plot()
plt.gca().invert_yaxis()
plt.gca().axes.xaxis.set_visible(False)
plt.gca().axes.yaxis.set_visible(False)
plt.savefig('ni-infected-tq.pdf')
plt.show()

## Simulation 2: t=tq -> t=tmid

# Use the final fields from Simulation 1 to seed Simulation 2
s2 = final_fields1["s"]
a2 = final_fields1["a"]
i2 = final_fields1["i"]

# Populate the model fields
initial_fields2 = model.Fields(x=x, y=y, s=s2, a=a2, i=i2, D=D, omegaA=omegaA, omegaI=omegaI, gammaA=gammaA, gammaI=gammaI, l=l)

# Create and run the simulation
simulation2 = Simulation(model, initial_fields2, dt=.1, tmax=tmid-tq)
container2 = simulation2.attach_container()
tmax2, final_fields2 = simulation2.run()

# Export results
final_fields2["i"].plot()
plt.gca().invert_yaxis()
plt.gca().axes.xaxis.set_visible(False)
plt.gca().axes.yaxis.set_visible(False)
plt.savefig('ni-infected-tmid.pdf')
plt.show()


## Simulation 3: t=tmid -> t=tfin

# Use the final fields from Simulation 2 to seed Simulation 3
s3 = final_fields2["s"]
a3 = final_fields2["a"]
i3 = final_fields2["i"]

# Populate the model fields
initial_fields3 = model.Fields(x=x, y=y, s=s3, a=a3, i=i3, D=D, omegaA=omegaA, omegaI=omegaI, gammaA=gammaA, gammaI=gammaI, l=l)

# Create and run the simulation
simulation3 = Simulation(model, initial_fields3, dt=.1, tmax=tfin-tmid-tq)
container2 = simulation3.attach_container()
tmax3, final_fields3 = simulation3.run()

# Export results
final_fields3["i"].plot()
plt.gca().invert_yaxis()
plt.gca().axes.xaxis.set_visible(False)
plt.gca().axes.yaxis.set_visible(False)
plt.savefig('ni-infected-tfin.pdf')
plt.show()
