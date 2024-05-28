@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for web service script mapping and file size limits
set "csvFile=!resultDir!\Web_Service_File_Size_Limits.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Website,Max Upload Size (MB),Diagnosis Result" > "!csvFile!"

REM Define security details
set "category=웹 보안"
set "code=SRV-058"
set "riskLevel=중"
set "diagnosisItem=웹 서비스의 불필요한 스크립트 매핑 및 파일 업로드 크기 검사"
set "diagnosisResult="
set "status="

REM Setup log file
set "TMP1=%~dp0%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-058] 웹 서비스의 불필요한 스크립트 매핑 및 파일 업로드 크기 검사 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"
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
        $maxAllowedContentLength = (Get-WebConfigurationProperty -pspath $configPath -filter 'system.webServer/security/requestFiltering/requestLimits' -name 'maxAllowedContentLength').Value;
        $maxSizeMB = $maxAllowedContentLength / 1024 / 1024;
        $result = if ($maxSizeMB -le 100) { # Assumed limit 100MB
            'OK: ' + $siteName + ' limits file uploads to ' + $maxSizeMB + ' MB.'
        } else {
            'WARN: ' + $siteName + ' does not limit file uploads effectively (' + $maxSizeMB + ' MB).'
        }
        echo \"$siteName,$maxSizeMB,$result\" | Out-File -FilePath temp.txt;
        set /p diagnosisResult=<temp.txt
        echo '!category!','!code!','!riskLevel!','!diagnosisItem!','$siteName','$maxSizeMB','$diagnosisResult' >> '!csvFile!';
        del temp.txt
    }
}"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.

endlocal
