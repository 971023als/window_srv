@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-058] 웹 서비스의 불필요한 스크립트 매핑 >> "!TMP1!"
echo [양호]: 웹 서비스에서 파일 업로드 및 다운로드 크기가 적절하게 제한됨 >> "!TMP1!"
echo [취약]: 웹 서비스에서 파일 업로드 및 다운로드 크기가 제한되지 않음 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: IIS 웹 서비스의 각 사이트에 대한 파일 업로드 크기 제한을 PowerShell을 사용하여 확인
powershell -Command "& {
    Import-Module WebAdministration;
    $sites = Get-WebSite;
    foreach ($site in $sites) {
        $siteName = $site.Name;
        $configPath = 'IIS:\Sites\' + $siteName;
        $maxAllowedContentLength = (Get-WebConfigurationProperty -pspath $configPath -filter 'system.webServer/security/requestFiltering/requestLimits' -name 'maxAllowedContentLength').Value;
        $maxSizeMB = $maxAllowedContentLength / 1024 / 1024;
        if ($maxSizeMB -le 100) { # 가정된 제한값 100MB
            Add-Content '!TMP1!' ('OK: ' + $siteName + '은(는) 파일 업로드를 ' + $maxSizeMB + ' MB로 제한합니다.');
        } else {
            Add-Content '!TMP1!' ('WARN: ' + $siteName + '은(는) 파일 업로드 제한이 ' + $maxSizeMB + ' MB로 설정되어 있지 않습니다.');
        }
    }
}"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.
