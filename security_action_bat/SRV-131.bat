@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-131] SU 명령 사용가능 그룹 제한 미비 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: SU 명령을 특정 그룹에만 허용한 경우 >> %TMP1%
echo [취약]: SU 명령을 모든 사용자가 사용할 수 있는 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 그룹 정책 설정 확인
powershell -Command "& {
    $policyPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer'
    $policyName = 'AlwaysInstallElevated'
    if (Test-Path $policyPath) {
        $policyValue = Get-ItemProperty -Path $policyPath -Name $policyName -ErrorAction SilentlyContinue
        if ($policyValue -and $policyValue.$policyName -eq 1) {
            echo 'WARN: 모든 사용자가 관리자 권한으로 설치 프로그램을 실행할 수 있습니다.' >> '%TMP1%'
        } else {
            echo 'OK: 설치 프로그램의 관리자 권한 실행이 제한되어 있습니다.' >> '%TMP1%'
        }
    } else {
        echo 'INFO: 지정된 그룹 정책 경로가 존재하지 않습니다.' >> '%TMP1%'
    }
}" >> %TMP1%

type %TMP1%

echo.
echo.

endlocal
