@echo off
setlocal enabledelayedexpansion

:: 결과 파일 정의
set "TMP1=%~n0.log"
> "%TMP1%"

:: 헤더 정보 추가
echo ------------------------------------------------ >> "%TMP1%"
echo 코드 [SRV-094] crontab 참조 파일의 권한 설정 미흡 >> "%TMP1%"
echo ------------------------------------------------ >> "%TMP1%"
echo [양호]: 정책에 따라 로그 기록 정책이 수립됨 >> "%TMP1%"
echo [취약]: 정책에 따라 로그 기록 정책이 수립되지 않음 >> "%TMP1%"
echo ------------------------------------------------ >> "%TMP1%"

:: /etc/rsyslog.conf의 Windows 대응 검사를 위한 자리 표시자
:: 특정 로그 구성 파일이나 작업 스케줄러 작업을 검사할 수 있음
set "filename=C:\Path\To\Windows\Log\Configuration\File.txt"

:: 파일 존재 여부 확인
if not exist "%filename%" (
    echo 경고 "%filename%이(가) 존재하지 않습니다." >> "%TMP1%"
) else (
    :: 필요한 내용이나 체크 정의
    set "expected_content1=예상 내용 줄 1"
    set "expected_content2=예상 내용 줄 2"
    
    :: 일치하는 수 초기화
    set /a match=0
    
    :: 파일에서 각 예상 내용 줄 검사
    for %%i in ("!expected_content1!" "!expected_content2!") do (
        findstr /c:%%~i "%filename%" >nul
        if !errorlevel! equ 0 (
            set /a match+=1
        )
    )

    :: 모든 예상 내용이 일치했는지 확인
    if !match! equ 2 (
        echo OK "%filename%의 내용이 정확합니다." >> "%TMP1%"
    ) else (
        echo 경고 "%filename%의 내용 중 일부 설정이 누락되었습니다." >> "%TMP1%"
    )
)

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
endlocal
