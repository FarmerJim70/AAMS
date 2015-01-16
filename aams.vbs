' Auto Asteroid Maintenance Script v0.1
' Written By: FarmerJim

' file definitions
logFile = "aams.log"
configFile = "aams.config"
lastrunFile = "aams.tmp"
purgeFile = "aams.purge."

' open log
Set objFSO = CreateObject("Scripting.FileSystemObject")

If objFSO.FileExists(logFile) Then
	Const ForAppending = 8
	Set logStream = objFSO.OpenTextFile(logFile, ForAppending, True) ' File Exists already, open for appending
Else
	Set logStream = objFSO.CreateTextFile(logFile, True) ' No file, create a new one
End If

' read config

logStream.writeline Date & " - " & Time & " -> === RUN INITIATED ==="

If objFSO.FileExists(configFile) Then
	Const ForReading = 1
	Set objConfFile = objFSO.OpenTextFile(configFile, ForReading)
	
		Dim fileLines()
		i = 0
			Do Until objConfFile.AtEndOfStream
				ReDim Preserve fileLines(i)
				fileLines(i) = objConfFile.ReadLine
				i = i + 1
			Loop
		objConfFile.Close
Else
	logStream.writeline Date & " - " & Time & " -> Error, unable to locate aams.config file. Please ensure it resides in the same directory as this script!"
	WScript.Quitf
End If

logStream.writeline Date & " - " & Time & " -> Setting configuration options as follows: "

For Each strLine in fileLines
configValues = Split(strLine, "=")
if configValues(0) = "ASTEROID_FILE_LOCATION" Then
	asteroidFileLocation = configValues(1)
	logStream.writeline Date & " - " & Time & " -> Asteroid Location set to: " & configValues(1)
elseif configValues(0) = "DAY_TO_RUN" Then
	runDay = configValues(1)
	logStream.writeline Date & " - " & Time & " -> Run Day: " & configValues(1)
elseif configValues(0) = "TIME_TO_RUN" Then
	runTime = configValues(1)
	logStream.writeline Date & " - " & Time & " -> Run Time: " & configValues(1)
elseif configValues(0) = "RUN_ONCE_PER_DAY" Then
	runOnce = configValues(1)
	logStream.writeline Date & " - " & Time & " -> Run Once per Day: " & configValues(1)
else
	logStream.writeline Date & " - " & Time & " -> Error, unknown entry found in aams.config. Config Value: " & configValues(0) & " is not supported."
end if
Next

if Trim(Day(Date())) = Trim(runDay) or Trim(runDay) = 0 Then
	
		if Trim(Hour(Time())) = Trim(runTime) or Trim(runTime) = 0 Then
			if runOnce = "FALSE" Then 
			' run once per day is disabled, proceed with purge
				purgeAsteroids(asteroidFileLocation)
			else				
			' run once per day enabled, checking if we've already run
				if objFSO.FileExists(lastrunFile) Then
					Set objRunFile = objFSO.OpenTextFile(lastrunFile, ForReading)
	
					Dim runFileLines()
					i = 0
						Do Until objRunFile.AtEndOfStream
							ReDim Preserve runFileLines(i)
							runFileLines(i) = objRunFile.ReadLine
							WScript.Echo "Last Run Date: " & runFileLines(i)
							i = i + 1
						Loop
					objRunFile.Close
					
					if Trim(runFileLines(0)) = Trim(Date()) Then
						logStream.writeline Date & " - " & Time & " ->  - Warning, already run today. Shutting down."
						WScript.Quit
					else
						logStream.writeline Date & " - " & Time & " ->  - No run detected today, proceeding with purge."
						purgeAsteroids(asteroidFileLocation)
					end if
				else
					logStream.writeline Date & " - " & Time & " ->  - No run detected at all, proceeding with purge."
					purgeAsteroids(asteroidFileLocation)
				end if
			End if
		else
			logStream.writeline Date & " - " & Time & " ->  - Time (hour) doesn't match. Shutting down."
			WScript.Quit
		end if
else
	logStream.writeline Date & " - " & Time & " ->  - Day doesn't match. Shutting down."
	WScript.Quit
end if


Public Function purgeAsteroids (ByVal AsteroidLocation)
	logStream.writeline Date & " - " & Time & " -> Using Asteroid File Location of: " & AsteroidLocation
	logStream.writeline Date & " - " & Time & " -> Purging Asteroids..."
	
	' open purge log

	purgeLogFile = purgeFile & Day(Date()) & MonthName(Month(Date())) & Year(Date())

	logStream.writeline Date & " - " & Time & " -> Creating Purge Log: " & purgeLogFile

	If objFSO.FileExists(purgeLogFile) Then
		Const ForAppending = 8
		Set purgeLog = objFSO.OpenTextFile(purgeLogFile, ForAppending, True) ' File Exists already, open for appending
	Else
		Set purgeLog = objFSO.CreateTextFile(purgeLogFile, True) ' No file, create a new one
	End If
	
	purgeLog.writeline Date & " - " & Time & " -> === STARTING ASTEROID PURGE ==="
	
	x = 0
	Set objDirectory = objFSO.GetFolder(AsteroidLocation)
	For Each file in objDirectory.Files
		purgeLog.writeline Date & " - " & Time & " -> File deleted: " & file.Name
		file.Delete
		x = x + 1
	Next
	
	logStream.writeline Date & " - " & Time & " -> Purged Asteroids: " & x
	
	if objFSO.FileExists(lastrunFile) Then
		logStream.writeline Date & " - " & Time & " -> Deleting previous last run date file."
		objFSO.DeleteFile(lastrunFile)
	end if
	
	logStream.writeline Date & " - " & Time & " -> Creating new last run date file."
	Set lastRun = objFSO.CreateTextFile(lastrunFile, True)
	lastRun.writeline Date
	lastRun.Close
	
	logStream.writeline Date & " - " & Time & " -> All processes completed. Shutting down."
	logStream.Close
	
End Function

' write last run date file
