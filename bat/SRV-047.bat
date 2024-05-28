@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for web service symbolic links check
set "csvFile=!resultDir!\Web_Service_Symbolic_Links.csv"
echo "Category,Code,Risk Level,Diagnosis Item,File Path,Diagnosis Result" > "!csvFile!"

REM Define security details
set "category=웹 보안"
set "code=SRV-047"
set "riskLevel=중"
set "diagnosisItem=웹 서비스 경로 내 불필요한 링크 파일 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-047] 웹 서비스 경로 내 불필요한 링크 파일 존재 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"
echo [양호]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재하지 않음 >> "!TMP1!"
echo [취약]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재함 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Set IIS web service path (adjust to actual path as necessary)
set "IIS_WEB_SERVICE_PATH=C:\inetpub\wwwroot"

:: Search for symbolic links (.lnk and other link files) in IIS web service path
echo %IIS_WEB_SERVICE_PATH% 내 심볼릭 링크 파일 검사 중: >> "!TMP1!"
for /r "%IIS_WEB_SERVICE_PATH%" %%f in (*.lnk, *.url) do (
    echo Found: %%f >> "!TMP1!"
    set "filePath=%%f"
    set "diagnosisResult=WARN: 불필요한 링크 파일 발견"
    echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!filePath!","!diagnosisResult!" >> "!csvFile!"
)

:: Admin note
echo 주의: 이 스크립트는 .lnk 및 .url 바로가기 파일을 나열합니다. 수동으로 검토하여 필요한 파일인지 확인해 주세요. >> "!TMP1!"

:: Display results
type "!TMP1!"

echo.
echo 스크립트 완료.

endlocal
