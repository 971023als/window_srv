@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
> %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-125] 화면보호기 미설정 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 화면보호기가 설정되어 있는 경우 >> %TMP1%
echo [취약]: 화면보호기가 설정되어 있지 않은 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 화면보호기 설정 확인
powershell -Command "& {
    $screenSaverActive = Get-ItemProperty 'HKCU:\Control Panel\Desktop\' -Name ScreenSaveActive
    if ($screenSaverActive.ScreenSaveActive -eq '1') {
        echo 'OK: 화면보호기가 설정되어 있습니다.' >> '%TMP1%'
    } else {
        echo 'WARN: 화면보호기가 설정되어 있지 않습니다.' >> '%TMP1%'
    }
}" >> %TMP1%

type %TMP1%

echo.
echo.

endlocal
