
import sys
sys.path.insert(0, '../src/')

from wavepy import WaveFromB
from wavepy import ExtractAndPlot
import pdb

# Create wave instance for spectrum calculation from b-field data
wave = WaveFromB('undu_ellip') # get a wave instance that calculates spectrum for a simple elliptical undulator

# Get Wave-parameter
paras = wave.get_paras()
# Customize Parameters
paras.field_folder.set('Fields/Interpolated/')# Field Folder
paras.field_files.set( [ 'interp_b_field_gap_18.45_.dat'] )# The magnetic field files to be used in the simulation
paras.res_folder.set('Spectrum_Results/Test/') # where to store the wave results
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

# Setting Undulator Parameters
paras.undu_ellip.set(1)
paras.b0y.set(0.3)
paras.b0z.set(0.0)
paras.nper.set(15)
paras.ell_shift.set(0.25)
paras.perl_x.set(0.02)

# Set Parameters
wave.set_paras(paras)
# Run WAVE
wave.run_wave()

# Extract and Plot Results
ep = ExtractAndPlot(paras)

# Plot everything, everywhere and all at once
data = ep.extract_wave_results(results = [ 'flux_dens_distr', 
                                            'traj_magn',
                                            'power_distr',
                                            'flux',
                                            'flux_dens',
                                            'brill' ], 
                                plot = False, 
                                en_range = [100,105], 
                                save_data_w_pics = True)


## Plot Distributions over given energy range:
data = ep.extract_wave_results(results = ['flux_dens_distr' ], 
                                 plot = True, 
                                 en_range = [100,105])

#pdb.set_trace()