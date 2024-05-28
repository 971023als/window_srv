@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-040] 웹 서비스 디렉터리 리스팅 방지 설정 미흡 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: 웹 서비스 디렉터리 리스팅이 적절하게 방지된 경우 >> !TMP1!
echo [취약]: 웹 서비스 디렉터리 리스팅 방지 설정이 미흡한 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: 디렉터리 브라우징 설정 확인 (PowerShell 사용)
powershell -Command "& {
    Import-Module WebAdministration;
    $sites = Get-Website;
    foreach ($site in $sites) {
        $directoryBrowsing = Get-WebConfigurationProperty -pspath 'IIS:\Sites\$($site.name)' -filter 'system.webServer/directoryBrowse' -name 'enabled';
        if ($directoryBrowsing.Value -eq $true) {
            Add-Content !TMP1! ('WARN: 웹 사이트 ''$($site.name)''에서 디렉터리 브라우징이 활성화되어 있습니다.');
        } else {
            Add-Content !TMP1! ('OK: 웹 사이트 ''$($site.name)''에서 디렉터리 브라우징이 비활성화되어 있습니다.');
        }
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
