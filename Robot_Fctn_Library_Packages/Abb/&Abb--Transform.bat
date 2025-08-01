@echo off
chcp 65001
rem @mode con lines=55 cols=100
color 7
cd %~dp0
set OutPath=%~dp0\Output
if not exist "%OutPath%" md %OutPath%
echo.
del/s /q %~dp0\Output\*.sys
for %%i in (*.sys) do (
    echo.加密 %%i
    c:\encode\encode %%i %~dp0\Output\%%~ni.sys

)
echo.
echo.加密完成
echo.路径: %OutPath%
pause
exit


