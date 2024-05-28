@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한이 필요합니다...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "getadmin.vbs"
    "getadmin.vbs"
    del "getadmin.vbs"
    exit /B

:gotAdmin
chcp 949
color 02
setlocal enabledelayedexpansion
echo ------------------------------------------Setting---------------------------------------
rd /S /Q C:\Window_%COMPUTERNAME%_raw
rd /S /Q C:\Window_%COMPUTERNAME%_result
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result
del C:\Window_%COMPUTERNAME%_result\W-Window-*.txt
secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt  0
cd >> C:\Window_%COMPUTERNAME%_raw\install_path.txt
for /f "tokens=2 delims=:" %%y in ('type C:\Window_%COMPUTERNAME%_raw\install_path.txt') do set install_path=c:%%y
systeminfo >> C:\Window_%COMPUTERNAME%_raw\systeminfo.txt
echo ------------------------------------------IIS Setting-----------------------------------
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | findstr "physicalPath bindingInformation" >> C:\Window_%COMPUTERNAME%_raw\iis_path1.txt
set "line="
for /F "delims=" %%a in ('type C:\Window_%COMPUTERNAME%_raw\iis_path1.txt') do (
set "line=!line!%%a"
)
echo !line!>>C:\Window_%COMPUTERNAME%_raw\line.txt
for /F "tokens=1 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
    echo %%a >> C:\Window_%COMPUTERNAME%_raw\path1.txt
)
for /F "tokens=2 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
    echo %%a >> C:\Window_%COMPUTERNAME%_raw\path2.txt
)
for /F "tokens=3 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
    echo %%a >> C:\Window_%COMPUTERNAME%_raw\path3.txt
)
for /F "tokens=4 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
    echo %%a >> C:\Window_%COMPUTERNAME%_raw\path4.txt
)
for /F "tokens=5 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
    echo %%a >> C:\Window_%COMPUTERNAME%_raw\path5.txt
)
type C:\WINDOWS\system32\inetsrv\MetaBase.xml >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
echo ------------------------------------------end-------------------------------------------
echo ------------------------------------------SRV-001------------------------------------------
echo SRV-001 (Windows) SNMP Community 설정값 보안 점검
echo 
echo 점검 배경 설명
echo SNMP 서비스는 네트워크 관리 및 네트워크 위치의 정보를 수집/관리하는 SNMP 관리 스테이션으로, SNMP 메시지 및 상태 정보를 교환하기 위한 SNMP community string의 보안성을 강화하기 위해 설정값을 점검합니다.
echo 
echo 점검 대상 및 방법
echo - 조건 : SNMP Community String 기본 값(Public, Private)이 아니며, 아래의 보안성을 만족하는 경우
echo - 결과 : SNMP Community String 기본 값(Public, Private)이거나, 보안성을 만족하지 않는 경우
echo 
echo (보안성) 기본값(public, private) 이외, 알파벳, 숫자, 특수문자가 혼합된 10자리 이상 혹은 알파벳, 숫자만으로 구성된 8자리 이상
echo SNMP v3의 경우 보안 강화를 위해 해당 암호화를 사용하는 것을 "권장"
echo 
echo 점검 결과 해석
  1. SNMP 서비스 및 SNMP Community String의 보안성을 점검하시오.
      예 <registry_path> : HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities
      해당 레지스트리 경로에서 SNMP 서비스가 활성화된 경우 해당 서비스를 사용하여 "권장"
echo 
  대응 Windows 2008, 2008 R2, 2012, 2012 R2, 2016, 2019, 2022
      예 시작 > 실행 > services.msc > 속성 > SNMP Service 속성 > "보안" 탭 >
      "수신하는 커뮤니티 이름"  "> SNMP community string" 항목
  또는
      cmd > reg query <registry_path>
          <SNMP_community_string>     REG_DWORD    0x4
  또는
      cmd > reg query <registry_path>
          ERROR: The system was unable to find the specified registry key or value.
echo 
  "ValidCommunities" Key의 Value 설명
      - 이름 : 
      - 유형 : REG_DWORD
      - 데이터 : 1(읽기), 2(쓰기), 4(생성 삭제) 8(읽기, 쓰기), 16(읽기, 쓰기, 삭제)
echo 
점검 방안 제시
  1. SNMP Community String의 보안성을 강화하는 설정값을 적용하십시오.
      예 암호화된 문자열(알파벳, 숫자 등)을 사용하여 외부로부터의 무단 액세스를 방지하십시오.
      "권장" 설정이 필요한 경우가 아니면 "읽기 전용" 설정을 적용하십시오.
      NMS, 관리자 등의 인증된 SNMP 관리 스테이션을 사용하여 SNMP 서비스를 관리하는 경우 SNMP Manager 및 Agent 간의 통신에 사용되는 Community String을 동일하게 설정하여야 합니다.
  2. SNMP 서비스 활성화
echo -------------------------------------------end------------------------------------------

echo --------------------------------------SRV-004 보안 강화를 위한 SMTP 서비스 점검 ------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
