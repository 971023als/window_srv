@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-001] SNMP 서비스 Get Community 스트링 설정 오류 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: SNMP Community 스트링이 복잡하고 예측 불가능하게 설정된 경우 >> "!TMP1!"
echo [취약]: SNMP Community 스트링이 기본값이거나 예측 가능하게 설정된 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: SNMP 서비스 실행 중인지 확인
sc queryex SNMP | find /i "RUNNING" > nul
if errorlevel 1 (
    echo SNMP 서비스가 실행 중이지 않습니다. >> "!TMP1!"
) else (
    :: SNMP 설정 확인 (PowerShell을 사용하여 레지스트리 검사)
    powershell -Command "$snmpRegPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities'; $snmpCommunities = Get-ItemProperty -Path $snmpRegPath; if ($snmpCommunities -eq $null) { echo 'SNMP Community 스트링 설정을 찾을 수 없습니다.' >> '!TMP1!' } else { foreach ($community in $snmpCommunities.PSObject.Properties) { if ($community.Name -eq 'public' -or $community.Name -eq 'private') { echo '취약: 기본 SNMP Community 스트링($community.Name)이 사용되고 있습니다.' >> '!TMP1!' break } else { echo '양호: 기본 SNMP Community 스트링이 사용되지 않습니다.' >> '!TMP1!' break } } }"
)

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"
echo.
