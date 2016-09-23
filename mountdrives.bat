:: We need to loop through all of the data, but only gather that which is neccessary.
for /f "tokens=1 delims=" %%a in (%TMP%\ad_secgroups.txt) do (
	set secGroup=%%a
	:: If the policy exists folder then load it.
	IF EXIST !accessPath!\!secGroup!.txt (
		:: If no policy is found, display a message.
		set foundPoints=true
		echo.
		echo   --  Policies found for !secGroup!:

		:: Because there may be multiple policies, this needs to loop through them and mount all.
		for /f "tokens=1 delims=" %%b in (!accessPath!\!secGroup!.txt) do (
			set rawText=%%b

			:: Split each line (tab delimited) into DRIVE LETTER (tab) PATH and assign variables.
			for /F "tokens=1,2,3 delims=	" %%c in ("!rawText!") do (
				set driveLetter=%%c
				set mountPoint=%%d
				set mountLabel=%%e
			)
			set mountPoint=!mountPoint:ReservedLogonUser=%USERNAME%!
			set mountLabel=!mountLabel:ReservedLogonUser=%USERNAME%!
			echo.
			echo         --  Mounting !driveLetter! drive to !mountPoint!...
			:: Mount it, redirect all output to an external file so we can process it to make it pretty.
			NET USE !driveLetter!: !mountPoint! 1> %TMP%\netuse.txt 2>&1

			IF NOT "!mountLabel!" == "" (
				:: Use powershell to rename the drive
				powershell -ExecutionPolicy RemoteSigned -File "!accessPath!\RenameDrive.ps1" "!driveLetter!" "!mountLabel!"
				echo Renamed !driveLetter!:\ to "!mountLabel!".>> %TMP%\netuse.txt
			)
			for /f "delims=" %%x in (%TMP%\netuse.txt) do echo         --  %%x
			del %TMP%\netuse.txt
		)
	) ELSE (
		:: Ignore bootstrapp text, and empty lines, and add the rest to a temporary fail file.
		echo !secGroup!>> %TMP%\ad_failgroup.txt
	)
)
