@echo off
:: Check if the script has administrative privileges and try to elevate if not
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    chcp 949 > nul
    echo 관리자 권한이 필요합니다...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%getadmin.vbs"
"%getadmin.vbs"
del "%getadmin.vbs"
exit /B

:gotAdmin
:: Set the console code page to 949 for Korean characters to display correctly
chcp 949
color 02
setlocal enabledelayedexpansion
echo ------------------------------------------Setting---------------------------------------
:: Remove and recreate directories for storing raw and result data
rd /S /Q "C:\Window_%COMPUTERNAME%_raw"
rd /S /Q "C:\Window_%COMPUTERNAME%_result"
mkdir "C:\Window_%COMPUTERNAME%_raw"
mkdir "C:\Window_%COMPUTERNAME%_result"

:: Export local security policies and collect system information
secedit /EXPORT /CFG "C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt"
fsutil file createnew "C:\Window_%COMPUTERNAME%_raw\compare.txt" 0
cd >> "C:\Window_%COMPUTERNAME%_raw\install_path.txt"
systeminfo >> "C:\Window_%COMPUTERNAME%_raw\systeminfo.txt"

:: Collect and process IIS configuration
echo ------------------------------------------IIS Setting-----------------------------------
type "%WinDir%\System32\Inetsrv\Config\applicationHost.Config" >> "C:\Window_%COMPUTERNAME%_raw\iis_setting.txt"
... [Further processing of IIS configuration] ...

:: Instructions and checks for SNMP Community String settings
echo ------------------------------------------SRV-001------------------------------------------
... [SNMP Community String settings and checks] ...

:: Check SMTP service status and log it
echo --------------------------------------SRV-004 필요한 SMTP 서비스 상태 확인 ------------------------------------- >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt"
sc query smtp >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt"
echo ------------------------------------------------------------------------------- >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt"
