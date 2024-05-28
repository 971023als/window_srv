@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-133] Cron 서비스 사용 계정 제한 미비 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: Cron 서비스 사용이 특정 계정으로 제한되어 있는 경우 >> %TMP1%
echo [취약]: Cron 서비스 사용이 제한되지 않은 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 작업 스케줄러의 작업과 실행 계정 확인
powershell -Command "& {
    $scheduledTasks = Get-ScheduledTask | Where-Object { $_.State -eq 'Ready' }
    foreach ($task in $scheduledTasks) {
        $taskName = $task.TaskName
        $taskPath = $task.TaskPath
        $principal = $task.Principal.UserId
        echo ""$taskPath$taskName 실행 계정: $principal"" >> '%TMP1%'
    }
}" >> %TMP1%

type %TMP1%

echo.
echo.

endlocal
