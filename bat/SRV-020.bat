@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for share access control analysis
set "csvFile=!resultDir!\Share_Access_Control.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-020"
set "riskLevel=중"
set "diagnosisItem=NFS/SMB/CIFS 공유의 접근 통제 검사"
set "diagnosisResult="
set "status="

:: SMB 공유 접근 통제 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $SmbShares = Get-SmbShare;
    $result = '';
    foreach ($share in $SmbShares) {
        $SharePermissions = Get-SmbShareAccess -Name $share.Name;
        foreach ($perm in $SharePermissions) {
            if ($perm.AccountName -eq 'Everyone' -and $perm.AccessRight -eq 'Full') {
                $result += 'WARN: ' + $share.Name + ' SMB 공유에서 Everyone에게 전체 접근 권한이 부여됨; '
            } else {
                $result += 'OK: ' + $share.Name + ' SMB 공유의 접근 통제가 적절함; '
            }
        }
    }
    if ($result -eq '') {
        $result = 'No shares found or checked.'
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
