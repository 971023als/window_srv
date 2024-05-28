@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for antivirus status analysis
set "csvFile=!resultDir!\Antivirus_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=보안 소프트웨어"
set "code=SRV-129"
set "riskLevel=높음"
set "diagnosisItem=백신 프로그램 설치 여부"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-129] 백신 프로그램 미설치 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 백신 프로그램이 설치되어 있는 경우 >> "!TMP1!"
echo [취약]: 백신 프로그램이 설치되어 있지 않은 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 설치된 백신 프로그램 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $antivirusStatus = Get-CimInstance -Namespace 'root\SecurityCenter2' -ClassName 'AntivirusProduct'
    if ($antivirusStatus) {
        $status = 'OK: 설치된 백신 프로그램이 있습니다. '
        foreach ($product in $antivirusStatus) {
            $status += $product.displayName + ' (' + $product.productState + '); '
        }
    } else {
        $status = 'WARN: 설치된 백신 프로그램이 없습니다.'
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
