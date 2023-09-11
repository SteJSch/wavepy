import os

class WaveAPI():
    """API for the WAVE program

    Args:
        current_folder (str): _description_
        wave_folder (str): _description_
    """  
    def __init__(self, wave_folder:str, current_folder:str= False):
      
        self.current_folder = current_folder
        self.wave_folder    = wave_folder
        
    def run(self):
        """Run Wave from the self.wave_folder.

        If given, change the directory back to self.current_folder
        """        
        os.chdir(self.wave_folder + 'stage/' )
        os.system("." + "/../bin/wave.exe")
        if self.current_folder:
            os.chdir(self.current_folder )