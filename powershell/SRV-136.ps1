# 로그 파일 경로 및 초기화
$TMP1 = "$env:SCRIPTNAME.log"
"" | Out-File -FilePath $TMP1

# 로그 파일에 내용 추가
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-136] 시스템 종료 권한 설정 미흡" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 시스템 종료 권한이 적절히 제한된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 시스템 종료 권한이 제한되지 않은 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# 시스템 종료 권한 정책 검사
# 주의: Get-LocalSecurityPolicy 함수는 기본적으로 PowerShell에 내장된 함수가 아니므로,
# 해당 기능을 제공하는 모듈이 필요할 수 있습니다. 아래의 스크립트는 예시로, 실제 실행을 위해서는
# 시스템 정책을 조회할 수 있는 다른 방법을 사용해야 할 수 있습니다.
$policy = secedit /export /cfg $env:temp\secpol.cfg > $null; (Get-Content $env:temp\secpol.cfg) -match "Shutdown: Allow system to be shut down without having to log on" | Out-File -FilePath $TMP1 -Append
If ($Matches[0] -ne $null -and $Matches[0].Split('=')[1].Trim() -eq "1") {
    "WARN: 시스템 종료 권한이 적절히 제한되지 않았습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "OK: 시스템 종료 권한이 적절히 제한되었습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Out-Host
