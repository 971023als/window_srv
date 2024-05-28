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
set "code=SRV-002"
set "riskLevel=상"
set "diagnosisItem=SNMP Set Community 스트링 검사"
set "diagnosisResult="
set "status="

:: SNMP 서비스 실행 중인지 확인
sc queryex SNMP | find /i "RUNNING" >nul
if errorlevel 1 (
    set "diagnosisResult=서비스 비활성화"
    set "status=검사 불가"
    echo "양호: SNMP 서비스가 실행 중이지 않습니다."
) else (
    :: SNMP 설정 확인 (PowerShell을 사용하여 레지스트리 검사)
    powershell -Command "& {
        $snmpRegPathSet = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities';
        $snmpCommunitiesSet = Get-ItemProperty -Path $snmpRegPathSet;
        if ($snmpCommunitiesSet -eq $null) {
            $diagnosisResult = 'SNMP Set Community 스트링 설정을 찾을 수 없습니다.';
            $status = '검사 불가';
        } else {
            $isVulnerableSet = $false;
            foreach ($community in $snmpCommunitiesSet.PSObject.Properties) {
                if ($community.Value -eq 4) {
                    $diagnosisResult = '취약: SNMP Set Community 스트링(' + $community.Name + ')이 기본값 또는 예측 가능한 값으로 설정되어 있습니다.';
                    $isVulnerableSet = $true;
                    break;
                }
            }
            if (-not $isVulnerableSet) {
                $diagnosisResult = '양호: SNMP Set Community 스트링이 기본값 또는 예측 가능한 값으로 설정되지 않았습니다.';
            }
            $status = '진단 완료';
        }
        \"$diagnosisResult, $status\" | Out-File -FilePath temp.txt;
    }"
    set /p result=<temp.txt
    set "diagnosisResult=%result%,"
    del temp.txt
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!diagnosisResult!","!status!","!responsePlan!" >> "!csvFile!"

REM Display the CSV content
type "!csvFile!"
echo

endlocal
