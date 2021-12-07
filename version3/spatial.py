from skfdiff import Model, Simulation
import numpy as np
import csv
import matplotlib.pyplot as plt

model = Model(["D * (dxxs + dyys) - (omegaA * a + omegaI * i) * s",
               "D * (dxxa + dyya) + (omegaA * a + omegaI * i) * s - (gammaA - l) * a",
               "- gammaI * i + l * a"],
              ["s(x, y)", "a(x, y)", "i(x, y)"],
              parameters=["D", "omegaA", "omegaI", "gammaA", "gammaI", "l"],
              boundary_conditions="noflux")

L = 40
x = y = np.linspace(0, L, L)
xx, yy = np.meshgrid(x, y, indexing="ij")

s = np.genfromtxt('initialS.csv', dtype=float, delimiter=",")
a = np.genfromtxt('initialA.csv', dtype=float, delimiter=",")
i = np.genfromtxt('initialI.csv', dtype=float, delimiter=",")

initial_fields = model.Fields(x=x, y=y, s=s, a=a, i=i, D=1.105, omegaA=0.1517, omegaI=0.1860, gammaA=0.6329, gammaI=0.2599, l=0.3264)

simulation = Simulation(model, initial_fields, dt=.1, tmax=35)
container = simulation.attach_container()
tmax, final_fields = simulation.run()

initial_fields["a"].plot()
plt.gca().invert_yaxis()
plt.gca().axes.xaxis.set_visible(False)
plt.gca().axes.yaxis.set_visible(False)
plt.show()
plt.savefig('asymptomatic-initial.png')

initial_fields["i"].plot()
plt.gca().invert_yaxis()
plt.gca().axes.xaxis.set_visible(False)
plt.gca().axes.yaxis.set_visible(False)
plt.savefig('infected-initial.png')
plt.show()

final_fields["a"].plot()
plt.gca().invert_yaxis()
plt.gca().axes.xaxis.set_visible(False)
plt.gca().axes.yaxis.set_visible(False)
plt.savefig('asymptomatic-final.png')
plt.show()

final_fields["i"].plot()
plt.gca().invert_yaxis()
plt.gca().axes.xaxis.set_visible(False)
plt.gca().axes.yaxis.set_visible(False)
plt.savefig('infected-final.png')
plt.show()
