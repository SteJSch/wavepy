import os
import wavepy.wave_b_helper as wpy_b
from .standard_parameters import StdParameters


class PreprocessWaveFiles():
    """_summary_

        Args:
            wave_paras (StdParameters): Standard Parameters used for the simulation
    """ 
    def __init__(self, wave_paras:StdParameters):
               
        self.wave_paras = wave_paras

    def create_wave_input(self):
        """Creates all the files needed as input fro Wave.
        
        Loads the input file set in wave_paras, updates properties 
        based on other wave_paras properties,and copies the 
        resulting file to the WAVE program folder.
        """

        wave_folder   = self.wave_paras.wave_prog_folder.get()
        b_type        = self.wave_paras.b_type.get()
        configFile_in = self.wave_paras.in_files.get()[b_type]
        # open the configuration file
        wave_in_file = []
        with open(configFile_in, 'r') as o_f:
            # read an store all lines into list
            wave_in_file = o_f.readlines()

        for ind, line in enumerate(wave_in_file) :
            if line.find('FREQLOW=') >= 0 :
                stuff1 = line.split("FREQLOW=")
                stuff2 = stuff1[-1].split('!')
                wave_in_file[ind] = stuff1[0]+'FREQLOW='+str(self.wave_paras.freq_low.get())+' !' + stuff2[-1]            
            if line.find('FREQHIG=') >= 0 :
                stuff1 = line.split("FREQHIG=")
                stuff2 = stuff1[-1].split('!')
                wave_in_file[ind] = stuff1[0]+'FREQHIG='+str(self.wave_paras.freq_high.get())+' !' + stuff2[-1]            
            if line.find('NINTFREQ=') >= 0 :
                stuff1 = line.split("NINTFREQ=")
                stuff2 = stuff1[-1].split('!')
                wave_in_file[ind] = stuff1[0]+'NINTFREQ='+str(self.wave_paras.freq_num.get())+' !' + stuff2[-1]            
            if line.find('DMYENERGY=') >= 0 :
                stuff1 = line.split("DMYENERGY=")
                stuff2 = stuff1[-1].split('!')
                wave_in_file[ind] = stuff1[0]+'DMYENERGY='+str(self.wave_paras.beam_en.get())+' !' + stuff2[-1]            
            if line.find('DMYCUR=') >= 0 :
                stuff1 = line.split("DMYCUR=")
                stuff2 = stuff1[-1].split('!')
                wave_in_file[ind] = stuff1[0]+'DMYCUR='+str(self.wave_paras.current.get())+' !' + stuff2[-1]            
            if line.find('MPINZ=') >= 0 :
                stuff1 = line.split("MPINZ=")
                stuff2 = stuff1[-1].split('!')
                wave_in_file[ind] = stuff1[0]+'MPINZ='+str(self.wave_paras.pinh_nz.get())+' !' + stuff2[-1]            
            if line.find('MPINY=') >= 0 :
                stuff1 = line.split("MPINY=")
                stuff2 = stuff1[-1].split('!')
                wave_in_file[ind] = stuff1[0]+'MPINY='+str(self.wave_paras.pinh_ny.get())+' !' + stuff2[-1]            
            if line.find('PINCEN(1)=') >= 0 :
                stuff1 = line.split("PINCEN(1)=")
                stuff2 = stuff1[-1].split('!')
                wave_in_file[ind] = stuff1[0]+'PINCEN(1)='+str(self.wave_paras.pinh_x.get())+' !' + stuff2[-1]            
            if line.find('PINW=') >= 0 :
                stuff1 = line.split("PINW=")
                stuff2 = stuff1[-1].split('!')
                wave_in_file[ind] = stuff1[0]+'PINW='+str(self.wave_paras.pinh_w.get()*1e-3)+' !' + stuff2[-1]            
            if line.find('PINH=') >= 0 :
                stuff1 = line.split("PINH=")
                stuff2 = stuff1[-1].split('!')
                wave_in_file[ind] = stuff1[0]+'PINH='+str(self.wave_paras.pinh_h.get()*1e-3)+' !' + stuff2[-1]            
            if line.find('ISPEC=') >= 0 :
                stuff1 = line.split("ISPEC=")
                stuff2 = stuff1[-1].split('!')
                wave_in_file[ind] = stuff1[0]+'ISPEC='+str(self.wave_paras.spec_calc.get())+' !' + stuff2[-1]            

        with open( wave_folder + 'stage/wave.in', 'w') as o_f:
            for ind, line in enumerate(wave_in_file) :
                o_f.write(line)
        
    def prepare_b_files_for_wave(self):
        """Prepare the files for WAVE depending on the b type.
            
        Deoending on which b_type, copies and 
        formats the b-field files needed
        """
        b_type = self.wave_paras.b_type.get()
        wave_folder = self.wave_paras.wave_prog_folder.get()
        field_files = self.wave_paras.field_files.get()
        field_folder = self.wave_paras.field_folder.get()
        # except for Bxyz, By is first field file
        y_pos = 0
        if (b_type == 'Byz') or (b_type == 'Bxyz') : 
            # last file is Bz
            field_file = field_files[-1]
            wpy_b.convert_x_mm_b_T_file_to_wave_std( folder_in = field_folder, file_in = field_file, out_path = wave_folder + 'stage/bz.dat' )
            if b_type == 'Bxyz' :
                # snd file is By
                y_pos = 1
                # first file is Bx
                field_file = field_files[0]
                wpy_b.convert_x_mm_b_T_file_to_wave_std( folder_in = field_folder, file_in = field_file, out_path = wave_folder + 'stage/bx.dat' )
            field_file = field_files[y_pos]
            wpy_b.convert_x_mm_b_T_file_to_wave_std( folder_in = field_folder, file_in = field_file, out_path = wave_folder + 'stage/btab.dat' )
        else :
            # first file is By
            field_file = field_files[0]
            field_file = field_file.replace("(", "\(")
            field_file = field_file.replace(")", "\)")    
            os.system( 'cp ' + field_folder + field_file + ' ' + wave_folder + 'stage/' )
            os.system( 'mv ' + wave_folder + 'stage/' + field_file + ' ' + wave_folder + 'stage/btab.dat' )

