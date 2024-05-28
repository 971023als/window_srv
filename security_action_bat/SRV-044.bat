@echo off
setlocal enabledelayedexpansion

:: 로그 파일 이름 설정
set "TMP1=%~n0.log"
:: 로그 파일 초기화
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-044] 웹 서비스 파일 업로드 및 다운로드 크기 제한 미설정 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"
echo [양호]: 웹 서비스에서 파일 업로드 및 다운로드 크기가 적절하게 제한됨 >> "!TMP1!"
echo [취약]: 웹 서비스에서 파일 업로드 및 다운로드 크기가 제한되지 않음 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: PowerShell을 사용하여 IIS 설정 확인
powershell -Command "& {
    $logPath = '%TMP1%';
    Import-Module WebAdministration;
    Get-Website | ForEach-Object {
        $siteName = $_.Name;
        $configPath = 'IIS:\Sites\' + $siteName;
        $requestFiltering = Get-WebConfigurationProperty -pspath $configPath -filter 'system.webServer/security/requestFiltering/requestLimits' -name 'maxAllowedContentLength';
        
        $maxSize = $requestFiltering.Value / 1024 / 1024; # 바이트에서 MB로 변환
        if ($maxSize -lt 30) { # 예시 임계값 30MB
            Add-Content -Path $logPath -Value ('OK: ' + $siteName + ' 사이트는 파일 업로드를 ' + $maxSize + ' MB로 제한합니다.');
        } else {
            Add-Content -Path $logPath -Value ('WARN: ' + $siteName + ' 사이트는 파일 업로드 제한이 높음 (' + $maxSize + ' MB) 또는 설정되지 않음.');
        }
    };
    Get-Content -Path $logPath | Out-Host;
}"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.
