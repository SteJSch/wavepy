"""
Contains the import statements for wavepy modules
"""
import os
import pandas as pd
import pdb
import math
import numpy as np
import scipy.special as ss
import matplotlib.pyplot as plt
import wavepy.physical_constants as pc
import sys
import pdb
import shutil
import random
from scipy.interpolate import CubicSpline
from scipy.integrate import quad
from datetime import datetime
from scipy import interpolate
from scipy import integrate
from scipy.integrate import nquad
from scipy.signal import find_peaks
from matplotlib import cm
from pathlib import Path
from matplotlib.ticker import LinearLocator, FormatStrFormatter
from mpl_toolkits.mplot3d import Axes3D
import time

random.seed(datetime.now().timestamp())
cm_inch = 1/2.54

def to_scn(number,norm=True):
	"""
	converts number to scientific notation
	"""
	if norm : 
		return '{:.5E}'.format(number)
	else :
		a, b = '{:.4E}'.format(number).split('E')
		return '{:.5f}E{:+03d}'.format(float(a)/10, int(b)+1)