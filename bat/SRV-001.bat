@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for SNMP analysis
set "csvFile=!resultDir!\SNMP_Analysis.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status,Response Plan" > "!csvFile!"

REM Define security details
set "category=보안관리"
set "code=SRV-001"
set "riskLevel=상"
set "diagnosisItem=SNMP Community 스트링 검사"
set "diagnosisResult="
set "status="

:: SNMP 서비스 실행 중인지 확인
sc queryex SNMP | find /i "RUNNING" > nul
if errorlevel 1 (
    set "diagnosisResult=서비스 비활성화"
    set "status=검사 불가"
    echo "양호: SNMP 서비스가 실행 중이지 않습니다."
) else (
    :: SNMP 설정 확인 (PowerShell을 사용하여 레지스트리 검사)
    powershell -Command "$snmpRegPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities'; $snmpCommunities = Get-ItemProperty -Path $snmpRegPath; if ($snmpCommunities -eq $null) { $result = 'SNMP Community 스트링 설정을 찾을 수 없습니다.' } else { foreach ($community in $snmpCommunities.PSObject.Properties) { if ($community.Name -eq 'public' -or $community.Name -eq 'private') { $result = '취약: 기본 SNMP Community 스트링(' + $community.Name + ')이 사용되고 있습니다.'; break } else { $result = '양호: 기본 SNMP Community 스트링이 사용되지 않습니다.'; break } } } $result" > "!tmpResultFile!"
    set /p diagnosisResult=<"!tmpResultFile!"
    set "status=진단 완료"
    del "!tmpResultFile!"
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!diagnosisResult!","!status!","!responsePlan!" >> "!csvFile!"

REM Display the CSV content
type "!csvFile!"
echo

endlocal
