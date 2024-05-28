@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-048] 불필요한 웹 서비스 실행 >> "%TMP1%"
echo [양호]: 불필요한 웹 서비스가 실행되지 않음 >> "%TMP1%"
echo [취약]: 불필요한 웹 서비스가 실행됨 >> "%TMP1%"

:: IIS 웹 서비스 확인
powershell -Command "& {Import-Module WebAdministration; if ((Get-Service -Name 'W3SVC').Status -eq 'Running') { echo OK: IIS 웹 서비스가 실행 중입니다. >> '%TMP1%' } else { echo WARN: IIS 웹 서비스가 실행되지 않습니다. >> '%TMP1%' }}" 

:: IIS에서 불필요한 기본 웹사이트나 애플리케이션 확인
powershell -Command "& {Import-Module WebAdministration; $sites = Get-WebSite; $defaultSite = $sites | Where-Object { $_.Name -eq 'Default Web Site' }; if ($defaultSite) { echo 경고: 'Default Web Site'가 실행 중이며 불필요할 수 있습니다. >> '%TMP1%' } else { echo OK: 불필요한 기본 웹사이트가 실행되지 않습니다. >> '%TMP1%' }}" 

:: IIS에 설치되어 있지만 사용되지 않는 기능이 있는지 확인
powershell -Command "& {Import-Module WebAdministration; $features = Get-WindowsFeature | Where-Object { $_.Installed -and $_.Name -match 'Web-' }; if ($features) { foreach ($feature in $features) { echo INFO: 설치된 IIS 기능: $($feature.Name) >> '%TMP1%' } } else { echo OK: 추가 IIS 기능이 설치되지 않았습니다. >> '%TMP1%' }}" 

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
