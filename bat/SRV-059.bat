@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for web service file size limits
set "csvFile=!resultDir!\Web_Service_File_Size_Limits.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Website,Max Upload Size (MB),Diagnosis Result" > "!csvFile!"

REM Define security details
set "category=웹 보안"
set "code=SRV-059"
set "riskLevel=중"
set "diagnosisItem=파일 업로드 및 다운로드 크기 제한"
set "diagnosisResult="
set "status="

REM Setup log file
set "TMP1=%~dp0%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-059] 웹 서비스 파일 업로드 및 다운로드 크기 제한 미설정 >> "!TMP1!"
echo [양호]: 웹 서비스에서 파일 업로드 및 다운로드 크기가 적절하게 제한됨 >> "!TMP1!"
echo [취약]: 웹 서비스에서 파일 업로드 및 다운로드 크기가 제한되지 않음 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Check each IIS web service site for file upload size limits using PowerShell
powershell -Command "& {
    Import-Module WebAdministration;
    $sites = Get-WebSite;
    foreach ($site in $sites) {
        $siteName = $site.Name;
        $configPath = 'IIS:\Sites\' + $siteName;
        $requestFiltering = Get-WebConfigurationProperty -pspath $configPath -filter 'system.webServer/security/requestFiltering/requestLimits' -name 'maxAllowedContentLength';
        $maxSize = $requestFiltering.Value / 1024 / 1024; # Convert from bytes to MB
        $diagnosisResult = if ($maxSize -le 100) { # Assumed limit 100MB
            'OK: ' + $siteName + ' limits file uploads to ' + $maxSize + ' MB.'
        } else {
            'WARN: ' + $siteName + ' does not limit file uploads effectively (' + $maxSize + ' MB).'
        }
        \"$diagnosisResult\" | Out-File -FilePath temp.txt;
        set /p diagnosisResult=<temp.txt
        del temp.txt
        echo '!category!','!code!','!riskLevel!','!diagnosisItem!','$siteName','$maxSize','$diagnosisResult' >> '!csvFile!'
        echo $diagnosisResult >> '!TMP1!'
    }
}"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.

endlocal
