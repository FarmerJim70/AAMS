# AAMS

AAMS - Auto Asteroid Maintenance Script v0.1
Written by: FarmerJim

Purpose:

This script is to be used when starting a Dedicated Server for Space Engineers. This will take the settings in the aams.config file and purge the asteroid files so that they can be re-generated.

Files and Usage:

aams.config - Contains 4 lines. Details of each are below.

1. ASTEROID_FILE_LOCATION=<Full path to asteroid files> - Set this to the FULL PATH (ie: c:\SE Server\asteroid files) of the directory that contains your asteroid files.
2. DAY_TO_RUN=0 - Set this to the day you which to run the script (ie: 1 for the first of the month). If you wish to run it every time, set to 0.
3. TIME_TO_RUN=0 - Set this to the time you which to run the script (ie: 4 for 4am). You must use the 24 hour system (ie: 2pm = 14). If you wish to run it every time, set to 0.
4. RUN_ONCE_PER_DAY=FALSE - Set this to TRUE you which to limit the script to only run once per day. FALSE will allow it to run every time.

aams.tmp - Contains 1 line. This has the date which it was last run if you are using the RUN_ONCE_PER_DAY option. Can be removed, will be re-created when the script runs.

aams.vbs - The script. Simple enough :)

aams.bat - Wrapper for the script, nothing more.

aams.readme - The file you are reading now.

aams.log - This contains the log entries for the script. Can be removed, will be re-created when the script runs.
