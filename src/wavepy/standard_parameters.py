import os
from .wave_elements import WaveAttribute, WaveElement

class StdParameters(WaveElement):
    """
    Represents standard parameters for wave simulations.

    Args:
        b_type (str, optional): Type of the wave element.
    """
    b_type = WaveAttribute('By')
    wave_prog_folder = WaveAttribute('')
    in_file_folder = WaveAttribute('')
    in_files = WaveAttribute({})
    field_folder = WaveAttribute('')
    field_files = WaveAttribute([])
    res_folder = WaveAttribute('')
    wave_data_res_folder = WaveAttribute('')
    pics_folder = WaveAttribute('')
    res_summary_file = WaveAttribute('')
    no_copy = WaveAttribute([])
    wave_ending_extract = WaveAttribute([])
    wave_ending_copy = WaveAttribute([])
    wave_files_essentials = WaveAttribute([])
    wave_res_copy_behaviour = WaveAttribute()
    zip_res_folder = WaveAttribute(1)
    # WAVE-IN PARAMETERS
    freq_low = WaveAttribute(0,wave_in_name='FREQLOW')
    freq_high = WaveAttribute(0,wave_in_name='FREQHIG')
    freq_num = WaveAttribute(0,wave_in_name='NINTFREQ')
    beam_en = WaveAttribute(0,wave_in_name='DMYENERGY')
    current = WaveAttribute(0,wave_in_name='DMYCUR')
    pinh_w = WaveAttribute(0,wave_in_name='PINW',fac=1e-3)
    pinh_h = WaveAttribute(0,wave_in_name='PINH',fac=1e-3)
    spec_calc = WaveAttribute(False,wave_in_name='ISPEC')
    pinh_x = WaveAttribute(0,wave_in_name='PINCEN(1)')
    pinh_nz = WaveAttribute(0,wave_in_name='MPINZ')
    pinh_ny = WaveAttribute(0,wave_in_name='MPINY')

    # Simple Undulator Parameters
    undu_type = WaveAttribute('')

    undu = WaveAttribute(0,wave_in_name='IUNDULATOR')
    wigg = WaveAttribute(0,wave_in_name='IWIGGLER')
    undu_easy = WaveAttribute(0,wave_in_name='KHALBA') # magnetic structure without specific ends
    undu_endp = WaveAttribute(0,wave_in_name='KHALBASY') # magnetic structure with endpoles
    undu_gap = WaveAttribute(0,wave_in_name='KUNDUGAP') # undulator with analytic gap-variation
    undu_ellip = WaveAttribute(0,wave_in_name='KELLIP') # elliptic undulator

    b0y = WaveAttribute(0,wave_in_name='B0ELLIPV') # magn. field strength amplitude in vertical direction
    b0z = WaveAttribute(0,wave_in_name='B0ELLIPH') # magn. field strength amplitude in horizontal direction
    nper = WaveAttribute(0,wave_in_name='PERELLIP') # number of periods
    perl_x = WaveAttribute(0,wave_in_name='XLELLIP') # period length
    ell_shift = WaveAttribute(0.25,wave_in_name='ELLSHFT') # shift between the two magnetic arrays in fractions of one period

    def get_std_paras(self, b_type = 'By'): 
        """
		Returns a object containing WAVE standard parameters updated with standard values

		Args:
			b_type (str): Type of b-calculation. Options: 'By' (only By given), 'Byz', 'Bxyz' (each b-field in different file).
			wave_prog_folder (str): Main folder where wave is stored (ending on '/').
			in_file_folder (str): Folder in which the wave in-files are stored (ending on '/').
			in_files (dict): Dictionary of wave in-files for different b_type situations. Format: {b_type: wave_in_file}.
			field_folder (str): Folder where b-field files are stored.
			field_files (list): List of b-field files. Format: 2 cols - x[mm] and B[T], no separator, no headers.
			res_folder (str): Folder where results are stored (ending on '/').
			wave_data_res_folder (str): Subfolder of res_folder where wave data is stored.
			pics_folder (str): Subfolder of res_folder where pictures are stored.
			res_summary_file (str): Name of the summary file to be written.
			no_copy (list): List of file names not to be copied/moved after simulation from wave stage folder.
			wave_ending_extract (list): List of file endings to move from wave stage folder after simulation.
			wave_ending_copy (list): List of file endings of files to be copied (not moved).
			wave_res_copy_behaviour (str): Behavior for copying wave results: 'copy_all', 'copy_del_none', 'copy_essentials'.
			wave_files_essentials (list): List of essential files when wave_res_copy_behaviour is set to 'copy_essentials'.
			zip_res_folder (bool): Truth value, whether to zip results or not.
			freq_low (float): Lower frequency (energy) of spectrum to calculate [eV].
			freq_high (float): Upper frequency (energy) of spectrum to calculate [eV].
			freq_num (int): Number of frequencies to calculate.
			beam_en (float): Beam energy in [GeV].
			current (float): Current in [A].
			pinh_w (float): Pinhole width (horizontal-z) [mm].
			pinh_h (float): Pinhole height (vertical-y) [mm].
			spec_calc (bool): Truth value, whether to calculate spectrum or only write trajectory.
			pinh_x (float): Position of pinhole along optical axis [m].
			pinh_nz (int): Number of points in pinhole horizontally.
			pinh_ny (int): Number of points in pinhole vertically.
		"""
        
        dir_path = os.path.dirname(os.path.realpath(__file__))
        
        self.b_type.set(b_type)
        self.wave_prog_folder.set(dir_path+'/WAVE/')
        self.in_file_folder.set(dir_path+'/WAVE-In-Files/')
        self.in_files.set({ 'By' : 'load_ext_on_axis_by_ALL_OUT.in', 
			 					'Byz' : 'load_ext_on_axis_byz_ALL_OUT.in', 
								'Bxyz' : 'load_ext_on_axis_bxyz_ALL_OUT.in', 'undu_ellip' : 'wave.in' })
        self.field_folder.set('')
        self.field_files.set([])
        self.res_folder.set('')
        self.wave_data_res_folder.set('WAVE_DATA/')
        self.pics_folder.set('Pics/')
        self.res_summary_file.set('res_summary.txt')
        self.no_copy.set(['WAVE_CODE.DAT', 'undumag_mu_77K.dat', 'undumag_mu_300K.dat',
                                'iron_muinf_sat-2.34.dat', 'Vanadium_Permendur_Radia' ])
        self.wave_ending_extract.set([ 'dat', 'wva', 'wvh', 'out' ])
        self.wave_ending_copy.set([ 'in' ])
        self.wave_files_essentials.set([ 'stokes_dist_emittance_espread', 'trajectory',
                                            'irradiated_power_dist', 'brilliance_3702', 
                                            'photon_flux_(pinhole)_48000',
                                            'selected_s0_e_(folded)_x_1_e_6_180000', 'wave.out'])
        self.wave_res_copy_behaviour.set('copy_all')
        self.zip_res_folder.set(1)
        self.freq_low.set(300) # eV
        self.freq_high.set(500) # eV
        self.freq_num.set(5) # 
        self.beam_en.set(1.722) # [GeV]
        self.current.set(0.1) # [A]
        self.pinh_w.set(3) # [mm]
        self.pinh_h.set(3) # [mm]
        self.spec_calc.set(1) # boolean
        self.pinh_x.set(10) # [m]
        self.pinh_nz.set(21) # 
        self.pinh_ny.set(21) # 

        self.undu.set(0)
        self.wigg.set(0)
        self.undu_easy.set(0)
        self.undu_endp.set(0)
        self.undu_gap.set(0)

        if self.b_type == 'undu_ellip' :
            self.undu_ellip = WaveAttribute(1,wave_in_name='KELLIP')
            self.b0y = WaveAttribute(0.3,wave_in_name='B0ELLIPV')
            self.b0z = WaveAttribute(1.0,wave_in_name='B0ELLIPH')
            self.nper = WaveAttribute(5,wave_in_name='PERELLIP')
            self.perl_x = WaveAttribute(0.02,wave_in_name='XLELLIP')
            self.ell_shift = WaveAttribute(0.25,wave_in_name='ELLSHFT')

        return self

