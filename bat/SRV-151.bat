@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for security analysis
set "csvFile=!resultDir!\Security_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=보안 정책"
set "code=SRV-151"
set "riskLevel=높음"
set "diagnosisItem=익명 SID/이름 변환 허용"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ---------------------------------------- >> "!TMP1!"
echo CODE [SRV-151] 익명 SID/이름 변환 허용 >> "!TMP1!"
echo ---------------------------------------- >> "!TMP1%"
echo [양호]: 익명 SID/이름 변환을 허용하지 않는 경우 >> "!TMP1!"
echo [취약]: 익명 SID/이름 변환을 허용하는 경우 >> "!TMP1%"
echo ---------------------------------------- >> "!TMP1%"

:: 보안 정책 내보내기 및 익명 SID/이름 변환 정책 확인
powershell -Command "& {
    secedit /export /cfg secpol.cfg;
    $policy = Select-String -Path secpol.cfg -Pattern 'LSAAnonymousNameLookup';
    if ($policy -and $policy.Line -match '=0') {
        $status = 'OK: 익명 SID/이름 변환을 허용하지 않습니다.'
    } else {
        $status = 'WARN: 익명 SID/이름 변환을 허용합니다.'
    }
    Remove-Item secpol.cfg -Force;
    \"$status\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

type "!TMP1!"

echo.

endlocal
