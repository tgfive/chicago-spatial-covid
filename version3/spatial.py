# Imports
from skfdiff import Model, Simulation
import numpy as np
import csv
import matplotlib.pyplot as plt

# Image path
impath = '/home/trent/Documents/GitHub/chicago-spatial-covid/version3/images/'

# LaTeX font for matplotlib
import matplotlib
matplotlib.rcParams['mathtext.fontset'] = 'stix'
matplotlib.rcParams['font.family'] = 'STIXGeneral'


# Time points
tbol = 4 # Beginning of lockdown
teol = 73 # End of lockdown
tmid = 35 # Test point in the middle of fitting
tfin = 99 # Last day of fitting
tq = (tbol + teol) / 5 # Calculate tq

# Time step
dt = 0.2

# Parameters
eta = 0.5514 # Lockdown scale factor
D = (5 / 0.72) ** 2 / (4 * dt) # Diffusivity
omegaA = 0.1969 # Transmission rate due to A (initial)
omegaI = 0.3061 # Transmission rate due to I (initial)
gammaA = 0.3632 # Removal rate of A
gammaI = 0.1385 # Removal rate of I
l = 0.0939 # Symptom onset rate

# Time dependent beta function
def omegabeta(omega0beta,eta,t,tq):
    return omega0beta * (eta + (1 - eta) * (1 - np.tanh(2 * (t - tq))) / 2)

# Time dependent D function
def diffusion(D,eta,t,tq):
    return D * (1 - eta * np.heaviside(t - tq,1))


## PDE Model

# Model setup
model = Model(["D * (dxxs + dyys) - (omegaA * a + omegaI * i) * s",
               "D * (dxxa + dyya) + (omegaA * a + omegaI * i) * s - (gammaA - l) * a",
               "- gammaI * i + l * a"], # Governing equations
              ["s(x, y)", "a(x, y)", "i(x, y)"], # Population variables
              parameters=["D", "omegaA", "omegaI", "gammaA", "gammaI", "l"], # Parameters
              boundary_conditions="noflux") # No flux boundary condition (homogeneous Neumann)

# Computational domain
xpoints = 40
ypoints = 29
x = np.linspace(0, xpoints, xpoints)
y = np.linspace(0, ypoints, ypoints)

# Hook function for time dependent parameters
def hook(t, fields):
    global omegaA, omegaI, D, eta, tq
    
    # Define parameters at current time
    omegaA = diffusion(omegaA,eta,t,tq)
    omegaI = diffusion(omegaI,eta,t,tq)
    D = diffusion(D,eta,t,tq)

    # Reassign fields
    fields["omegaA"] = omegaA
    fields["omegaI"] = omegaI
    fields["D"] = D

    return fields

## Simulation 1: t=0 -> t=tq

# Import the initial populations
s1 = np.genfromtxt('initialS.csv', dtype=float, delimiter=",")
a1 = np.genfromtxt('initialA.csv', dtype=float, delimiter=",")
i1 = np.genfromtxt('initialI.csv', dtype=float, delimiter=",")

# Populate the model fields
initial_fields = model.Fields(x=y, y=x, s=s1, a=a1, i=i1, D=D, omegaA=omegaA, omegaI=omegaI, gammaA=gammaA, gammaI=gammaI, l=l)

# Create and run the simulation
simulation = Simulation(model, initial_fields, dt=dt, tmax=tfin, hook=hook)
container = simulation.attach_container()
t, fields = simulation.run()

## Export plots

# Infected plots
for time in [0, tq, tmid, tfin]:
    title = str(int(time))
    container.data["i"].isel(t=int(time / dt)).plot()
    plt.gca().invert_yaxis()
    plt.gca().axes.xaxis.set_visible(False)
    plt.gca().axes.yaxis.set_visible(False)
    plt.savefig(impath + 'infected_' + title + '.pdf')
    plt.show()

# Asymptomatic plots
for time in [0, tq, tmid, tfin]:
    title = str(int(time))
    container.data["a"].isel(t=int(time / dt)).plot()
    plt.gca().invert_yaxis()
    plt.gca().axes.xaxis.set_visible(False)
    plt.gca().axes.yaxis.set_visible(False)
    plt.savefig(impath + 'asymptomatic_' + title + '.pdf')
    plt.show()

# Susceptible plots
for time in [0, tq, tmid, tfin]:
    title = str(int(time))
    container.data["s"].isel(t=int(time / dt)).plot()
    plt.gca().invert_yaxis()
    plt.gca().axes.xaxis.set_visible(False)
    plt.gca().axes.yaxis.set_visible(False)
    plt.savefig(impath + 'susceptible_' + title + '.pdf')
    plt.show()
