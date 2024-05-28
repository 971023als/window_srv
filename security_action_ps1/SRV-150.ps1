# 결과 로그 파일 경로 정의
$ScriptName = $MyInvocation.MyCommand.Name.Replace(".ps1", "")
$TMP1 = "$ScriptName.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 헤더 정보 추가
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-150] 로컬 로그온 허용" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 웹 서버에서 버전 정보 및 운영체제 정보 노출이 제한된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 웹 서버에서 버전 정보 및 운영체제 정보가 노출되는 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# IIS 서버 설정 확인
Import-Module WebAdministration

$removeServerHeader = (Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter 'system.webServer/security/requestFiltering' -name '.').removeServerHeader
$xPoweredByHeader = (Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter 'system.webServer/httpProtocol/customHeaders' -name '.').collection | Where-Object { $_.name -eq 'X-Powered-By' }

if($removeServerHeader -eq $true) {
    "OK: 서버 헤더 제거가 활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "WARN: 서버 헤더 제거가 활성화되어 있지 않습니다." | Out-File -FilePath $TMP1 -Append
}

if($xPoweredByHeader) {
    "WARN: X-Powered-By 헤더가 노출됩니다." | Out-File -FilePath $TMP1 -Append
} else {
    "OK: X-Powered-By 헤더 노출이 제한됩니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 출력
Get-Content -Path $TMP1 | Write-Output

Write-Host "Script complete."
