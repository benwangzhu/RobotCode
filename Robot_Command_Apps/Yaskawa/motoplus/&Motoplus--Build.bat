rem ************************************************************************************
set LibPath=E:\Users\speedbot\Desktop\Robot_Code\Robot_Fctn_Library_Packages\Yaskawa
rem ************************************************************************************
@echo off
chcp 65001
set OUT_NAME=SpeedbotRobot
set DX200_INSTALL_DIR=D:\motoplusIDE\dx200
set YRC1000_INSTALL_DIR=D:\motoplusIDE\yrc1000
rem ***********************************************
cd %~dp0
set DX200_OUTPUT_DIR=%cd%\output_DX200
set YRC1000_OUTPUT_DIR=%cd%\output_YRC1000

Setlocal enabledelayedexpansion
set WIND_BASE=C:\
color 7
cd %~dp0
if "%cd%"=="%LibPath%" goto 2

if not exist "lib" mkdir lib

echo.		
echo.Whether to Update the Library
echo.1 : Y
echo.2 : N
echo.
set /p HearKey=Please Enter:	
if not "%HearKey%"=="1" goto 1
	
for /r "%LibPath%" %%a in (*.c) do copy /y %%a %~dp0\lib
echo.
echo.
for /r "%LibPath%" %%a in (*.c) do echo.        Successfully Copied %%~nxa

for /r "%LibPath%" %%a in (*.h) do copy /y %%a %~dp0\lib
echo.
echo.
for /r "%LibPath%" %%a in (*.h) do echo.        Successfully Copied %%~nxa

:1
if not exist "!DX200_OUTPUT_DIR!" mkdir !DX200_OUTPUT_DIR!
if not exist "!YRC1000_OUTPUT_DIR!" mkdir !YRC1000_OUTPUT_DIR!

del/s /q !DX200_OUTPUT_DIR!\*.a
del/s /q !DX200_OUTPUT_DIR!\*.d
del/s /q !DX200_OUTPUT_DIR!\*.out
del/s /q !YRC1000_OUTPUT_DIR!\*.a
del/s /q !YRC1000_OUTPUT_DIR!\*.d
del/s /q !YRC1000_OUTPUT_DIR!\*.out

set FILE_LIST_DX200=
set FILE_LIST_YRC1000=

set "HEADER_FILE=lib\operating_environment.h"
set "TEMP_FILE=%HEADER_FILE%.tmp"
set "SEARCH_TEXT=#define CONTROL_VER"
set "SEARCH_TEXT_DEBUG=#define DEBUG_PRINT"

chcp 936 >nul 
:: Prompt the user for input
echo.
echo.
echo.
echo.
echo.
echo Please select the version to set:
echo 1. YRC1000
echo 2. DX200
echo 3. YRC1000_DEBUG
echo 4. DX200_DEBUG
echo 5. Other (will prompt an error)
set /p user_input=Enter a number (1, 2, 3, or 4): 

if "%user_input%"=="1" (
    set "REPLACE_TEXT=#define CONTROL_VER YRC1000"
    set "REPLACE_TEXT_DEBUG=#define DEBUG_PRINT OFF"
    set OUT_NAME=SpeedbotRobot
) else if "%user_input%"=="2" (
    set "REPLACE_TEXT=#define CONTROL_VER DX200"
    set "REPLACE_TEXT_DEBUG=#define DEBUG_PRINT OFF"
    set OUT_NAME=SpeedbotRobot
) else if "%user_input%"=="3" (
    set "REPLACE_TEXT=#define CONTROL_VER YRC1000"
    set "REPLACE_TEXT_DEBUG=#define DEBUG_PRINT ON"
    set OUT_NAME=SpeedbotRobot_DEBUG
) else if "%user_input%"=="4" (
    set "REPLACE_TEXT=#define CONTROL_VER DX200"
    set "REPLACE_TEXT_DEBUG=#define DEBUG_PRINT ON"
    set OUT_NAME=SpeedbotRobot_DEBUG
) else (
    echo [ERROR] Invalid input, please enter 1 or 2.
    pause
    exit /b
)

if not exist "%HEADER_FILE%" (
    echo [ERROR] File %HEADER_FILE% does not exist. Please check the path.
    pause
    exit /b
)


> "%TEMP_FILE%" (
    for /f "usebackq delims=" %%i in ("%HEADER_FILE%") do (
        set "line=%%i"
        if "!line!" neq "" (
            if "!line:%SEARCH_TEXT%=!" neq "!line!" (
                echo !REPLACE_TEXT!
            ) else if "!line:%SEARCH_TEXT_DEBUG%=!" neq "!line!" (
                echo !REPLACE_TEXT_DEBUG!    
            ) else (
                set "temp_line=!line!"
                echo.!temp_line!
            )
        ) else (
            echo.
        )
    )
)

