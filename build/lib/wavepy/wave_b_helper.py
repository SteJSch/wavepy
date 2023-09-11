"""
Contains the functionality for loading and processing b-field data
"""
from .wavepy_incl import *
import wavepy.file_folder_helpers as f_h

def load_b_fields_gap(folder, hints = []) : 
	"""
	Load field files from "folder" containing files with fields for different gaps
	The file format should be two rows, the first one 'x' in [mm], the second one 'By' [T]
	The file-name format should be: file_name_front + 'gap_' + str(gap) + '_' + file_name_back + '.' + file_ending
	Returns list of dictionaries: { 'gap' : gap,'data' : pd.DataFrame(data), 'file_name' : file_name }, where data is a panda dataframe with rows
	"x" and "By"
	"""
	data_ret = []
	files = f_h.find_files_exptn(folder = folder, hints = hints, exptns = [])
	for file in files :

		gap_str = file.split( 'gap_' )
		if len(gap_str) > 1 : 
			gap = float(gap_str[-1].split('_')[0])
			data = pd.read_csv( folder+file, dtype=object, delim_whitespace=True, header = None )
			data.columns = [ "x", "By" ]
			for col in data.columns:
				data[col] = data[col].astype(float)
			data_ret.append( { 'file_name' : file, 'gap' : gap, 'data' : data } )
	sorted_data = pd.DataFrame(data_ret).sort_values('gap')
	data_ret = sorted_data.to_dict('records')
	return data_ret

def checkIfList_Conv(data) : 
	"""
	Takes a data object which can be either list of dics or dataframe and converts
	it to a list
	"""
	isList = True
	if not isinstance(data,list) : 
		isList = False
		data_in = data.to_dict('records')   
		return [ isList, data_in ]
	else :
		return [ isList, data ]

def checkIfDF_Conv(data) : 
	"""
	Takes a data object which can be either list of dics or dataframe and converts
	it to a dataframe
	"""
	isDF = True
	if not isinstance(data,pd.DataFrame) : 
		isDF = False
		return [ isDF, pd.DataFrame(data) ]
	else :
		return [ isDF, data ]

def find_maxima(data, lim, colx = 0, coly = 1) : 
	"""
	finds maxima in data whose value is at least |val| >= lim
	data is supposed to be a list of dictionaries or a panda dataframe 
	colx and coly give the column index of the x and y data
	returns a list containing 2 lists: one with x-coordinates and one 
	with y-coordinates of the maxima positions
	"""
	[isDF, data_in] = checkIfDF_Conv(data = data)
	xCol = data_in[ data_in.columns[colx] ].to_list()
	yCol = data_in[ data_in.columns[coly] ].to_list()
	peaks, properties = find_peaks( x = yCol )

	pltY = [ yCol[ind] for ind in peaks if abs(yCol[ind]) >= lim ]
	pltX = [ xCol[ind] for ind in peaks if abs(yCol[ind]) >= lim ]
	df_Res = pd.DataFrame(
	{'x': pltX,
	 'y': pltY
	})	
	df_Res = df_Res.sort_values(by=['x'])
	return [ df_Res[ df_Res.columns[0] ].to_list(), df_Res[ df_Res.columns[1] ].to_list() ]

def find_minima(data, lim, colx = 0, coly = 1) : 
	"""
	finds minima in data whose value is at least |val| >= lim (lim>=0!)
	data is supposed to be a list of dictionaries or a panda dataframe 
	colx and coly give the column index of the x and y data
	returns a list containing 2 lists: one with x-coordinates and one 
	with y-coordinates of the minima positions
	"""
	[isDF, data_in] = checkIfDF_Conv(data = data)

	xCol = data_in[ data_in.columns[colx] ].to_list()
	yCol = data_in[ data_in.columns[coly] ].to_list()

	min_yCol = [ -elem for elem in yCol ]

	Lowpeaks, properties = find_peaks( x = min_yCol )

	m_pltY = [ -min_yCol[ind] for ind in Lowpeaks if abs(min_yCol[ind]) >= lim ]
	m_pltX = [ xCol[ind] for ind in Lowpeaks if abs(min_yCol[ind]) >= lim ]

	df_Res = pd.DataFrame(
	{'x': m_pltX,
	 'y': m_pltY
	})
	df_Res = df_Res.sort_values(by=['x'])
	return [ df_Res[ df_Res.columns[0] ].to_list(), df_Res[ df_Res.columns[1] ].to_list() ]

