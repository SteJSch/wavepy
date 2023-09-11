How To Use WavePy
*******************

Axis Nomenclature
------------------
Flight direction of the electron is :code:`x` . 
The vertical direction (in planer undulators) is called 
:code:`y` and the horizontal is :code:`z` 
.

Spectrum Calculations
----------------------
Import wavepy and create a wave instance 

.. code:: python

  from wavepy import WaveFromB
  wave = WaveFromB('By')

WAVE can perform many different tasks, one of which is calculating a 
spectrum from a given B-field. This specific functionality is so far 
covered in wavepy. You can calculate the spectra from a magnetic field 
in Bydirection only by using :code:`By`, from By and Bz data 
by setting :code:`Byz` and from all components by writing 
:code:`Bxyz`. All field data should be in the format of two cols, 
the first one containing :code:`x` in mm and the second B in Tesla, 
no separators and header lines.
Next you can get standard wave parameters by writing:

.. code:: python

  # Get Wave-parameter
  paras = wave.get_paras()
  # Customize Parameters
  paras.field_folder.set('..../Fields/Interpolated/') # Field Folder
  paras.field_files.set( [ 'interp_b_field_gap_18.45_.dat'] ) # The magnetic field file(s) to be used in the simulation
  paras.res_folder.set('..../Spectrum_Results/First_Simu/')   # where to store simulations results
  paras.spec_calc.set(1)    # calculate spectrum? if not, only trajectory is calculated
  paras.freq_low.set(100)   # lower frequency for spectrum calc. [eV]
  paras.freq_high.set(105)  # upper frequency for spectrum calc. [eV]
  paras.freq_num.set(5)     # number of frequencies for spectrum calc. [eV]
  paras.pinh_w.set(3)       # pinhole width (horizontal-z) [mm]
  paras.pinh_h.set(3)       # pinhole height (vertical-y) [mm]
  paras.pinh_x.set(10) 	    # pinhole distance in beam direction (x) [m]
  paras.pinh_nz.set(21)	    # number of horizontal points in pinhole for spec. calc.
  paras.pinh_ny.set(21)     # number of vetical points in pinhole for spec. calc.
  paras.wave_res_copy_behaviour.set('copy_essentials') #'copy_all'

Paras is a :code:`StdParamenter` object. Then set the parameters and run wave:

.. code:: python

  # Set Parameters
  wave.set_paras(paras)
  # Run WAVE
  wave.run_wave()


Summary file
~~~~~~~~~~~~~~~~~~~~~~
WavePy then saves all the data that is set to b e saved into 
the designated folder and zips all data for storage. 
On plotting the data is unzipped and zipped again. 
Furthermore, a fiel :code:`res_summary.txt` is stored
inside the zip archive. This file contains some general 
information extracted from wave about the current simulation, 
including:

.. code:: python

  bmax [T] : max. b field
  bmin [T] : min. b field
  first_int [Tm] : first ingegral
  scnd_int [Tmm] : second integral
  power [kW] : total emitted power
  pinhole_x [m] : dist. of pinhole from undulator centre
  Fund. Freq. [eV] : fundamental frequency
  Undu_Para : undulator parameter K
  gamma : well, you guessed it
  half_opening_angle [rad] : the half-opening angle
  cone_radius_at_x [mm] : the cone-radius at the position
  of the pinhole (tan(half_opening_angle)*pinhole_x)

B-Field Interpolation
--------------------------
Keep in mind that WAVE exp ects the magnetic field data over mm.
You can load files containing magnetic field data for different gaps by
writing:

.. code:: python

  b_field_data = wpy.load_b_fields_gap(folder)

The file name format should be :code:`somename + gap_x_ + restname +.ending`. 
E.g. :code:`myfile_g_23_.dat`. With the gap given in mm. 
To plot the b-field data:

.. code:: python
  
  wpy.plot_b_field_data( b_fields = b_field_data )

You can center the data and cut all loaded magnetic fields to 
the defined on the same interval by writing:

.. code:: python
  
  wpy.center_b_field_data( b_fields = b_field_data, lim_peak = 0.01 )
  wpy.cut_data_support(b_fields = b_field_data, col_cut = 'x')

The centering is done by identifying the first and last 
peaks and centering those. The option :code:`lim_peak`
gives the minimal height a p eak has to have to be identified as a 
peak - this is necessary to account for noise in the data.
Save the pro cessed fields by writing:

.. code:: python

  wpy.save_prepared_b_data(b_fields = b_field_data, folder = folder)

Next we can interpolate the data by writing:

.. code:: python
  
  interp_field = wpy.interpolate_b_data(b_fields = b_field_data, gap = gap, lim_peak = 0.01)

Where :code:`gap`` is the gap at which you'd like to interpolate.

Troubleshooting
----------------

Files are not copied after the simulations runned
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Does the result folder exist? If not, create it.

Interpolated files are not saved
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Does the folder where they should be saved exist? If not, create it.

WAVE is complaining about: NEGATIVE OR ZERO PHOTON EN-
ERGY OCCURED WHILE EXTENDING ENERGY 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Increase the number of energy points - parameter :code:`freq_num`. 
Wave is extending the energy range you specified in order to calculate 
the folding procedure and may, with too little points on which to 
calculate, run into negative energies. This is especially important at 
low energy values.

Wave complains it cannot find a zip file while trying to plot
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Were the results files not prop erly stored before? 
Check if the data folder contains more than a zip file and 
delete everything but the zip file.
