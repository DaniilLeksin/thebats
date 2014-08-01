@echo off
SetLocal EnableExtensions EnableDelayedExpansion

goto folder

:find
for %%I in (value section found) do set %%I=
set "inifile=config.ini"
set "section=SCRIPT_CONFIG"

for /f "usebackq delims=" %%I in (`findstr /n "^" "%inifile%"`) do (
	set "line=%%I" && set "line=!line:*:=!"
	if defined found (
		if defined value (
			echo(!line! | findstr /i "^%item%\=" >NUL && (
				1>>"%inifile%.1" echo(%item%=%value%
				echo(%value%
				set found=
			) || 1>>"%inifile%.1" echo(!line!
		) else echo(!line! | findstr /i "^%item%\=" >NUL && (
			for /f "tokens=2 delims==" %%x in ("!line!") do (
				set var=%%x
				if %item% equ folder (	
					goto extension
				)
				if %item% equ extension (
					goto permanent
				)
				if %item% equ permanent (
					goto interval
				)
				if %item% equ interval (
					set interval=%%x
					echo Initial settings:
					echo ===============================
					echo Work path: %Folder%
					echo File extension: %ext%
					echo How many files to leave : %permanent%
					echo Watch interval: %interval%
					echo ===============================
					set /a interval+=1
					pause
					goto begin
				)
			)
		)
	) else (
		if defined value (1>>"%inifile%.1" echo(!line!)
		echo(!line! | find /i "[%section%]" >NUL && set found=1
	)
)

:folder
set "item=folder"
goto find

:extension
set Folder=%var%
Set "item=extension"
goto find

:permanent
set ext=%var%
set "item=permanent"
goto find

:interval
set permanent=%var%
set "item=interval"
goto find

:begin
echo %time% Command: delete *.%ext% files from %Folder% ...

set Count=0
For /F "delims=" %%a in ('dir /b /a-d /O-N "%Folder%\*.%ext%"') do set /a Count+=1& if !count! GTR %permanent% del /F /A "%Folder%\%%a"
>NUL ping 127.1 -n %interval%
goto begin