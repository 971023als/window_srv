@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for unnecessary hard disk share status analysis
set "csvFile=!resultDir!\Disk_Share_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-018"
set "riskLevel=중"
set "diagnosisItem=불필요한 하드디스크 기본 공유 활성화 상태 검사"
set "diagnosisResult="
set "status="

:: SMB 공유 활성화 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $SmbShares = Get-SmbShare;
    $result = '';
    foreach ($share in $SmbShares) {
        if ($share.Name -match '\$$') {
            $result += 'WARN: SMB/CIFS에서 불필요한 하드디스크 기본 공유가 활성화된 경우: ' + $share.Name + '; '
        } else {
            $result += 'OK: SMB/CIFS의 불필요한 하드디스크 공유가 비활성화된 경우: ' + $share.Name + '; '
        }
    }
    if ($result -eq '') {
        $result = 'No specified shares found or checked.'
    }
    \"$result\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!diagnosisResult!","!status!" >> "!csvFile!"

REM Display the CSV content
type "!csvFile!"
echo

endlocal
