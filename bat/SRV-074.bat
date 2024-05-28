@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for unmanaged accounts audit
set "csvFile=!resultDir!\Unmanaged_Accounts_Audit.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Account,Status,Note" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-074"
set "riskLevel=중"
set "diagnosisItem=불필요하거나 관리되지 않는 계정 검사"
set "diagnosisResult="
set "status="

set "logFile=%~n0.log"
type nul > "!logFile!"

echo ------------------------------------------------ >> "!logFile!"
echo CODE [SRV-074] 불필요하거나 관리되지 않는 계정 존재 >> "!logFile!"
echo ------------------------------------------------ >> "!logFile!"
echo [양호]: 불필요하거나 관리되지 않는 계정이 존재하지 않음 >> "!logFile!"
echo [취약]: 불필요하거나 관리되지 않는 계정이 존재함 >> "!logFile!"
echo ------------------------------------------------ >> "!logFile!"

:: List all user accounts and check the status of the Guest account
echo 모든 사용자 계정을 나열합니다: >> "!logFile!"
net user >> "!logFile!"
echo. >> "!logFile!"

echo 특히, 게스트 계정이 비활성화되어 있는지 확인하고, 소프트웨어 설치에 의해 생성된 기본 계정이 필요하고 안전한지 확인하세요. >> "!logFile!"
net user 게스트 | findstr /C:"계정 활성 상태" >> "!logFile!"

:: Suggest manual review
echo 나열된 계정 중 불필요하거나 활성화되어서는 안 되는 계정이 있는지 수동으로 검토해 주세요. >> "!logFile!"
echo 보다 상세한 관리를 위해 PowerShell 또는 로컬 사용자 및 그룹 MMC 스냅인(lusrmgr.msc) 사용을 고려하세요. >> "!logFile!"

:: Log output to CSV for each account
for /F "tokens=1,* delims= " %%a in ('net user') do (
    set "account=%%a"
    set "status=Active"
    echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!account!","!status!","Review needed" >> "!csvFile!"
)

:: Display the results
type "!logFile!"

echo.
echo 스크립트 완료.
endlocal
