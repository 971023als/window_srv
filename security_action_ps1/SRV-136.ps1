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
$secpolPath = "$env:temp\secpol.cfg"
secedit /export /cfg $secpolPath > $null
$policyContent = Get-Content $secpolPath
$shutdownPolicy = $policyContent | Where-Object { $_ -match "Shutdown: Allow system to be shut down without having to log on" }

If ($shutdownPolicy -ne $null -and $shutdownPolicy.Split('=')[1].Trim() -eq "1") {
    "WARN: 시스템 종료 권한이 적절히 제한되지 않았습니다." | Out-File -FilePath $TMP1 -Append
    "ACTION REQUIRED: 로컬 보안 정책 편집기를 사용하여 'Shutdown: Allow system to be shut down without having to log on' 설정을 0으로 변경하세요." | Out-File -FilePath $TMP1 -Append
} else {
    "OK: 시스템 종료 권한이 적절히 제한되었습니다." | Out-File -FilePath $TMP1 -Append
}

# 임시 파일 정리
Remove-Item -Path $secpolPath -ErrorAction Ignore

# 결과 파일 출력
Get-Content -Path $TMP1 | Out-Host
