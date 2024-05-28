@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for log configuration file status analysis
set "csvFile=!resultDir!\Log_Configuration_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 로깅"
set "code=SRV-094"
set "riskLevel=높음"
set "diagnosisItem=crontab 참조 파일의 권한 설정 미흡"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-094] crontab 참조 파일의 권한 설정 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 정책에 따라 로그 기록 정책이 수립됨 >> "!TMP1!"
echo [취약]: 정책에 따라 로그 기록 정책이 수립되지 않음 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Windows 대응 검사 위치 설정
set "filename=C:\Path\To\Windows\Log\Configuration\File.txt"

:: 파일 존재 여부 확인
if not exist "!filename!" (
    set "diagnosisResult=경고: !filename!이(가) 존재하지 않습니다."
    echo !diagnosisResult! >> "!TMP1!"
) else (
    :: 필요한 내용이나 체크 정의
    set "expected_content1=예상 내용 줄 1"
    set "expected_content2=예상 내용 줄 2"
    
    :: 일치하는 수 초기화
    set /a match=0
    
    :: 파일에서 각 예상 내용 줄 검사
    for %%i in ("!expected_content1!" "!expected_content2!") do (
        findstr /c:%%~i "!filename!" >nul
        if !errorlevel! equ 0 (
            set /a match+=1
        )
    )

    :: 모든 예상 내용이 일치했는지 확인
    if !match! equ 2 (
        set "diagnosisResult=OK: !filename!의 내용이 정확합니다."
        echo !diagnosisResult! >> "!TMP1!"
    ) else (
        set "diagnosisResult=경고: !filename!의 내용 중 일부 설정이 누락되었습니다."
        echo !diagnosisResult! >> "!TMP1!"
    )
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.
endlocal
