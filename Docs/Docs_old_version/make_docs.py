import os, wget, zipfile, re, os.path, pdb
import textwrap

# all the folders which are scanned for files
folders_include = ['../', '../../']
# file extension for which files are searched
file_ext = [ '.py' ]
# list specifying the exact files to lead to documentation - if empty, then all files in foldes with a matching extension are loaded
# to explicitly load all files in folder, write entry: '*'
files_include = []

out_file = 'Docs.tex'

#*************************************************************************************************************
#*************************************************************************************************************
#*************************************************************************************************************

# loop all directories given and collect files that match
files_to_load = []
dirPaths = []
for ind, dir in enumerate(folders_include) :
    for file in os.listdir(dir):
        if len(file_ext) > 0 :
            for ext in file_ext :
                indFind = file.find(ext)
                # if given file extention there - then load
                # and at end of string
                if ( indFind >= 0 ) and ( len(file[indFind:]) == len(ext) ) :
                    files_to_load.append( dir+'/'+file )
                    break
        else :
            files_to_load.append( file )

# open latex file and get content
out_file_lines_tmp = []
with open(out_file, 'r') as o_f:
    # read an store all lines into list
    out_file_lines_tmp = o_f.readlines()

# find part where we delete content (between begin of section documentation and dobib or end file )
start_del = -1
end_del = -1

ind_doc_begin = -1
do_bib_line = -1
end_line = -1
for ind, line in enumerate(out_file_lines_tmp) :
    # if section doc found : start delete there
    if line.find('\chapter{Documentation}') >= 0 :
        ind_doc_begin = ind
    # if dobib found, start there (dont delete anything)
    elif line.find('\dobib') >= 0 :
        do_bib_line = ind
    # else, start before end landscape
    elif line.find('\end{landscape}') >= 0 :
        end_line = ind
# if the documentation start is there, we set delete index
if ( ind_doc_begin >= 0 ) :
    start_del = ind_doc_begin
# else start delete before bib
elif do_bib_line >= 0 :
    start_del = do_bib_line
# or delete before end document
else:
    start_del = end_line
# set end of delete, until bib or until end
if do_bib_line >= 0 :
    end_del = do_bib_line - 1
else:
    end_del = end_line - 1
# indices to delete
ind_del = [*range(start_del,end_del+1)]
# copy the content of the latex file, minus the stuff to delete
out_file_lines = []
for ind, line in enumerate(out_file_lines_tmp) :
    if not ind in ind_del :
        out_file_lines.append( line )

# define function that replaces specil characters with latex-friendly versions
def replace_latex(in_str) :
    out_str = in_str
    out_str = out_str.replace('_','\\_')
    out_str = out_str.replace('^',' to the ')
    out_str = out_str.replace('>','$>$')
    return out_str

# gets the comments from a given place in code
def get_comments(data, ind) :
    comments = []
    if ( data[ind+1].find('"""') >= 0 ) or ( data[ind+1].find('\'\'\'') >= 0 ) :
        ind = ind + 1
        while True :
            ind = ind + 1
            if  not ( data[ind].find('"""') >= 0 ) and not ( data[ind].find('\'\'\'') >= 0 ) :
                line = data[ind][0:]
                line = line.replace('\t','')
                line = line.replace('\n','')
                comments.append( replace_latex(line + '\n') )
            else : 
                break
    return comments

# add the lines to the latex file, starting and indInsert
indInsert = start_del
# lines to be inserted
insertLines = []
# begin by section documentation
insertLines.append( '\chapter{Documentation}\n' )
for file in files_to_load :
    file_lines = []
    # for each file, we add a subsection with file-name
    file_name = replace_latex('\\subsection{'+file.split('/')[-1]+'}\n')
    insertLines.append( file_name )
    first_Func = True
    with open(file, 'r') as o_f:
        # read an store all lines into list
        file_lines = o_f.readlines()
        file_begin = True
        for ind_line, line in enumerate(file_lines) :
            line = line.strip()
            line = line.replace("\t","")
            if  file_begin and ( ( line.find('"""') >= 0 ) or ( line.find('\'\'\'') >= 0 )) :
                comm = get_comments(data = file_lines, ind = ind_line - 1)
                insertLines.extend( comm )
            file_begin = False
            l_split = line.split(' ')
            firstWord = l_split[0]
            # find function and class definitions
            if (firstWord == 'def') or (firstWord == 'class') :
                if first_Func :
                    # add itemize if this first function/class in this file
                    insertLines.append( '\\begin{itemize}\n' )
                    first_Func = False
                insertLines.append( '\\item \\begin{verbatim}\n' )
                name = (line).strip()
                name_list = textwrap.wrap( name, 80 )
                # add function name into verbatim environment
                for elem in name_list :
                    elem = elem + '\n'
                    insertLines.append( elem )
                insertLines.append( '\\end{verbatim}\n' )
                # add the comments in plain-text format
                comm = get_comments(data = file_lines, ind = ind_line )
                insertLines.extend( comm )
    # finish the itemization if some definition found inside file
    if not first_Func :
        insertLines.append( '\\end{itemize}\n' )

# add the documentation to the latex file and write
out_file_lines[indInsert:indInsert] = insertLines
with open(out_file, 'w') as o_f:
    for ind, line in enumerate(out_file_lines) :
        o_f.write(line)
