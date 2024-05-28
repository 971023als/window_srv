@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for SU command usage analysis
set "csvFile=!resultDir!\SU_Command_Usage_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 관리"
set "code=SRV-131"
set "riskLevel=높음"
set "diagnosisItem=SU 명령 사용 가능 그룹 제한"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-131] SU 명령 사용가능 그룹 제한 미비 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: SU 명령을 특정 그룹에만 허용한 경우 >> "!TMP1!"
echo [취약]: SU 명령을 모든 사용자가 사용할 수 있는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 그룹 정책 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $policyPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer'
    $policyName = 'AlwaysInstallElevated'
    if (Test-Path $policyPath) {
        $policyValue = Get-ItemProperty -Path $policyPath -Name $policyName -ErrorAction SilentlyContinue
        if ($policyValue -and $policyValue.$policyName -eq 1) {
            $status = 'WARN: 모든 사용자가 관리자 권한으로 설치 프로그램을 실행할 수 있습니다.'
        } else {
            $status = 'OK: 설치 프로그램의 관리자 권한 실행이 제한되어 있습니다.'
        }
    } else {
        $status = 'INFO: 지정된 그룹 정책 경로가 존재하지 않습니다.'
    }
    \"$status\" | Out-File -FilePath temp.txt;
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
