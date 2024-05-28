@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for SNMP access control analysis
set "csvFile=!resultDir!\SNMP_Access_Control.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=보안관리"
set "code=SRV-003"
set "riskLevel=중"
set "diagnosisItem=SNMP 접근 통제 설정 검사"
set "diagnosisResult="
set "status="

:: SNMP 서비스 실행 중인지 확인
sc queryex SNMP | find /i "RUNNING" >nul
if errorlevel 1 (
    set "diagnosisResult=SNMP 서비스가 실행 중이지 않습니다."
    set "status=검사 불가"
) else (
    :: SNMP 접근 통제 설정 확인 (PowerShell을 사용하여 레지스트리 검사)
    powershell -Command "& {
        $snmpRegPathACL = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers';
        $snmpACLs = Get-ItemProperty -Path $snmpRegPathACL;
        if ($snmpACLs -eq $null) {
            $result = '취약: SNMP 접근 통제 설정이 발견되지 않았습니다.';
        } else {
            $aclCount = 0;
            foreach ($acl in $snmpACLs.PSObject.Properties) {
                if ($acl.Name -ne 'PSPath' -and $acl.Name -ne 'PSParentPath' -and $acl.Name -ne 'PSChildName' -and $acl.Name -ne 'PSDrive' -and $acl.Name -ne 'PSProvider') {
                    $aclCount++;
                }
            }
            if ($aclCount -gt 0) {
                $result = '양호: SNMP 접근 제어가 적절하게 설정되었습니다.';
            } else {
                $result = '취약: SNMP 접근 제어가 설정되지 않았습니다.';
            }
        }
        \"$result\" | Out-File -FilePath temp.txt;
    }"
    set /p diagnosisResult=<temp.txt
    set "status=진단 완료"
    del temp.txt
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!diagnosisResult!","!status!" >> "!csvFile!"

REM Display the CSV content
type "!csvFile!"
echo

endlocal
