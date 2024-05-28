@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for permission audit
set "csvFile=!resultDir!\Permission_Audit.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=파일 시스템 보안"
set "code=SRV-095"
set "riskLevel=높음"
set "diagnosisItem=소유자 또는 그룹 권한이 없는 파일 또는 디렉터리 존재"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-095] 소유자 또는 그룹 권한이 없는 파일 또는 디렉터리가 존재함 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 소유자 또는 그룹 권한이 없는 파일 또는 디렉터리가 없음 >> "!TMP1!"
echo [취약]: 소유자 또는 그룹 권한이 없는 파일 또는 디렉터리가 있음 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 소유자 또는 그룹 권한이 없는 파일 또는 디렉터리의 존재 여부를 확인합니다.
:: Windows 환경에서는 'icacls' 명령어를 사용하여 파일 권한을 확인할 수 있습니다.
set "checkDir=C:\Path\To\Check"
for /R "%checkDir%" %%F in (*.*) do (
    icacls "%%F" | findstr /C:"Everyone" >nul
    if errorlevel 1 (
        echo OK "%%F 소유자 또는 그룹 권한이 설정되어 있습니다." >> "!TMP1!"
    ) else (
        echo 경고 "%%F에 소유자 또는 그룹 권한이 설정되어 있지 않습니다." >> "!TMP1!"
        set "diagnosisResult=경고: 소유자 또는 그룹 권한이 없는 파일 또는 디렉터리가 존재함"
    )
)

if not defined diagnosisResult set "diagnosisResult=양호: 모든 파일 또는 디렉터리가 적절한 권한으로 설정됨"

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.
endlocal
