import os
import sys

# Get the directory path of the currently executing script
current_script_path = os.path.abspath(__file__)
directory_path = os.path.dirname(current_script_path)

# Add the directory containing the 'wavepy' directory to the Python path
wp_directory = os.path.abspath(os.path.join(directory_path, '..'))
sys.path.insert(0, wp_directory)

import unittest
from wavepy.wave import WaveFromB 
from wavepy.standard_parameters import StdParameters


class TestWaveFromB(unittest.TestCase):

    def setUp(self):
        # Create an instance of wave_from_b for testing
        self.wave_instance = WaveFromB()

    def test_get_paras(self):
        # Test the get_paras method
        paras = self.wave_instance.get_paras()
        self.assertIsNotNone(paras)  # Check if paras is not None

    def test_set_paras(self):
        # Test the set_paras method
        new_paras = StdParameters()  # You might need to adjust this based on your code
        self.wave_instance.set_paras(new_paras)
        self.assertEqual(self.wave_instance.get_paras(), new_paras)

    def test_run_wave_without_field_folder(self):
        # Test running wave without setting field_folder
        with self.assertRaises(Exception):
            self.wave_instance.run_wave()



if __name__ == '__main__':
    unittest.main()
