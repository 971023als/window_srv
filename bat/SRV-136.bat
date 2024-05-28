@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for system shutdown privileges analysis
set "csvFile=!resultDir!\System_Shutdown_Privileges.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-136"
set "riskLevel=높음"
set "diagnosisItem=시스템 종료 권한 설정 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-136] 시스템 종료 권한 설정 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 시스템 종료 권한이 적절히 제한된 경우 >> "!TMP1!"
echo [취약]: 시스템 종료 권한이 제한되지 않은 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: PowerShell을 사용하여 시스템 종료 권한 정책 검사
powershell -Command "& {
    $secpol = secedit /export /cfg temp.txt
    $shutdownRights = select-string -path temp.txt -pattern 'SeShutdownPrivilege'
    if ($shutdownRights -match 'SeShutdownPrivilege\s*=\s*\*S-1-5-32-544') {
        $status = 'OK: 시스템 종료 권한이 적절히 제한되었습니다.'
    } else {
        $status = 'WARN: 시스템 종료 권한이 적절히 제한되지 않았습니다.'
    }
    del temp.txt
    \"$status\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
