@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for DEP and ASLR status analysis
set "csvFile=!resultDir!\DEP_ASLR_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-134"
set "riskLevel=높음"
set "diagnosisItem=스택 영역 실행 방지 설정 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-134] 스택 영역 실행 방지 미설정 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 스택 영역 실행 방지가 활성화된 경우 >> "!TMP1!"
echo [취약]: 스택 영역 실행 방지가 비활성화된 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: PowerShell을 사용하여 DEP 및 ASLR 설정 확인
powershell -Command "& {
    $depStatus = Get-ProcessMitigation -System | Select-Object -ExpandProperty Dep
    $aslrStatus = Get-ProcessMitigation -System | Select-Object -ExpandProperty Aslr

    if ($depStatus.Enable -eq 'ON' -and $aslrStatus.ForceRelocateImages -eq 'ON') {
        $result = 'OK: 스택 영역 실행 방지가 활성화되어 있습니다.'
    } else {
        $result = 'WARN: 스택 영역 실행 방지가 비활성화되어 있습니다.'
    }
    \"$result\" | Out-File -FilePath temp.txt;
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
