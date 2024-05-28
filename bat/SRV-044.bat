@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for web service upload and download size limits
set "csvFile=!resultDir!\Web_Service_Size_Limits.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Website,Max Upload Size (MB),Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=웹 보안"
set "code=SRV-044"
set "riskLevel=중"
set "diagnosisItem=파일 업로드 및 다운로드 크기 제한 검사"
set "website="
set "maxUploadSize="
set "diagnosisResult="
set "status="

REM Setup log file
set "TMP1=!resultDir!\%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-044] 웹 서비스 파일 업로드 및 다운로드 크기 제한 미설정 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"
echo [양호]: 웹 서비스에서 파일 업로드 및 다운로드 크기가 적절하게 제한됨 >> "!TMP1!"
echo [취약]: 웹 서비스에서 파일 업로드 및 다운로드 크기가 제한되지 않음 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Check IIS settings using PowerShell
powershell -Command "& {
    Import-Module WebAdministration;
    $logPath = '%TMP1%';
    $sites = Get-Website;
    foreach ($site in $sites) {
        $siteName = $site.Name;
        $configPath = 'IIS:\Sites\' + $siteName;
        $requestFiltering = Get-WebConfigurationProperty -pspath $configPath -filter 'system.webServer/security/requestFiltering/requestLimits' -name 'maxAllowedContentLength';

        $maxSize = $requestFiltering.Value / 1024 / 1024; # Convert from bytes to MB
        $status = if ($maxSize -lt 30) { # Example threshold 30MB
            'OK: 파일 업로드를 ' + $maxSize + ' MB로 제한합니다.'
        } else {
            'WARN: 파일 업로드 제한이 높음 (' + $maxSize + ' MB) 또는 설정되지 않음.'
        }
        \"$siteName, $maxSize, $status\" | Out-File -FilePath temp.txt;
        set /p diagnosisResult=<temp.txt
        echo "!category!","!code!","!riskLevel!","!diagnosisItem!","$siteName","$maxSize","$diagnosisResult","$status" >> "!csvFile!"
        del temp.txt
    }
}"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.

endlocal