def find_extrema(data, lim, colx = 0, coly = 1) : 
	"""
	finds extrema in data whose value is at least |val| >= lim
	data is supposed to be a list of dictionaries or a panda dataframe 
	colx and coly give the column index of the x and y data
	returns a list containing 2 lists: one with x-coordinates and one 
	with y-coordinates of the extremal positions
	"""
	[maximaX, maximaY ] = find_maxima(data = data, lim = lim, colx = colx, coly = coly)
	[minimaX, minimaY ] = find_minima(data = data, lim = lim, colx = colx, coly = coly)

	df_Res = pd.DataFrame(
	{'x': maximaX+minimaX,
	 'y': maximaY+minimaY
	})
	df_Res = df_Res.sort_values(by=['x'])
	return [ df_Res[ df_Res.columns[0] ].to_list(), df_Res[ df_Res.columns[1] ].to_list() ]

def gauge_b_field_data(b_fields, col, gauge_fac) : 
	"""
	takes a list of b-fields as returned by load_b_fields_gap and col, the name of the 
	data column of the data objects to gauge and the number gauge_fac
	each element in the column col is then multiplied by gauge_fac
	"""
	for field in b_fields:
		field['data'][col] = field['data'][col].apply( lambda x: x*gauge_fac )

def center_b_field_data(b_fields, lim_peak) : 
	"""
	takes b-field data list loaded with load_b_fields_gap and centers each field 
	according to the position of the first and last peak identified for which |peak| >= lim_peak
	"""
	for field in b_fields:
		field.update( { 'data' : center_data(data = field['data'], strat = { 'name' : 'peak', 'lim' : lim_peak } , colx = 0, coly = 1) } )

def convert_x_mm_b_T_file_to_wave_std( folder_in, file_in, out_path ) : 
	"""
	Loads a file in folder_in called file_in with two cols: x[mm] and B[T] - no header to separator
	and converts, depending on b_type, to wave std and copies to out_path (path+filename)
	"""
	data = pd.read_csv( folder_in+file_in, dtype=object, header = None, delim_whitespace=True )
	data.columns = [ "x", "B" ]
	for col in data.columns:
		data[col] = data[col].astype(float)

	data['x'] = data['x'].apply( lambda x : x*1e-3 )
	data.to_csv(out_path,index=False, header = None, sep = ' ')

	lines = []
	with open(out_path, 'r') as o_f:
		# read an store all lines into list
		lines = o_f.readlines()
	lines.insert(0,str(len(data))+'\n')
	lines.insert(0,'1.0 1.0\n')
	lines.insert(0,'Comment\n')
	with open( out_path, 'w') as o_f:
		for ind, line in enumerate(lines) :
			o_f.write(line)

def plot_b_field_data( b_fields, gaps_plt = [] ) :
	fig = plt.figure(figsize=(13*cm_inch, 6.5*cm_inch), dpi=150)
	for b_field in b_fields :
		plt_it = True
		if len(gaps_plt) > 0 :
			plt_it = False
			for gap in gaps_plt : 
				if b_field['gap'] == gap :
					plt_it = True
					break
		if plt_it :
			data = b_field['data']
			plt.plot(data['x'],data['By'], '-', label = 'Gap='+str(b_field['gap']))
			fig.suptitle("Magnetic Field", fontsize=14)
			plt.xlabel('x [m]', fontsize=12),
			plt.ylabel('Magnetic Field [T]', fontsize=12)
	ax = plt.gca()
	ax.legend(loc='best', bbox_to_anchor=(0.8, 0.5, 0.0, 0.0))	
	plt.pause(0.25)
	#plt.ion()
	plt.show()

def cut_data_support(b_fields, col_cut = 'x') : 
	"""
	takes b-field data list loaded with load_b_fields_gap and
	cuts the fields to the smallest common support in the column
	col_cut - afterwards all fiel-data is defined on the same col-values
	"""
	b_field_x_small = None
	b_field_x_high = None
	for field in b_fields :
		data = field['data']
		x_vals = data[col_cut].to_list()
		if b_field_x_high is None :
			b_field_x_high = x_vals[-1]
		else : 
			if x_vals[-1] < b_field_x_high : 
				b_field_x_high = x_vals[-1]
		if b_field_x_small is None :
			b_field_x_small = x_vals[0]
		else : 
			if x_vals[0] > b_field_x_small : 
				b_field_x_small = x_vals[0]

	for field in b_fields : 
		field['data'] = field['data'][ (field['data'][col_cut] >= b_field_x_small) & \
					(field['data'][col_cut] <= b_field_x_high) ]
	return [ b_field_x_small, b_field_x_high]

