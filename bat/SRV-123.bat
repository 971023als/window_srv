@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for last login user status analysis
set "csvFile=!resultDir!\Last_Login_User_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=사용자 계정 보안"
set "code=SRV-123"
set "riskLevel=낮"
set "diagnosisItem=최종 로그인 사용자 계정 노출 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-123] 최종 로그인 사용자 계정 노출 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 최종 로그인 사용자 정보가 노출되지 않는 경우 >> "!TMP1!"
echo [취약]: 최종 로그인 사용자 정보가 노출되는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: PowerShell을 사용하여 최종 로그인한 사용자 정보 조회
powershell -Command "& {
    $lastLogonEvent = Get-EventLog -LogName Security -InstanceId 4624 -Newest 1
    if ($lastLogonEvent) {
        $username = $lastLogonEvent.ReplacementStrings[5]
        $logonType = $lastLogonEvent.ReplacementStrings[8]
        $statusMessage = '최종 로그인 사용자: ' + $username + ', 로그인 유형: ' + $logonType
        echo $statusMessage > temp.txt
        set 'diagnosisResult=노출됨'
    } else {
        echo '최종 로그인 사용자 정보를 조회할 수 없습니다.' > temp.txt
        set 'diagnosisResult=정보 없음'
    }
}"
set /p statusMessage=<temp.txt
del temp.txt

echo %statusMessage% >> "!TMP1!"

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!statusMessage!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo Script complete.

endlocal
