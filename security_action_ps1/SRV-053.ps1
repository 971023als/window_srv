@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    chcp 949 > nul
    echo 관리자 권한이 필요합니다. 스크립트를 다시 실행해 주세요...
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
echo ------------------------------------------환경 설정 중---------------------------------------
rd /S /Q C:\Window_%COMPUTERNAME%_raw
rd /S /Q C:\Window_%COMPUTERNAME%_result
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result
secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt > nul
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt 0 > nul
cd > C:\Window_%COMPUTERNAME%_raw\install_path.txt
systeminfo > C:\Window_%COMPUTERNAME%_raw\systeminfo.txt

echo ------------------------------------------IIS 설정 정보 수집 중-----------------------------------
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config > C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | findstr "physicalPath bindingInformation" > C:\Window_%COMPUTERNAME%_raw\iis_path1.txt
set "line="
for /F "delims=" %%a in ('type C:\Window_%COMPUTERNAME%_raw\iis_path1.txt') do (
    set "line=!line!%%a" 
)
echo !line! > C:\Window_%COMPUTERNAME%_raw\line.txt
:: 이하 경로 추출 반복 작업
type C:\WINDOWS\system32\inetsrv\MetaBase.xml > C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
echo ------------------------------------------작업 완료-------------------------------------------

:: SNMP 설정 점검 로직 (자세한 내용 및 구현 필요)
echo ------------------------------------------SNMP Community String 점검------------------------------------------

:: SNMP 점검 구현 예시

echo -------------------------------------------점검 완료------------------------------------------

:: SMTP 서비스 상태 확인
echo --------------------------------------SMTP 서비스 상태 확인 중------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo -------------------------------------------------------------------------------- >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo 모든 작업이 완료되었습니다.
