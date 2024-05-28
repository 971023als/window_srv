@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for automatic logon status analysis
set "csvFile=!resultDir!\AutoLogon_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 구성"
set "code=SRV-126"
set "riskLevel=높음"
set "diagnosisItem=자동 로그온 방지 설정 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-126] 자동 로그온 방지 설정 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 자동 로그온이 비활성화된 경우 >> "!TMP1!"
echo [취약]: 자동 로그온이 활성화된 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 자동 로그온 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $autoLogonKey = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon';
    $autoLogonValue = Get-ItemProperty -Path $autoLogonKey -Name 'AutoAdminLogon' -ErrorAction SilentlyContinue;
    if ($autoLogonValue.AutoAdminLogon -eq '1') {
        $status = 'WARN: 자동 로그온이 활성화되어 있습니다.'
    } else {
        $status = 'OK: 자동 로그온이 비활성화되어 있습니다.'
    }
    \"$status\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo Script complete.

endlocal
