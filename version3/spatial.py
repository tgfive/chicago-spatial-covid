# Imports
from skfdiff import Model, Simulation
import numpy as np
import csv
import matplotlib.pyplot as plt

# Image path
impath = '/home/trent/Documents/GitHub/chicago-spatial-covid/version3/images/'
#impath = '/Users/trentgerew/GitHub/chicago-spatial-covid/version3/images/'

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
dt = 0.1

# Parameters
eta = 0.5514 # Lockdown scale factor
D = 5 / 0.72 # Diffusivity
#D = (5 / 0.72) ** 2 / (4 * dt) # Diffusivity
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
    return D * (1 - (1 - eta) * np.heaviside(t - tq,1))


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
x = np.linspace(0, 100, xpoints)
y = np.linspace(0, 100, ypoints)

# Check computational stability
s1 = dt / x[1] ** 2
s2 = dt / y[1] ** 2
if not s1 < 0.5 or not s2 < 0.5:
    print('Bad time step.')
    sys.exit()

# Hook function for time dependent parameters
def hook(t, fields):
	global omegaA, omegaI, D, eta, tq

	# Define parameters at current time
	omegaA = omegabeta(omegaA,eta,t,tq)
	omegaI = omegabeta(omegaI,eta,t,tq)

	# Reassign fields
	fields["omegaA"] = omegaA
	fields["omegaI"] = omegaI

	return fields

sim_start = 0
## Simulation
for sim_end in [tbol, tq, tmid, teol, tfin]:
    # Initial populations
    if sim_start == 0:
        # Import initial populations from file
        s0 = np.genfromtxt('initialS.csv', dtype=float, delimiter=",")
        a0 = np.genfromtxt('initialA.csv', dtype=float, delimiter=",")
        i0 = np.genfromtxt('initialI.csv', dtype=float, delimiter=",")
    else:
        # Set initial populations to final populations from previous simulation
        s0 = container.data["s"].isel(t=int(tmax/dt))
        a0 = container.data["a"].isel(t=int(tmax/dt))
        i0 = container.data["i"].isel(t=int(tmax/dt))

    # Populate the model fields
    initial_fields = model.Fields(x=y, y=x, s=s0, a=a0, i=i0, D=diffusion(D,eta,sim_start,tbol), omegaA=omegabeta(omegaA,eta,sim_start,tq), omegaI=omegabeta(omegaI,eta,sim_start,tq), gammaA=gammaA, gammaI=gammaI, l=l)

    # Calculate final simulation time
    tmax = sim_end - sim_start

    # Create and run the simulation
    simulation = Simulation(model, initial_fields, dt=dt, tmax=tmax)
    container = simulation.attach_container()
    t, fields = simulation.run()

    # Export plots
    # Infected plots
    title = str(int(sim_end))
    container.data["i"].isel(t=int(tmax/dt)).plot()
    plt.gca().invert_yaxis()
    plt.gca().axes.xaxis.set_visible(False)
    plt.gca().axes.yaxis.set_visible(False)
    plt.savefig(impath + 'infected_' + title + '.pdf')
    plt.show()

    # Asymptomatic plots
    title = str(int(sim_end))
    container.data["a"].isel(t=int(tmax/dt)).plot()
    plt.gca().invert_yaxis()
    plt.gca().axes.xaxis.set_visible(False)
    plt.gca().axes.yaxis.set_visible(False)
    plt.savefig(impath + 'asymptomatic_' + title + '.pdf')
    plt.show()

    # Susceptible plots
    title = str(int(sim_end))
    container.data["s"].isel(t=int(tmax/dt)).plot()
    plt.gca().invert_yaxis()
    plt.gca().axes.xaxis.set_visible(False)
    plt.gca().axes.yaxis.set_visible(False)
    plt.savefig(impath + 'susceptible_' + title + '.pdf')
    plt.show()

    ## Prepare for next simulation
    sim_start = sim_end
