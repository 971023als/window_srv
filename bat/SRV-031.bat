@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0security_diagnostics"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for network share and account list exposure analysis
set "csvFile=!resultDir!\Network_Share_Exposure.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-031"
set "riskLevel=중"
set "diagnosisItem=계정 목록 및 네트워크 공유 이름 노출 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-031] 계정 목록 및 네트워크 공유 이름 노출 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 노출되지 않는 경우 >> "!TMP1!"
echo [취약]: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 노출되는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 네트워크 공유의 열거 제한 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters';
    $restrictNullSessAccess = Get-ItemPropertyValue -Path $registryPath -Name 'RestrictNullSessAccess' -ErrorAction SilentlyContinue;
    if ($null -ne $restrictNullSessAccess -and $restrictNullSessAccess -eq 1) {
        $status = 'OK: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 적절하게 보호되고 있습니다.';
    } else {
        $status = 'WARN: SMB 서비스에서 계정 목록 또는 네트워크 공유 이름이 노출될 수 있습니다.';
    }
    \"$status\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
