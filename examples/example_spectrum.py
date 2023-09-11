
import sys
sys.path.insert(0, '../src/')

from wavepy import WaveFromB
import pdb
from wavepy import ExtractAndPlot


# Create wave instance for spectrum calculation from b-field data
wave = WaveFromB('By') # get a wave instance that calculates from By and Bz

# Get Wave-parameter
paras = wave.get_paras()
# Customize Parameters
paras.field_folder.set('/home/jerostan/Dokumente/Very_Unimportant/Arbeit/HZB/Undus/Simus/Python_Code/wavepy_simone/examples/Fields/Interpolated/')# Field Folder
paras.field_files.set( [ 'interp_b_field_gap_18.45_.dat'] )# The magnetic field files to be used in the simulation
paras.res_folder.set('/home/jerostan/Dokumente/Very_Unimportant/Arbeit/HZB/Undus/Simus/Python_Code/wavepy_simone/examples/Spectrum_Results/first/') # where to store the wave results
paras.spec_calc.set(1) # calculate spectrum? if not, only trajectory is calculated
paras.freq_low.set(100)   # lower frequency for spectrum calc. [eV]
paras.freq_high.set(105)  # upper frequency for spectrum calc. [eV]
paras.freq_num.set(5) # number of frequencies for spectrum calc. [eV]
paras.pinh_w.set(3)   # pinhole width (horizontal-z) [mm]
paras.pinh_h.set(3)   # pinhole height (vertical-y) [mm]
paras.pinh_x.set(10) 	  # pinhole distance in beam direction (x) [m]
paras.pinh_nz.set(21)	  # number of horizontal points in pinhole for spec. calc.
paras.pinh_ny.set(21)   # number of vetical points in pinhole for spec. calc.
paras.wave_res_copy_behaviour.set('copy_essentials') #'copy_all'

# Set Parameters
wave.set_paras(paras)
# Extract and Plot Results
ep = ExtractAndPlot(paras)
# Plot trajectory
data = ep.extract_wave_results(results = [ 'traj_magn' ], 
                                 plot = False, 
                                 en_range = [], 
                                 save_data_w_pics = True)

# Plot everything, everywhere and all at once
data = ep.extract_wave_results(results = [ 'flux_dens_distr', 
                                            'traj_magn',
                                            'power_distr',
                                            'flux',
                                            'flux_dens',
                                            'brill' ], 
                                plot = False, 
                                en_range = [10,20], 
                                save_data_w_pics = True)

## Plot 2d-Plots:
data = ep.extract_wave_results(results = ['traj_magn',
                                            'power_distr',
                                            'flux',
                                            'flux_dens',
                                            'brill' ], 
                                 plot = True, 
                                 en_range = [])

## Plot Distributions over given energy range:
data = ep.extract_wave_results(results = ['flux_dens_distr' ], 
                                 plot = True, 
                                 en_range = [220,230])

# # Plot Distributions over total simulated energy range:
data = ep.extract_wave_results(results = ['flux_dens_distr' ], 
                                 plot = True, 
                                 en_range = [])

## Plot Distributions and clip x and y axes:
data = ep.extract_wave_results(results = ['flux_dens_distr' ], 
                                 plot = True, 
                                 en_range = [], 
                                 xlim = [-1,1], 
                                 ylim = [-1,1])
