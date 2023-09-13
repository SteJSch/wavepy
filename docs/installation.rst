Installation
*************

Install WavePy
-----------------
Wavepy will works on Linux, macOS and Windows.


* You will need Python 3.9 or newer. From a shell ("Terminal" on OSX), 
  check your current Python version.

  .. code-block:: bash

    python3 --version

  If that version is less than 3.9, you must update it.

  We recommend installing wavepy into a "virtual environment" so that this
  installation will not interfere with any existing Python software:

  .. code-block:: bash

    python3 -m venv ~/wavepy-tutorial
    source ~/wavepy-tutorial/bin/activate

  Alternatively, if you are a
  `conda <https://conda.io/docs/user-guide/install/download.html>`_ user,
  you can create a conda environment:

  .. code-block:: bash

    conda create -n wavepy-tutorial "python>=3.9"
    conda activate wavepy-tutorial


  .. code-block:: bash

     python3 -m pip install --upgrade wavepy 

Troubleshooting
----------------

Wave can not be Executed
~~~~~~~~~~~~~~~~~~~~~~~~~~
Make sure that :code:`wavepy/WAVE/bin/wave.exe` is executable.

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
