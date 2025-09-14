rem ************************************************************************************
set IncludePath=E:\Users\speedbot\Desktop\RobotCode\Robot_Fctn_Library_Packages\Fanuc
rem ************************************************************************************
@echo off
chcp 65001
rem @mode con lines=55 cols=100
color 7
set OutPath=%~dp0Output
cd %~dp0
if "%cd%"=="%IncludePath%" goto 1
echo.		
echo.是否更新库头文件
echo.1 更新
echo.2 不更新
echo.
set /p HearKey=请输入:	
if not "%HearKey%"=="1" goto 1
	
for /r "%IncludePath%\include" %%a in (*.kl) do copy /y %%a %~dp0\include
echo.
echo.
for /r "%IncludePath%\include" %%a in (*.kl) do echo.        完成复制 %%~nxa

:1
if not exist "%OutPath%" md %OutPath%
echo.		
echo.选择编译版本号
echo.1 V7.70
echo.2 V8.30
echo.3 V9.10
echo.4 V9.30
echo.5 V9.40
echo.
set /p Input=请输入:
del/s /q %~dp0\Output\*.pc
if "%Input%"=="1" set str="v7.70-1"
if "%Input%"=="2" set str="v8.30-1"
if "%Input%"=="3" set str="v9.10-1"
if "%Input%"=="4" set str="v9.30-1"
if "%Input%"=="5" set str="v9.40-1"

for %%i in (*.kl) do ktrans %%i %~dp0\Output\%%~ni.pc /ver %str%
echo.
echo.
for %%i in (*.kl) do echo.        完成编译 %%i
echo.	输出路径 %OutPath%

del /q %~dp0\*.pc
echo.		
echo.FTP 载入
echo.1 加载
echo.2 不加载
echo.
set /p HearKey=请输入:	
if not "%HearKey%"=="1" goto 2
set /p HearKey=设备Ip :	
Echo open %HearKey% >ftp.up
Echo 
Echo cd md: >>ftp.up
Echo bi >>ftp.up
Echo pr >>ftp.up
Echo mput %OutPath%\*.pc>>ftp.up
Echo bye>>ftp.up
FTP -s:ftp.up
del ftp.up /q
:2
pause
exit


