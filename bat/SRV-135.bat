@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for TCP Security settings analysis
set "csvFile=!resultDir!\TCP_Security_Settings.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-135"
set "riskLevel=높음"
set "diagnosisItem=TCP 보안 설정 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-135] TCP 보안 설정 미비 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 필수 TCP 보안 설정이 적절히 구성된 경우 >> "!TMP1!"
echo [취약]: 필수 TCP 보안 설정이 구성되지 않은 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: PowerShell을 사용하여 TCP 관련 레지스트리 설정 확인
powershell -Command "& { 
    $results = @()
    $paths = @(
        'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\TcpWindowSize',
        'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Tcp1323Opts',
        'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\SynAttackProtect'
    )
    foreach ($path in $paths) {
        if (Test-Path $path) {
            $value = (Get-ItemProperty -Path $path).PSObject.Properties.Value
            $results += 'OK: ' + $path + ' 설정이 존재합니다: ' + $value
        } else {
            $results += 'WARN: ' + $path + ' 설정이 없습니다.'
        }
    }
    $results -join [Environment]::NewLine
}" | Out-File -FilePath temp.txt;

set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo Script complete.

endlocal
