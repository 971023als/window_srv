@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for web service directory access checks
set "csvFile=!resultDir!\Web_Service_Directory_Access.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Website,Root Path,Access Policy,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=웹 보안"
set "code=SRV-042"
set "riskLevel=높음"
set "diagnosisItem=상위 디렉터리 접근 제한 설정 검사"
set "website="
set "rootPath="
set "accessPolicy="
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-042] 웹 서비스 상위 디렉터리 접근 제한 설정 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: DocumentRoot가 별도의 보안 디렉터리로 지정된 경우 >> "!TMP1!"
echo [취약]: DocumentRoot가 기본 디렉터리 또는 민감한 디렉터리로 지정된 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 디렉터리 접근 권한 설정 확인 (PowerShell 사용)
powershell -Command "& {
    Import-Module WebAdministration;
    $sites = Get-Website;
    foreach ($site in $sites) {
        $siteName = $site.Name;
        $rootPath = (Get-WebApplication -Site $siteName).PhysicalPath;
        $accessPolicy = (Get-WebConfigurationProperty -pspath 'IIS:\Sites\'$siteName -filter 'system.webServer/security/authorization' -name '.Collection').Count;
        if ($accessPolicy -eq 0) {
            $status = 'WARN: 상위 디렉터리 접근 제한 설정이 미흡합니다.'
        } else {
            $status = 'OK: 상위 디렉터리 접근 제한 설정이 적절합니다.'
        }
        \"$siteName, $rootPath, $accessPolicy, $status\" | Out-File -FilePath temp.txt;
        set /p diagnosisResult=<temp.txt
        del temp.txt
        echo "!category!","!code!","!riskLevel!","!diagnosisItem!","$siteName","$rootPath","$accessPolicy","!diagnosisResult!","!status!" >> "!csvFile!"
    }
}"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
