@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for group member status analysis
set "csvFile=!resultDir!\Group_Member_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-164"
set "riskLevel=중"
set "diagnosisItem=구성원이 존재하지 않는 GID 존재"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-164] 구성원이 존재하지 않는 GID 존재 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 시스템에 구성원이 존재하지 않는 그룹(GID)가 존재하지 않는 경우 >> "!TMP1!"
echo [취약]: 시스템에 구성원이 존재하지 않는 그룹(GID)이 존재하는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Check for groups with no members using PowerShell
powershell -Command "& {
    $groups = Get-LocalGroup
    foreach ($group in $groups) {
        $members = Get-LocalGroupMember -Group $group.Name -ErrorAction SilentlyContinue
        if (-not $members) {
            $result = 'WARN: 구성원이 없는 그룹: ' + $group.Name
        } else {
            $result = 'OK: 모든 그룹에 구성원이 존재합니다.'
            break
        }
    }
    Write-Output $result
}" > temp.txt
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
