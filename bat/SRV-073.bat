@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for administrator group membership analysis
set "csvFile=!resultDir!\Administrator_Group_Membership.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-073"
set "riskLevel=높음"
set "diagnosisItem=관리자 그룹 내 사용자 멤버쉽 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-073] 관리자 그룹 내 불필요한 사용자 존재 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 관리자 그룹에 불필요한 사용자가 없음 >> "!TMP1!"
echo [취약]: 관리자 그룹에 불필요한 사용자가 존재함 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 관리자 그룹의 멤버 나열 (Command 사용)
net localgroup 관리자 > temp.txt
set /p diagnosisResult=<temp.txt
del temp.txt

echo 관리자 그룹의 멤버를 나열합니다: >> "!TMP1!"
type temp.txt >> "!TMP1!"

:: 수동 검토에 대한 주의사항
echo 관리자 그룹의 멤버 중 불필요하거나 속하지 않아야 할 사용자가 있는지 수동으로 검토해주세요. >> "!TMP1!"

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.
endlocal
