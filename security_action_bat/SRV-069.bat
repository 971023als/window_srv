@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: Check for admin privileges
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject("Shell.Application") > "%temp%\getadmin.vbs"
    set params = %*:=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
:: Set environment
chcp 437
color 02
setlocal enabledelayedexpansion

:: System Setup
echo ------------------------------------------Setting---------------------------------------
rd /S /Q C:\Window_%COMPUTERNAME%_raw
rd /S /Q C:\Window_%COMPUTERNAME%_result
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result
del /F /Q C:\Window_%COMPUTERNAME%_result\*.txt
secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt >nul
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt 0 >nul
cd > C:\Window_%COMPUTERNAME%_raw\install_path.txt
systeminfo > C:\Window_%COMPUTERNAME%_raw\systeminfo.txt

:: IIS Settings Extraction
echo ------------------------------------------IIS Setting-----------------------------------
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config > C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
findstr "physicalPath bindingInformation" C:\Window_%COMPUTERNAME%_raw\iis_setting.txt > C:\Window_%COMPUTERNAME%_raw\iis_paths.txt

:: SNMP and SMTP Settings Analysis
echo ------------------------------------------SNMP and SMTP Settings------------------------
:: Place SNMP and SMTP configuration checks here

echo All tasks completed successfully.
pause
