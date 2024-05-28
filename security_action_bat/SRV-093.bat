@echo off
setlocal

:: 결과 파일 정의
set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-093] 불필요한 세계 쓰기 가능 파일 존재 >> "%TMP1%"
echo [양호]: 시스템에 불필요한 세계 쓰기 가능 파일이 없음 >> "%TMP1%"
echo [취약]: 시스템에 불필요한 세계 쓰기 가능 파일이 존재함 >> "%TMP1%"

:: 검사할 디렉토리 지정 - 필요에 따라 조정해야 함
set "checkDir=C:\Path\To\Check"

:: icacls를 사용하여 권한을 확인. 이것은 매우 기본적이며 모든 것을 체크하지 않음.
:: 권한을 나열하고 "Everyone:(F)"가 있는지 확인하여 전체 제어를 나타냄.
icacls "%checkDir%"*.* /T | findstr "Everyone:(F)" > nul

if errorlevel 1 (
    echo OK "※ U-15 결과: 양호 - 과도하게 허용적인 파일을 찾지 못함." >> "%TMP1%"
) else (
    echo 경고 "과도하게 허용적인 파일이 발견됨." >> "%TMP1%"
)

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
