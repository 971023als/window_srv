@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for DNS Recursive Query Audit
set "csvFile=!resultDir!\DNS_Recursive_Query_Audit.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Server Name,Recursion Enabled,Diagnosis Result" > "!csvFile!"

REM Define security details
set "category=DNS 보안"
set "code=SRV-063"
set "riskLevel=중"
set "diagnosisItem=DNS 재귀 쿼리 설정 미흡"
set "diagnosisResult="
set "status="

REM Setup log file
set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-063] DNS 재귀 쿼리 설정 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"
echo [양호]: DNS 서버에서 재귀 쿼리가 안전하게 제한됨 >> "!TMP1!"
echo [취약]: DNS 서버에서 재귀 쿼리가 적절하게 제한되지 않음 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: PowerShell을 사용하여 DNS 재귀 쿼리 설정 확인
echo PowerShell을 통해 DNS 재귀 쿼리 설정을 확인 중입니다: >> "!TMP1!"
powershell -Command "& {
    Import-Module DNSServer;
    $DnsServers = Get-DnsServerRecursion | Select-Object Name, IsRecursionEnabled;
    foreach ($server in $DnsServers) {
        $recursionStatus = if ($server.IsRecursionEnabled -eq $true) {'Enabled'} else {'Disabled'}
        $diagnosisResult = \"$server.Name,$server.IsRecursionEnabled,$recursionStatus\"
        echo \"!category!\",\"!code!\",\"!riskLevel!\",\"!diagnosisItem!\",\"$server.Name\",\"$recursionStatus\",\"$diagnosisResult\" >> \"!csvFile!\"
        if ($server.IsRecursionEnabled -eq $true) {
            echo 'WARN: DNS 서버 ' + $server.Name + '에서 재귀 쿼리가 활성화되어 있습니다. 설정을 검토해야 합니다.' >> '!TMP1!';
        } else {
            echo 'OK: DNS 서버 ' + $server.Name + '에서 재귀 쿼리가 제한되어 있습니다.' >> '!TMP1!';
        }
    }
}" >> "!TMP1!"

:: 관리자에게의 주의사항
echo 주의: 각 DNS 서버의 IsRecursionEnabled 속성을 검토하세요. 'True'는 재귀 쿼리가 활성화됨을 나타냅니다; 안전하게 구성되었는지 확인하세요. >> "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
:: 결과 표시
type "!TMP1!"

echo.
echo 스크립트 완료.
endlocal
