@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-042] 웹 서비스 상위 디렉터리 접근 제한 설정 미흡 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: DocumentRoot가 별도의 보안 디렉터리로 지정된 경우 >> !TMP1!
echo [취약]: DocumentRoot가 기본 디렉터리 또는 민감한 디렉터리로 지정된 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: 디렉터리 접근 권한 설정 확인 (PowerShell 사용)
powershell -Command "& {
    Import-Module WebAdministration;
    $sites = Get-Website | foreach { $_.Name };
    foreach ($site in $sites) {
        $rootPath = Get-WebApplication -Site $site | Select -ExpandProperty PhysicalPath;
        $accessPolicy = Get-WebConfigurationProperty -pspath 'IIS:\Sites\'$site -filter 'system.webServer/security/authorization' -name '.Collection';
        if ($accessPolicy.Count -eq 0) {
            Add-Content !TMP1! ('WARN: 웹 사이트 '''+$site+'''에서 상위 디렉터리 접근 제한 설정이 미흡합니다. 루트 경로: '+$rootPath);
        } else {
            Add-Content !TMP1! ('OK: 웹 사이트 '''+$site+'''에서 상위 디렉터리 접근 제한 설정이 적절합니다. 루트 경로: '+$rootPath);
        }
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
