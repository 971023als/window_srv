@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for web service unnecessary files analysis
set "csvFile=!resultDir!\Unnecessary_Web_Files.csv"
echo "Category,Code,Risk Level,Diagnosis Item,File Path,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=웹 보안"
set "code=SRV-043"
set "riskLevel=중"
set "diagnosisItem=웹 서비스 경로 내 불필요한 파일 존재 검사"
set "filePath="
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-043] 웹 서비스 경로 내 불필요한 파일 존재 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"
echo [양호]: 웹 서비스 경로 내 불필요한 파일이 존재하지 않음 >> "!TMP1!"
echo [취약]: 웹 서비스 경로 내 불필요한 파일이 존재함 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

set "WEB_SERVICE_PATH=C:\inetpub\wwwroot"

:: 웹 서비스 경로 내 흔히 발견되는 불필요한 파일 목록 작성
echo %WEB_SERVICE_PATH% 내 흔히 발견되는 불필요한 파일 검사 중: >> "!TMP1!"
for /r "%WEB_SERVICE_PATH%" %%f in (*.bak, *.tmp, *test*, *example*) do (
    echo %%f >> "!TMP1!"
    set "fileFound=%%f"
    set "diagnosisResult=WARN: 불필요한 파일 발견"
    set "status=취약"
    echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!fileFound!","!diagnosisResult!","!status!" >> "!csvFile!"
)

:: 주의: 이 스크립트는 흔한 패턴을 기반으로 파일을 나열합니다. 수동으로 검토해 주세요.
echo 주의: 나열된 파일을 수동으로 검토하여 필요한 파일인지 확인해 주세요. >> "!TMP1!"

:: 결과 표시
type "!TMP1!"

echo.
echo 스크립트 완료.

endlocal
