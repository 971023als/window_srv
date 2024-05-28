@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for unnecessary services analysis
set "csvFile=!resultDir!\Unnecessary_Services.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 관리"
set "code=SRV-034"
set "riskLevel=중"
set "diagnosisItem=불필요한 서비스 활성화 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-034] 불필요한 서비스 활성화 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 불필요한 서비스가 비활성화된 경우 >> "!TMP1!"
echo [취약]: 불필요한 서비스가 활성화된 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 불필요한 서비스 목록
set "services=Telnet RemoteRegistry"

:: 서비스 상태 확인 (PowerShell 사용)
for %%s in (!services!) do (
    powershell -Command "& {
        $service = Get-Service -Name '%%s' -ErrorAction SilentlyContinue;
        if ($service -and $service.Status -eq 'Running') {
            $result = 'WARN: 불필요한 서비스 ''%%s''가 활성화되어 있습니다.'
        } else {
            $result = 'OK: 서비스 ''%%s''가 비활성화되어 있거나, 시스템에 설치되지 않았습니다.'
        }
        \"$result\" | Out-File -FilePath temp.txt;
    }"
    set /p diagnosisResult=<temp.txt
    del temp.txt
    echo "!category!","!code!","!riskLevel!","!diagnosisItem!","%%s","!diagnosisResult!","!status!" >> "!csvFile!"
)

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
endlocal
