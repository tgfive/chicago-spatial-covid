from skfdiff import Model, Simulation
import pylab as pl
import numpy as np
from scipy.signal.windows import gaussian

model = Model(["D * (dxxs + dyys) - (omegaA * a + omegaI * i) * s",
               "D * (dxxa + dyya) + (omegaA * a + omegaI * i) * s - (gammaA - delta) * a",
               "- gammaI * i + delta * a"],
              ["s(x, y)", "a(x, y)", "i(x, y)"],
              parameters=["D", "omegaA", "omegaI", "gammaA", "gammaI", "delta"],
              boundary_conditions="noflux")

L = 20
x = y = np.linspace(0, L, 20)
xx, yy = np.meshgrid(x, y, indexing="ij")
