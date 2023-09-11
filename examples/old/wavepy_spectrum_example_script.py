"""
Example script file showing the usage of wavepy
"""
import wavepy as wpy
import pdb

# Create wave instance for spectrum calculation from b-field data
wave = wpy.create_wave_instance('wave_from_by') # get a wave instance that calculates from By and Bz
# Get Wave-parameter
paras = wave.get_paras()
# Customize Parameters
paras['field_folder'] = 'Fields/Interpolated/' # Field Folder
paras['field_files'] =  [ 'interp_b_field_gap_18.45_.dat'] # The magnetic field files to be used in the simulation
paras['res_folder'] = '/home/simone/Documents/WavePy/wavepy/Spectrum_Results/First_Simu/' # where to store the wave results
paras['spec_calc'] = 1 # calculate spectrum? if not, only trajectory is calculated
paras['freq_low'] = 100   # lower frequency for spectrum calc. [eV]
paras['freq_high'] = 105  # upper frequency for spectrum calc. [eV]
paras['freq_num'] = 5 # number of frequencies for spectrum calc. [eV]
paras['pinh_w'] = 3   # pinhole width (horizontal-z) [mm]
paras['pinh_h'] = 3   # pinhole height (vertical-y) [mm]
paras['pinh_x'] = 10 	  # pinhole distance in beam direction (x) [m]
paras['pinh_nz'] = 21	  # number of horizontal points in pinhole for spec. calc.
paras['pinh_ny'] = 21   # number of vetical points in pinhole for spec. calc.
paras['wave_res_copy_behaviour'] = 'copy_essentials' #'copy_all'

# Set Parameters
wave.set_paras(paras)
# Run WAVE
wave.run_wave()

# Extract and Plot Results

# Plot trajectory
# data = wave.extract_wave_results(results = [ 'traj_magn' ], plot = True, en_range = [], save_data_w_pics = True)

# Plot everything, everywhere and all at once
# data = wave.extract_wave_results(results = [ 'flux_dens_distr', 'traj_magn','power_distr','flux','flux_dens',\
#    			'brill' ], plot = True, en_range = [10,20], save_data_w_pics = True)

## Plot 2d-Plots:
# data = wave.extract_wave_results(results = ['traj_magn','power_distr','flux','flux_dens','brill' ], 
#                                  plot = True, en_range = [])
## Plot Distributions over given energy range:
#data = wave.extract_wave_results(results = ['flux_dens_distr' ], plot = True, en_range = [220,230])

# Plot Distributions over total simulated energy range:
#data = wave.extract_wave_results(results = ['flux_dens_distr' ], plot = True, en_range = [])

## Plot Distributions and clip x and y axes:
#data = wave.extract_wave_results(results = ['flux_dens_distr' ], plot = True, en_range = [], xlim = [-1,1], ylim = [-1,1])
