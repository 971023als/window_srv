@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-135] TCP 보안 설정 미비 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 필수 TCP 보안 설정이 적절히 구성된 경우 >> %TMP1%
echo [취약]: 필수 TCP 보안 설정이 구성되지 않은 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 TCP 관련 레지스트리 설정 확인
powershell -Command "& { 
    $paths = @(
        'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\TcpWindowSize',
        'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Tcp1323Opts',
        'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\SynAttackProtect'
    )
    foreach ($path in $paths) {
        if (Test-Path $path) {
            $value = Get-ItemProperty -Path $path
            echo 'OK: ' + $path + ' 설정이 존재합니다: ' + $value
        } else {
            echo 'WARN: ' + $path + ' 설정이 없습니다.'
        }
    }
}" >> %TMP1%

type %TMP1%

echo.
echo.

endlocal
