@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for removable media policy analysis
set "csvFile=!resultDir!\Removable_Media_Policy_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=보안 정책"
set "code=SRV-140"
set "riskLevel=중"
set "diagnosisItem=이동식 미디어 포맷 및 꺼내기 허용 정책"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-140] 이동식 미디어 포맷 및 꺼내기 허용 정책 설정 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 이동식 미디어의 포맷 및 꺼내기에 대한 사용 정책이 적절하게 설정되어 있는 경우 >> "!TMP1!"
echo [취약]: 이동식 미디어의 포맷 및 꺼내기에 대한 사용 정책이 설정되어 있지 않은 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Check removable media policy using PowerShell
powershell -Command "& {
    $policy = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AllocateDASD';
    if ($policy.AllocateDASD -eq '0') {
        $status = 'OK: Only administrators can format and eject removable media.'
    } elseif ($policy.AllocateDASD -eq '1') {
        $status = 'WARN: Any user can format and eject removable media.'
    } else {
        $status = 'INFO: No specific policy defined for formatting and ejecting removable media.'
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

endlocal
