:: --------------------
:: Reconnect the wlan connection
:: uses config.ini file
:: --------------------
@echo off
setlocal enabledelayedexpansion
goto begin

:begin
for %%I in (item value section found) do set %%I=
Set "inifile=config.ini"
Set "section=WLAN_CONFIG"
Set "item=WLAN_NAME"

if not defined section (
    if not defined value (
        for /f "usebackq tokens=2 delims==" %%I in (`findstr /i "^%item%\=" "%inifile%"`) do (
            echo(%%I
        )
    ) else (
        for /f "usebackq delims=" %%I in (`findstr /n "^" "%inifile%"`) do (
            set "line=%%I" && set "line=!line:*:=!"
            echo(!line! | findstr /i "^%item%\=" >NUL && (
                1>>"%inifile%.1" echo(%item%=%value%
                echo(%value%
            ) || 1>>"%inifile%.1" echo(!line!
        )
    )
) else (
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
					goto reconnect
                    exit /b 0
                )
            )
        ) else (
            if defined value (1>>"%inifile%.1" echo(!line!)
            echo(!line! | find /i "[%section%]" >NUL && set found=1
        )
    )
)

:reconnect
netsh wlan disconnect
netsh wlan connect name=%var%

if exist "%inifile%.1" move /y "%inifile%.1" "%inifile%">NUL

::ENABLE THE INTERFACE
::netsh interface set interface name="Имя сетевого интерфейса" admin=enable //включение



