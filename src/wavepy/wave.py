"""
Contains the wave_from_b class that incorporates the API from python to WAVE and the function create_wave_instance that 
returns an instance of that class
"""
from .wavepy_incl import *
import wavepy.file_folder_helpers as f_h
import wavepy.wave_b_helper as wpy_b
import wavepy.physical_constants as pc
from .standard_parameters import StdParameters
from .wave_API import WaveAPI
from .preprocess_wave_files import PreprocessWaveFiles
from .postprocess_wave_files import PostprocessWaveFiles
from .standard_parameters import StdParameters

class WaveFromB() : 
	"""
	WAVE class to perform spectrum calculations from b-field data files

	Initiates WAVE class object with self.std WAVE parameters
	b_type sets which b-fields are loaded from file: 'y': By,
	'yz' By and Bz, 'xyz' ... . Each B-field from different file

	Args:
			b_type (str, optional): Field. possible values: By, Byz, Bxyz. Defaults to 'By'.
	"""

	def __init__(self, b_type = 'By') :
		self.std = StdParameters()
		self.std.get_std_paras(b_type = b_type)


	def get_paras(self) : 
		"""
		Returns current parameters
		"""
		return self.std

	def set_paras(self,wave_paras:StdParameters):
		"""Sets new parameters

		Args:
			wave_paras (StdParameters): Standard Parameters
		"""		 
		self.std = wave_paras

	def run_wave(self) : 
		"""
		Runs wave and postprocess the results
		"""
		if len(self.std.field_folder.get()) < 1 :
			raise Exception('field_folder needs to be set in wave_paras')
		if len(self.std.field_files.get()) < 1 :
			raise Exception('field_files needs to be set in wave_paras')
		if len(self.std.res_folder.get()) < 1 :
			raise Exception('res_folder needs to be set in wave_paras')

		preproc = PreprocessWaveFiles(self.std)
		preproc.create_wave_input()
		preproc.prepare_b_files_for_wave()

		wave_folder = self.std.wave_prog_folder.get()
		script_folder = os.getcwd()
		w = WaveAPI(wave_folder, current_folder=script_folder)
		w.run()

		postproc = PostprocessWaveFiles(self.std)
		postproc.edit_wave_results()
		postproc.cleanup(wave_folder)



