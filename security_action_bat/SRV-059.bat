@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-059] 웹 서비스 파일 업로드 및 다운로드 크기 제한 미설정 >> "!TMP1!"
echo [양호]: 웹 서비스에서 파일 업로드 및 다운로드 크기가 적절하게 제한됨 >> "!TMP1!"
echo [취약]: 웹 서비스에서 파일 업로드 및 다운로드 크기가 제한되지 않음 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: IIS 웹 서비스의 각 사이트에 대한 파일 업로드 크기 제한을 PowerShell을 사용하여 확인
powershell -Command "& {
    Import-Module WebAdministration;
    $sites = Get-Website;
    foreach ($site in $sites) {
        $siteName = $site.Name;
        $configPath = 'IIS:\Sites\' + $siteName;
        $requestFiltering = Get-WebConfigurationProperty -pspath $configPath -filter 'system.webServer/security/requestFiltering/requestLimits' -name 'maxAllowedContentLength';
        
        $maxSize = $requestFiltering.Value / 1024 / 1024; # 바이트에서 MB로 변환
        if ($maxSize -le 100) { # 예시 임계값 100MB
            echo OK: "!siteName!" 사이트는 파일 업로드를 "!maxSize! MB"로 제한합니다. >> "!TMP1!"
        } else {
            echo WARN: "!siteName!" 사이트는 파일 업로드 제한이 높음 ("!maxSize! MB") 또는 설정되지 않음. >> "!TMP1!"
        }
    }
}"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.
