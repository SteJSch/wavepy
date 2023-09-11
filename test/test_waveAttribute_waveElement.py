import os
import sys

# Get the directory path of the currently executing script
current_script_path = os.path.abspath(__file__)
directory_path = os.path.dirname(current_script_path)

# Add the directory containing the 'src' directory to the Python path
wp_directory = os.path.abspath(os.path.join(directory_path, '..', 'src'))
sys.path.insert(0, wp_directory)

import unittest

from wavepy.wave_elements import WaveAttribute, WaveElement


class TestWaveAttribute(unittest.TestCase):
    def setUp(self):
        self.attribute = WaveAttribute(value=42, name="test_attribute")

    def test_initial_value(self):
        self.assertEqual(self.attribute.get(), 42)

    def test_set_value(self):
        self.attribute.set(25)
        self.assertEqual(self.attribute.get(), 25)

    def test_name(self):
        self.assertEqual(self.attribute.name, "test_attribute")

class TestWaveElement(unittest.TestCase):
    class TestElement(WaveElement):
        attr = WaveAttribute(value=10)

    def setUp(self):
        self.element = self.TestElement()

    def test_children(self):
        children = list(self.element.children())
        self.assertEqual(len(children), 1)
        self.assertIsInstance(children[0], WaveAttribute)
        self.assertEqual(children[0].get(), 10)

if __name__ == '__main__':
    unittest.main()
