@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Cron service usage analysis
set "csvFile=!resultDir!\Cron_Service_Usage_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 정책"
set "code=SRV-133"
set "riskLevel=높음"
set "diagnosisItem=Cron 서비스 사용 계정 제한"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-133] Cron 서비스 사용 계정 제한 미비 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: Cron 서비스 사용이 특정 계정으로 제한되어 있는 경우 >> "!TMP1!"
echo [취약]: Cron 서비스 사용이 제한되지 않은 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 작업 스케줄러의 작업과 실행 계정 확인 (PowerShell 사용)
powershell -Command "& {
    $scheduledTasks = Get-ScheduledTask | Where-Object { $_.State -eq 'Ready' }
    foreach ($task in $scheduledTasks) {
        $taskName = $task.TaskName
        $taskPath = $task.TaskPath
        $principal = $task.Principal.UserId
        $info = ""$taskPath$taskName 실행 계정: $principal""
        Add-Content -Path temp.txt -Value $info
    }
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo Script complete.

endlocal