def center_data(data, strat, colx = 0, coly = 1) : 
	"""
	takes data - which is list of dics of dataframe - and centers it according to strategy in strat
	possible strat vals:
	{ 'name' : 'peak', 'lim' : lim } - determines peaks of |val|>=lim and first and last one are centered
	colx/y are the number of the x and y columns
	"""
	xCen = 0.0
	if strat['name'] == 'peak' : 
		lim = strat['lim']
		[x, y] = find_extrema(data = data, lim = lim, colx = colx, coly = coly)
		if ( len(x) < 2 ) or ( len(y) < 2 ) :
			print("No or not enough (2) peaks found - abort")
			return
		xCen = (x[-1] + x[0])/2
	[isDF, data_DF] = checkIfDF_Conv(data = data)
	data_DF[ data_DF.columns[0] ] = data_DF[ data_DF.columns[0] ].apply( lambda x : x - xCen )
	# print("Center at: ",xCen)
	if not isDF : 
		return data_DF.to_dict('records')   
	return data_DF

def save_prepared_b_data(b_fields, folder, name_add = '') :
	"""
	takes b-field data list loaded with load_b_fields_gap, a folder and a string name_add 
	and saves all b-field data into the folder, the files are named according ot the 
	file_name propertie in the b_fields dictionaries with name_add added to the file names
	"""
	for data in b_fields :
		filename = data['file_name']
		filename_split = filename.split('.')
		filename_ending = filename_split[-1]
		file_name_no_ending = filename.replace( filename_ending,'' )
		filename = file_name_no_ending + name_add + filename_ending
		data['data'].to_csv(folder+filename,index=False, header = None, sep = ' ')

def interpolate_b_data(b_fields, gap, lim_peak, num_support_per_extrema = 20) :
	"""
	interpolates b-field data for a given gap using already present dataframes for different gaps
	takes b-field data list loaded with load_b_fields_gap, a gap number, the lim_peak value 
	used for findind the extrema in the data (for determination of the number of periods)
	and the number of support positions per extrema for the calculation of splines from the data
	Returns a list containing a dictionary: { 'gap' : gap,'data' : pd.DataFrame(data), 'file_name' : file_name }, where data is a panda dataframe 
	containing the interpolated data and file_name contains the value of the gap at which this data is determined
	"""
	[x_min, x_max] = cut_data_support(b_fields = b_fields, col_cut = 'x')

	num_ex = []
	for field in b_fields : 
		[ex_x, ex_y] = find_extrema(data = field['data'], lim = lim_peak, colx = 0, coly = 1)
		num_ex.append( len(ex_x) )
	max_num_ex = max(num_ex)
	num_supports = max_num_ex * num_support_per_extrema
	support_x = np.linspace( x_min, x_max, num=num_supports)
	interp_data = []
	for field in b_fields : 
		x_vals = field['data']['x'].to_list()
		y_vals = field['data']['By'].to_list()
		spline = CubicSpline(x_vals, y_vals)
		spline_supp_vals = spline( support_x )
		interp_data.append( { 'gap' : field['gap'], 'spline' : spline, 'supp_vals' : spline_supp_vals } )

	supp_list = []
	for ind, supp in enumerate(support_x) :
		supp_list.append( { 'ind' : ind, 'x' : supp, 'gB' : [] } )
		for interp in interp_data : 
			supp_list[-1]['gB'].append( { 'gap' : interp['gap'], 'Bg' : interp['supp_vals'][ind] } )

	num_gaps = len(b_fields)
	num_gaps_spline = num_gaps * 10
	for supp in supp_list : 
		g_data = pd.DataFrame(supp['gB'])
		g_vals = g_data['gap'].to_list()
		b_vals = g_data['Bg'].to_list()
		g_spline = CubicSpline(g_vals, b_vals)
		supp.update( { 'g_spline' : g_spline } )

	data_for_g = []
	for supp in supp_list : 
		data_for_g.append( { 'x' : supp['x'], 'By' : supp['g_spline'](gap) } )
	data_for_g = pd.DataFrame(data_for_g)
	g_spline = CubicSpline( support_x, data_for_g['By'] )

	return [{ 'file_name' : 'interp_b_field_gap_'+str(gap)+'_.dat', 'gap' : gap, 'data' : data_for_g }]