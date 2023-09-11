"""
Example script file showing the usage of wavepy's b-field functionality
"""

import sys
sys.path.insert(0, '../src/wavepy/')

import wavepy as wpy

# Define the folder where the measured b-field data is stored
b_field_orig_folder = "/home/simone/Documents/WavePy/wavepy/examples/Fields/Original/"
# Define the folder where the processed b-field data will be stored
b_field_processed_folder = "/home/simone/Documents/WavePy/wavepy/examples/Fields/Processed/"
# Define the folder where the interpolated b-field data will be stored
b_field_interp_folder = '/home/simone/Documents/WavePy/wavepy/examples/Fields/Interpolated/'

#******************************************************************************************************
#*****************Load Original B-Field Data and Plot**************************************************
#******************************************************************************************************

# # Load Data
# b_field_data = wpy.load_b_fields_gap(folder = b_field_orig_folder)
# # Plot Data
# wpy.plot_b_field_data( b_fields = b_field_data )

#******************************************************************************************************
#*****************Load Original B-Field Data, Center, Plot and Save Processed Data*********************
#******************************************************************************************************

# # WAVE takes B-Field data in mm
# # Load Field Data
# b_field_data = wpy.load_b_fields_gap(folder = b_field_orig_folder)
# wpy.gauge_b_field_data(b_fields = b_field_data, col = 'x', gauge_fac = 1)
# # Center the Data
# wpy.center_b_field_data( b_fields = b_field_data, lim_peak = 0.01 )
# # Cut the Measurements to same support - so all fields are defined over the same interval of x-coordinate
# wpy.cut_data_support(b_fields = b_field_data, col_cut = 'x')
# # Save the processed Data to the desired folder
# wpy.save_prepared_b_data(b_fields = b_field_data, folder = b_field_processed_folder)
# # Plot the processed data
# wpy.plot_b_field_data( b_fields = b_field_data )

#******************************************************************************************************
#*****************Load Processed B-Field Data and Plot*************************************************
#******************************************************************************************************

# # Load Processed Field
# b_field_data = wpy.load_b_fields_gap(folder = b_field_processed_folder )
# # Plot the processed data
# wpy.plot_b_field_data( b_fields = b_field_data )

#******************************************************************************************************
#*****************Load Processed B-Field Data, Interpolate, Save and Plot******************************
#******************************************************************************************************

# Load the processed fields
b_field_data = wpy.load_b_fields_gap(folder = b_field_processed_folder )
# Interpolate the fields at some gap
interp_field = wpy.interpolate_b_data(b_fields = b_field_data, gap = 18.45, lim_peak = 0.01)
# Add list of fields together for plotting
b_field_data = b_field_data + interp_field
# Save the newly interpolated field to the appropriate folder
wpy.save_prepared_b_data(b_fields = interp_field, folder = b_field_interp_folder)
# Plot specific fields from the field-list
wpy.plot_b_field_data( b_fields = b_field_data, gaps_plt = [15,18.45,20])

