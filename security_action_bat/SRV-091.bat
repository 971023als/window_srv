@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [U-91] 불필요하게 SUID, SGID 비트가 설정된 파일 존재 >> "%TMP1%"
echo [양호]: SUID 및 SGID 비트가 불필요하게 설정된 파일이 없음 >> "%TMP1%"
echo [취약]: SUID 및 SGID 비트가 불필요하게 설정된 파일 존재 >> "%TMP1%"

:: 확인할 디렉토리 플레이스홀더 - 필요에 따라 조정
set "checkDir=C:\Path\To\Check"

:: icacls를 사용하여 파일의 권한을 나열
echo %checkDir% 내 파일을 확인하여 잠재적으로 상승된 권한 검사 >> "%TMP1%"
for /R "%checkDir%" %%F in (*.*) do (
    icacls "%%F" >> "%TMP1%"
)

:: 주의: 이 스크립트는 파일의 권한을 단순히 나열할 뿐, SUID/SGID의 등가물을 찾아내기 위해 그것들을 해석하지는 않습니다.
:: '잠재적으로 상승된 권한'의 해석은 수동으로 또는 더 복잡한 스크립팅으로 수행해야 합니다.

echo 검사 완료. 자세한 내용은 %TMP1%을 참조하세요.

echo.
echo 스크립트 완료.
