@echo off
setlocal enabledelayedexpansion

:: Prompt the user for the IP address
echo Please enter the IP address of the Telnet server:
set /p TARGET=

@echo off
echo set sh=WScript.CreateObject("WScript.Shell") >telnet_tmp.vbs
echo WScript.Sleep 300 >>telnet_tmp.vbs
echo sh.SendKeys "open !TARGET!" >>telnet_tmp.vbs
echo WScript.Sleep 300 >>telnet_tmp.vbs
echo sh.SendKeys "{ENTER}" >>telnet_tmp.vbs
echo WScript.Sleep 300 >>telnet_tmp.vbs
echo sh.SendKeys "MOTOMANrobot{ENTER}" >>telnet_tmp.vbs
echo WScript.Sleep 300 >>telnet_tmp.vbs
echo sh.SendKeys "MOTOMANrobot{ENTER}" >>telnet_tmp.vbs
echo WScript.Sleep 300 >>telnet_tmp.vbs
start telnet
cscript //nologo telnet_tmp.vbs
del telnet_tmp.vbs