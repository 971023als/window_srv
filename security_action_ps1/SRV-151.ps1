# 결과 파일 경로 설정
$ScriptName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
$TMP1 = "$ScriptName.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 헤더 정보 추가
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-151] 익명 SID/이름 변환 허용" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 익명 SID/이름 변환을 허용하지 않는 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 익명 SID/이름 변환을 허용하는 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# 보안 정책 내보내기
$secpolPath = "$env:TEMP\secpol.cfg"
secedit /export /cfg $secpolPath

# 익명 SID/이름 변환 정책 확인
$secpolContent = Get-Content -Path $secpolPath
$anonymousSidTranslationPolicy = $secpolContent -match "SeDenyNetworkLogonRight\s*=\s*S-1-1-0"

if ($anonymousSidTranslationPolicy) {
    "OK: 익명 SID/이름 변환을 허용하지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "WARN: 익명 SID/이름 변환을 허용합니다." | Out-File -FilePath $TMP1 -Append
}

# 임시 파일 정리
Remove-Item -Path $secpolPath

# 결과 파일 출력
Get-Content -Path $TMP1 | Write-Output

Write-Host "`nScript complete."
