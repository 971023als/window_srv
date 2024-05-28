@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Secure Channel Data Encryption/Signing Status
set "csvFile=!resultDir!\Secure_Channel_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-104"
set "riskLevel=높음"
set "diagnosisItem=보안 채널 데이터 디지털 암호화 또는 서명 기능 비활성화"
set "service=보안 프로토콜"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-104] 보안 채널 데이터 디지털 암호화 또는 서명 기능 비활성화 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 보안 채널 데이터의 디지털 암호화 및 서명 기능이 활성화되어 있는 경우 >> "!TMP1!"
echo [취약]: 보안 채널 데이터의 디지털 암호화 및 서명 기능이 비활성화되어 있는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Windows 환경에서 레지스트리 설정을 통해 보안 채널 데이터의 디지털 암호화 및 서명 기능 활성화 여부 확인
powershell -Command "& {
    $regPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters';
    $smbSigningEnabled = (Get-ItemProperty -Path $regPath -Name 'RequireSecuritySignature').RequireSecuritySignature;
    if ($smbSigningEnabled -eq 1) {
        \"$status = 'OK: 보안 채널 데이터의 디지털 암호화 및 서명 기능이 활성화되어 있습니다.'\" | Out-File -FilePath temp.txt;
    } else {
        \"$status = 'WARN: 보안 채널 데이터의 디지털 암호화 및 서명 기능이 비활성화되어 있습니다.'\" | Out-File -FilePath temp.txt;
    }
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1%"

echo.
echo Script complete.
endlocal
