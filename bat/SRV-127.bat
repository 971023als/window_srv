@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for account lockout policy status analysis
set "csvFile=!resultDir!\Account_Lockout_Policy_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=계정 관리"
set "code=SRV-127"
set "riskLevel=높음"
set "diagnosisItem=계정 잠금 임계값 설정 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-127] 계정 잠금 임계값 설정 미비 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 계정 잠금 임계값이 적절하게 설정된 경우 >> "!TMP1!"
echo [취약]: 계정 잠금 임계값이 적절하게 설정되지 않은 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 계정 잠금 정책 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $accountLockoutThreshold = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters').AccountLockoutThreshold
    if ($accountLockoutThreshold -ne $null -and $accountLockoutThreshold -gt 0) {
        $status = 'OK: 계정 잠금 임계값이 설정되어 있습니다: 임계값 = ' + $accountLockoutThreshold
    } else {
        $status = 'WARN: 계정 잠금 임계값이 설정되어 있지 않습니다.'
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
