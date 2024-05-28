@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for CGI script management analysis
set "csvFile=!resultDir!\CGI_Script_Management.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Script Path,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=웹 보안"
set "code=SRV-041"
set "riskLevel=중"
set "diagnosisItem=CGI 스크립트 관리 설정 검사"
set "scriptPath="
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-041] 웹 서비스의 CGI 스크립트 관리 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: CGI 스크립트 관리가 적절하게 설정된 경우 >> "!TMP1!"
echo [취약]: CGI 스크립트 관리가 미흡한 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: CGI 스크립트 실행 설정 확인 (PowerShell 사용)
powershell -Command "& {
    Import-Module WebAdministration;
    $cgiSettings = Get-WebConfiguration -Filter '/system.webServer/handlers' -PSPath 'IIS:\';
    $cgiHandlers = $cgiSettings.Collection | Where-Object { $_.path -eq '*.cgi' -or $_.path -eq '*.pl' };
    if ($cgiHandlers) {
        foreach ($handler in $cgiHandlers) {
            $status = 'WARN: CGI 스크립트 (' + $handler.path + ') 실행이 허용되어 있습니다.'
            \"$handler.path, $status\" | Out-File -FilePath temp.txt;
            set /p diagnosisResult=<temp.txt
            del temp.txt
            echo "!category!","!code!","!riskLevel!","!diagnosisItem!","$handler.path","!diagnosisResult!","!status!" >> "!csvFile!"
        }
    } else {
        $status = 'OK: CGI 스크립트 실행이 적절하게 제한되어 있습니다.'
        \"$status\" | Out-File -FilePath temp.txt;
        set /p diagnosisResult=<temp.txt
        del temp.txt
        echo "!category!","!code!","!riskLevel!","!diagnosisItem!","None","!diagnosisResult!","!status!" >> "!csvFile!"
    }
}"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
