# 결과 파일 정의
$TMP1 = "SCRIPTNAME.log"
Remove-Item -Path $TMP1 -ErrorAction Ignore
New-Item -Path $TMP1 -ItemType File

# 시작 정보 출력
@"
CODE [SRV-127] 계정 잠금 임계값 설정 미비

[양호]: 계정 잠금 임계값이 적절하게 설정된 경우
[취약]: 계정 잠금 임계값이 적절하게 설정되지 않은 경우
"@ | Out-File -FilePath $TMP1

# 계정 잠금 정책 조회
$accountLockoutThreshold = secedit /export /cfg "$env:TEMP\secpol.cfg" | Out-Null
$secpol = Get-Content -Path "$env:TEMP\secpol.cfg"
$lockoutThreshold = $secpol | Where-Object { $_ -match "LockoutBadCount" } | ForEach-Object { $_.Split('=')[1].Trim() }

# 정책 평가 및 결과 출력
if ($lockoutThreshold -eq "0") {
    "WARN: 계정 잠금 임계값이 설정되지 않았습니다." | Out-File -FilePath $TMP1 -Append
} elseif ($lockoutThreshold -le "10") {
    "OK: 계정 잠금 임계값이 적절하게 설정되어 있습니다. 임계값: $lockoutThreshold" | Out-File -FilePath $TMP1 -Append
} else {
    "WARN: 계정 잠금 임계값이 권장 값보다 높게 설정되어 있습니다. 임계값: $lockoutThreshold" | Out-File -FilePath $TMP1 -Append
}

# 임시 파일 정리
Remove-Item -Path "$env:TEMP\secpol.cfg" -ErrorAction Ignore

# 결과 파일 출력
Get-Content -Path $TMP1
