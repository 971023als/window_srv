@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for SMTP Service Information Exposure
set "csvFile=!resultDir!\SMTP_Service_Exposure.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-170"
set "riskLevel=중"
set "diagnosisItem=SMTP 서비스 정보 노출"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-170] SMTP 서비스 정보 노출 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: SMTP 서비스에서 버전 정보 및 기타 세부 정보가 노출되지 않는 경우 >> "!TMP1!"
echo [취약]: SMTP 서비스에서 버전 정보 및 기타 세부 정보가 노출되는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: SMTP 서비스 설정 정보 확인 (예: Postfix)
powershell -Command "& {
    $configPath = 'C:\path\to\postfix\main.cf'
    if (Test-Path $configPath) {
        $configContent = Get-Content $configPath
        $bannerInfo = $configContent | Where-Object { $_ -like '*smtpd_banner = $myhostname*' }
        if ($bannerInfo) {
            $status = 'OK: SMTP 서비스에서 버전 정보 노출이 제한됩니다.'
        } else {
            $status = 'WARN: SMTP 서비스에서 버전 정보가 노출됩니다.'
        }
    } else {
        $status = 'INFO: SMTP 설정 파일이 존재하지 않습니다.'
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

endlocal