if not exist "%TEMP_FILE%" (
    echo [ERROR] Temporary file %TEMP_FILE% creation failed.
    pause
    exit /b
) else (
    move /y "%TEMP_FILE%" "%HEADER_FILE%" >nul
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to replace %HEADER_FILE% with %TEMP_FILE%.
        pause
        exit /b
    ) else (
        echo [INFO] Successfully replaced %HEADER_FILE% with %TEMP_FILE%.
    )
)

:2
:: Compile files in the lib directory
if exist "lib" (
    pushd lib
    for %%i in (*.c) do (
        echo. Compiling lib\%%i
        
        "!DX200_INSTALL_DIR!\mpbuilder\gnu\4.3.3-vxworks-6.9\x86-win32\bin\ccpentium.exe" -march=atom -nostdlib -fno-builtin -fno-defer-pop -fno-implicit-fp -fno-zero-initialized-in-bss -Wall -Werror-implicit-function-declaration -g -MD -MP -DCPU=_VX_ATOM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_WRS_KERNEL -I"%cd%" -I"!DX200_INSTALL_DIR!\mpbuilder\inc" -c "%%~i" -o "!DX200_OUTPUT_DIR!\%%~ni.a"
        "!YRC1000_INSTALL_DIR!\mpbuilder\gnu\4.3.3-vxworks-6.9\x86-win32\bin\ccpentium.exe" -march=atom -nostdlib -fno-builtin -fno-defer-pop -fno-implicit-fp -fno-zero-initialized-in-bss -Wall -Werror-implicit-function-declaration -g -MD -MP -DCPU=_VX_ATOM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_WRS_KERNEL -I"%cd%" -I"!YRC1000_INSTALL_DIR!\mpbuilder\inc" -c "%%~i" -o "!YRC1000_OUTPUT_DIR!\%%~ni.a"
        
        set FILE_LIST_DX200=!FILE_LIST_DX200! "!DX200_OUTPUT_DIR!\%%~ni.a"
        set FILE_LIST_YRC1000=!FILE_LIST_YRC1000! "!YRC1000_OUTPUT_DIR!\%%~ni.a"
    )
    popd
)

:: Compile files in the current directory
for %%i in (*.c) do (
    echo. Compiling %%i
    
    "!DX200_INSTALL_DIR!\mpbuilder\gnu\4.3.3-vxworks-6.9\x86-win32\bin\ccpentium.exe" -march=atom -nostdlib -fno-builtin -fno-defer-pop -fno-implicit-fp -fno-zero-initialized-in-bss -Wall -Werror-implicit-function-declaration -g -MD -MP -DCPU=_VX_ATOM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_WRS_KERNEL -I"%cd%" -I"!DX200_INSTALL_DIR!\mpbuilder\inc" -c "%cd%\%%~i" -o "!DX200_OUTPUT_DIR!\%%~ni.a"
    "!YRC1000_INSTALL_DIR!\mpbuilder\gnu\4.3.3-vxworks-6.9\x86-win32\bin\ccpentium.exe" -march=atom -nostdlib -fno-builtin -fno-defer-pop -fno-implicit-fp -fno-zero-initialized-in-bss -Wall -Werror-implicit-function-declaration -g -MD -MP -DCPU=_VX_ATOM -DTOOL_FAMILY=gnu -DTOOL=gnu -D_WRS_KERNEL -I"%cd%" -I"!YRC1000_INSTALL_DIR!\mpbuilder\inc" -c "%cd%\%%~i" -o "!YRC1000_OUTPUT_DIR!\%%~ni.a"
    
    set FILE_LIST_DX200=!FILE_LIST_DX200! "!DX200_OUTPUT_DIR!\%%~ni.a"
    set FILE_LIST_YRC1000=!FILE_LIST_YRC1000! "!YRC1000_OUTPUT_DIR!\%%~ni.a"
)

if exist "mpMain.c" (

echo. Building !OUT_NAME!.out
call "!DX200_INSTALL_DIR!\mpbuilder\gnu\4.3.3-vxworks-6.9\x86-win32\bin\ccpentium.exe" -nostdlib -r -WI,-X -WI !FILE_LIST_DX200! -o "!DX200_OUTPUT_DIR!\!OUT_NAME!.out"
call "!YRC1000_INSTALL_DIR!\mpbuilder\gnu\4.3.3-vxworks-6.9\x86-win32\bin\ccpentium.exe" -nostdlib -r -WI,-X -WI !FILE_LIST_YRC1000! -o "!YRC1000_OUTPUT_DIR!\!OUT_NAME!.out"
)
echo. Build successful
pause