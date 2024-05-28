# 결과 로그 파일 경로 정의
$ScriptName = $MyInvocation.MyCommand.Name.Replace(".ps1", "")
$TMP1 = "$ScriptName.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 정보 출력
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-149] 웹 서비스 정보 노출" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 웹 서버에서 버전 정보 및 운영체제 정보 노출이 제한된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 웹 서버에서 버전 정보 및 운영체제 정보가 노출되는 경우" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# IIS 서버 설정 확인
Import-Module WebAdministration
$customHeaders = Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter 'system.webServer/httpProtocol/customHeaders' -name '.'

$serverHeader = $customHeaders.Collection | Where-Object { $_.name -eq 'Server' }
$xPoweredByHeader = $customHeaders.Collection | Where-Object { $_.name -eq 'X-Powered-By' }

if ($serverHeader -and $xPoweredByHeader) {
    "WARN: 서버 버전 정보 및 운영체제 정보가 노출될 수 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "OK: 서버 버전 정보 및 운영체제 정보의 노출이 제한되었습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Write-Output

Write-Host "Script complete."
