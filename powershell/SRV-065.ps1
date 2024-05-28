@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject("Shell.Application") > "%getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "getadmin.vbs"
    "getadmin.vbs"
    del "getadmin.vbs"
    exit /B

:gotAdmin
chcp 437
color 02
setlocal enabledelayedexpansion

echo ------------------------------------------Setting up environment---------------------------------------
rd /S /Q C:\Window_%COMPUTERNAME%_raw
rd /S /Q C:\Window_%COMPUTERNAME%_result
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result
del C:\Window_%COMPUTERNAME%_result\W-Window-*.txt

echo Exporting local security policy...
secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt

echo Creating comparison file...
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt 0

echo Capturing installation path...
cd >> C:\Window_%COMPUTERNAME%_raw\install_path.txt

echo Gathering system information...
systeminfo >> C:\Window_%COMPUTERNAME%_raw\systeminfo.txt

echo ------------------------------------------Collecting IIS Settings-----------------------------------
echo Exporting application host configuration...
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt

echo Filtering relevant IIS settings...
type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | findstr "physicalPath bindingInformation" >> C:\Window_%COMPUTERNAME%_raw\iis_path1.txt

echo Consolidating IIS paths...
for /F "delims=" %%a in ('type C:\Window_%COMPUTERNAME%_raw\iis_path1.txt') do (
    set "line=!line!%%a" 
)
echo !line! >> C:\Window_%COMPUTERNAME%_raw\line.txt

echo Decomposing consolidated paths...
for /L %%i in (1,1,5) do (
    for /F "tokens=%%i delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
        echo %%a >> C:\Window_%COMPUTERNAME%_raw\path%%i.txt
    )
)

echo Including MetaBase.xml if available...
type C:\WINDOWS\system32\inetsrv\MetaBase.xml >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt

echo ------------------------------------------End of IIS Settings-------------------------------------------

echo ------------------------------------------Reviewing SNMP and SMTP Settings----------------------------
echo SNMP and SMTP settings need manual review. Placeholder for future implementation.

echo -------------------------------------------Script Execution Complete-----------------------------------
