@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    chcp 949 > nul
    echo 관리자 권한으로 실행해야 합니다...
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
chcp 949
color 02
setlocal enabledelayedexpansion
echo ------------------------------------------설정 중---------------------------------------
rd /S /Q C:\Window_%COMPUTERNAME%_raw
rd /S /Q C:\Window_%COMPUTERNAME%_result
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result
del C:\Window_%COMPUTERNAME%_result\*.txt
secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt >nul
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt  0 >nul
cd > C:\Window_%COMPUTERNAME%_raw\install_path.txt
systeminfo > C:\Window_%COMPUTERNAME%_raw\systeminfo.txt

echo ------------------------------------------IIS 설정-----------------------------------
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config > C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | findstr "physicalPath bindingInformation" > C:\Window_%COMPUTERNAME%_raw\iis_path1.txt
set "line="
for /F "delims=" %%a in ('type C:\Window_%COMPUTERNAME%_raw\iis_path1.txt') do (
set "line=!line!%%a" 
)
echo !line! > C:\Window_%COMPUTERNAME%_raw\line.txt
for /F "tokens=1 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
    echo %%a > C:\Window_%COMPUTERNAME%_raw\path1.txt
)
:: 이하 경로 추출 부분 반복

type C:\WINDOWS\system32\inetsrv\MetaBase.xml > C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
echo ------------------------------------------완료-------------------------------------------

:: SNMP 설정 점검 (예시)
echo ------------------------------------------SRV-001------------------------------------------
echo SNMP Community 문자열 설정 점검
:: SNMP 설정 점검 로직 추가
echo -------------------------------------------완료------------------------------------------

:: SMTP 서비스 상태 점검
echo --------------------------------------SRV-004 SMTP 서비스 상태 점검-------------------------------------
>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt sc query smtp
echo ------------------------------------------------------------------------------- >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

:: 스크립트 종료
echo 스크립트 작업 완료.
