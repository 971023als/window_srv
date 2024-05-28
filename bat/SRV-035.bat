@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for vulnerable services analysis
set "csvFile=!resultDir!\Vulnerable_Services.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-035"
set "riskLevel=높음"
set "diagnosisItem=취약한 서비스 활성화 검사"

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-035] 취약한 서비스 활성화 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 취약한 서비스가 비활성화된 경우 >> "!TMP1!"
echo [취약]: 취약한 서비스가 활성화된 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 취약한 서비스 목록
set "services=Telnet RemoteRegistry"

:: 서비스 상태 확인 (PowerShell 사용)
for %%s in (!services!) do (
    powershell -Command "& {
        $service = Get-Service -Name '%%s' -ErrorAction SilentlyContinue;
        if ($service -and $service.Status -eq 'Running') {
            $result = 'WARN: 취약한 서비스 ''%%s''가 활성화되어 있습니다.'
        } else {
            $result = 'OK: 서비스 ''%%s''가 비활성화되어 있거나, 시스템에 설치되지 않았습니다.'
        }
        \"$result\" | Out-File -FilePath temp.txt;
    }"
    set /p diagnosisResult=<temp.txt
    del temp.txt
    echo "!category!","!code!","!riskLevel!","!diagnosisItem!","%%s","!diagnosisResult!" >> "!csvFile!"
)

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
