"""
Contains functionality for handling files.

Module to handle various file operations including finding, moving, copying, and deleting files.
"""

from wavepy.wavepy_incl import *
import os
import shutil
from pathlib import Path

def find_files_exptn(folder, hints=[], exptns=[]):
    """
    Find files in the specified folder based on hints and exptns.

    Args:
        folder (str): The folder in which to search for files.
        hints (list, optional): List of strings to search for in filenames. Default is [].
        exptns (list, optional): List of strings to exclude from filenames. Default is [].

    Returns:
        list: List of filenames matching the criteria.
    """
    files = []
    for filename in os.listdir(folder):
        copy_f = False
        if len(hints) > 0:
            for hint in hints:
                if filename.find(hint) >= 0:
                    copy_f = True
                    break
        else:
            copy_f = True
        if copy_f:
            nope = False
            f = os.path.join(folder, filename)
            if os.path.isfile(f):
                for exptn in exptns:
                    if filename.find(exptn) >= 0:
                        nope = True
                        break
            if not nope:
                filename_rpl = filename.replace("(", "\(")
                filename_rpl = filename_rpl.replace(")", "\)")
                files.append(filename_rpl)
    return files

def find_all_files_exptn(folder, exptns=[]):
    """
    Find all files in a directory while excluding specified patterns.

    Args:
        folder (str): The folder in which to search for files.
        exptns (list, optional): List of strings to exclude from filenames. Default is [].

    Returns:
        list: List of filenames matching the criteria.
    """
    files = []
    for filename in os.listdir(folder):
        nope = False
        f = os.path.join(folder, filename)
        if os.path.isfile(f):
            for exptn in exptns:
                if filename.find(exptn) >= 0:
                    nope = True
                    break
        if not nope:
            filename_rpl = filename.replace("(", "\(")
            filename_rpl = filename_rpl.replace(")", "\)")
            files.append(filename_rpl)
    return files

def zip_files_in_folder(folder_to_pack):
    """
    Zip all files in a specified folder.

    Zips all files in the specified folder, names the zip as the folder name,
    moves the resulting zip to the same directory, and deletes all other files in the directory.

    Args:
        folder_to_pack (str): The folder containing files to be zipped.
    """
    folder_name = folder_to_pack.split('/')[-2]

    my_file = Path(folder_to_pack + folder_name + '.zip')
    if my_file.is_file():
        os.system('rm ' + folder_to_pack + folder_name + '.zip')

    shutil.make_archive(folder_name, 'zip', folder_to_pack)
    os.system('mv ' + folder_name + '.zip ' + folder_to_pack + folder_name + '.zip')
    del_all_files(exptns=[folder_name + '.zip'], folder=folder_to_pack)

def unzip_zip_in_folder(folder):
    """
    Unzip a zip file in the specified folder.

    Looks for a zip file in the specified folder, unzips it there,
    and returns the list of extracted zip files.

    Args:
        folder (str): The folder in which to search for and extract zip files.

    Returns:
        list: List of extracted zip filenames.
    """
    zip_files = find_files_exptn(folder=folder, hints='.zip', exptns=[])
    if len(zip_files) > 0:
        zip_file = folder + zip_files[-1]
        shutil.unpack_archive(zip_file, folder)
    return zip_files

def mv_cp_files(hints, exptns, folder_in, folder_out, move=True, add_string=''):
    """
    Move or copy files between folders based on specified criteria.

    Moves or copies files whose name contains a string from hints,
    excluding those whose name contains a string from the exptns list,
    from folder_in to folder_out and appends add_string to the name.

    Args:
        hints (list): List of strings to search for in filenames.
        exptns (list): List of strings to exclude from filenames.
        folder_in (str): The source folder.
        folder_out (str): The destination folder.
        move (bool, optional): Whether to move (True) or copy (False) files. Default is True.
        add_string (str, optional): String to append to the filenames. Default is ''.

    Returns:
        list: List of names of the moved or copied files (with add_string appended).
    """
    files_load = find_files_exptn(folder=folder_in, hints=hints, exptns=exptns)
    mvd_names = []
    for file_load in files_load:
        file_splt = file_load.split('.')
        if len(file_splt) > 1:
            end_f = '.' + file_splt[-1]
            file_front = ''
            for el in file_splt[0:-1]:
                file_front = file_front + el
        else:
            file_front = file_load
            end_f = ''
        new_file_name = file_front + add_string + end_f
        mvd_names.append(new_file_name)
        if move:
            os.system('mv ' + folder_in + file_load + ' ' + folder_out + new_file_name)
        else:
            os.system('cp ' + folder_in + file_load + ' ' + folder_out + new_file_name)
    return mvd_names

def del_files(hints, exptns, folder):
    """
    Delete files from a specified folder based on specified criteria.

    Deletes files whose name contains a string from hints,
    excluding those whose name contains a string from the exptns list,
    from the specified folder.

    Args:
        hints (list): List of strings to search for in filenames.
        exptns (list): List of strings to exclude from filenames.
        folder (str): The folder from which to delete files.

    Returns:
        list: List of names of the deleted files.
    """
    files_del = find_files_exptn(folder=folder, hints=hints, exptns=exptns)
    del_names = []
    for file_del in files_del:
        del_names.append(file_del)
        os.system('rm ' + folder + file_del)
    return del_names

def del_all_files(exptns, folder):
    """
    Delete all files from a specified folder.

    Deletes all files in the specified folder, excluding those whose name
    contains a string from the exptns list.

    Args:
        exptns (list): List of strings to exclude from filenames.
        folder (str): The folder from which to delete files.

    Returns:
        list: List of names of the deleted files.
    """
    files_del = find_all_files_exptn(folder=folder, exptns=exptns)
    del_names = []
    for file_del in files_del:
        del_names.append(file_del)
        os.system('rm ' + folder + file_del)
    return del_names
