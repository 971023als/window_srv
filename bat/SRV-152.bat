@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for SSH access status analysis
set "csvFile=!resultDir!\SSH_Access_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-152"
set "riskLevel=중"
set "diagnosisItem=원격터미널 접속 가능한 사용자 그룹 제한 미비"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ---------------------------------------- >> "!TMP1%"
echo CODE [SRV-152] 원격터미널 접속 가능한 사용자 그룹 제한 미비 >> "!TMP1%"
echo ---------------------------------------- >> "!TMP1%"
echo [양호]: SSH 접속이 특정 그룹에게만 제한된 경우 >> "!TMP1%"
echo [취약]: SSH 접속이 특정 그룹에게만 제한되지 않은 경우 >> "!TMP1%"
echo ---------------------------------------- >> "!TMP1%"

:: Check SSH service status
powershell -Command "& {
    $service = Get-Service -Name 'sshd' -ErrorAction SilentlyContinue;
    if ($service -and $service.Status -eq 'Running') {
        $status = 'OK: SSH 서비스가 설치되어 있습니다.'
    } else {
        $status = 'WARN: SSH 서비스가 설치되어 있지 않거나 비활성화되어 있습니다.'
    }
    \"$status\" | Out-File -FilePath temp.txt;
}"

set /p diagnosisResult=<temp.txt
del temp.txt

:: Check for the existence of the sshd_config file
set "config_path=C:\ProgramData\ssh\sshd_config"
if exist "!config_path!" (
    set "additionalInfo=sshd_config 파일이 존재합니다."
) else (
    set "additionalInfo=WARN: sshd_config 파일이 존재하지 않습니다."
)

echo "!additionalInfo!" >> "!TMP1!"

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

type "!TMP1!"

echo.
echo Script complete.

endlocal
