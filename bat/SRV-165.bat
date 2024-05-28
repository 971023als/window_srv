@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Shell Access Audit
set "csvFile=!resultDir!\Shell_Access_Audit.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 접근 제어"
set "code=SRV-165"
set "riskLevel=높음"
set "diagnosisItem=불필요하게 Shell이 부여된 계정 존재"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-165] 불필요하게 Shell이 부여된 계정 존재 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 불필요하게 Shell이 부여된 계정이 존재하지 않는 경우 >> "!TMP1!"
echo [취약]: 불필요하게 Shell이 부여된 계정이 존재하는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Account Shell access check
powershell -Command "& {
    $users = Get-LocalUser | Where-Object { $_.Enabled -eq $true }
    foreach ($user in $users) {
        $shellAccess = $false
        $profilePath = 'C:\Users\' + $user.Name + '\NTUSER.DAT'
        if (Test-Path $profilePath) {
            $shellAccess = $true
        }
        if ($shellAccess) {
            Write-Output 'WARN: 계정에 쉘 접근이 활성화된 상태입니다: ' + $user.Name
        } else {
            Write-Output 'OK: 계정에 쉘 접근이 활성화되지 않았습니다: ' + $user.Name
        }
    }
}" > temp.txt
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
