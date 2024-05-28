@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for backup and recovery permissions analysis
set "csvFile=!resultDir!\Backup_Recovery_Permissions_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=데이터 보안"
set "code=SRV-138"
set "riskLevel=높음"
set "diagnosisItem=백업 및 복구 권한 설정"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-138] 백업 및 복구 권한 설정 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"
echo [양호]: 백업 및 복구 권한이 적절히 설정된 경우 >> "!TMP1!"
echo [취약]: 백업 및 복구 권한이 적절히 설정되지 않은 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 백업 디렉토리 권한 확인
set "backupDir=C:\Backup"

:: 디렉토리 존재 여부 확인
if not exist "%backupDir%" (
    set "diagnosisResult=INFO: %backupDir% 디렉토리가 존재하지 않습니다."
) else (
    powershell -Command "& {
        $acl = Get-Acl '%backupDir%'
        if ($acl.Access | Where-Object { $_.FileSystemRights -like '*FullControl*' -and $_.IdentityReference -eq 'SYSTEM' }) {
            $status = 'OK: 백업 및 복구 권한이 적절히 설정되어 있습니다.'
        } else {
            $status = 'WARN: 백업 및 복구 권한이 적절히 설정되지 않았습니다.'
        }
        \"$status\" | Out-File -FilePath temp.txt;
    }"
    set /p diagnosisResult=<temp.txt
    del temp.txt
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo Script complete.
endlocal
