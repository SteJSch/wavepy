"""
Definition of some physical constants
"""
import math

feinC=1/137
hbar=1.054e-34
elCharge = 1.602e-19 # C
elMass = 9.109e-31 # kg
velC = 299792458 # m/s
vacPermittivity=8.854e-12
elRadius = elCharge**2/(4*math.pi*vacPermittivity*elMass*velC**2)

