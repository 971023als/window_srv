# 스크립트 이름 정의 및 로그 파일 경로 설정
$ScriptName = "SCRIPTNAME"
$TMP1 = "$ScriptName.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 정보 출력
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-142] 중복 사용자 이름이 부여된 계정 존재" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 중복 사용자 이름이 부여된 계정이 존재하지 않는 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 중복 사용자 이름이 부여된 계정이 존재하는 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# 중복 사용자 이름 확인
$users = Get-WmiObject -Class Win32_UserAccount
$duplicates = $users | Group-Object -Property Name | Where-Object { $_.Count -gt 1 }

if ($duplicates) {
    foreach ($dup in $duplicates) {
        "WARN: 중복 사용자 이름이 존재합니다: $($dup.Name)" | Out-File -FilePath $TMP1 -Append
    }
} else {
    "OK: 중복 사용자 이름이 부여된 계정이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Write-Output
