# 결과 파일 초기화
$TMP1 = "$(Get-Location)\$(($MyInvocation.MyCommand.Name).Replace('.ps1', '.log'))"
"" | Set-Content $TMP1

Function BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function CODE {
    Param ([string]$message)
    $message | Out-File -FilePath $TMP1 -Append
}

Function WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Function OK {
    Param ([string]$message)
    "OK: $message" | Out-File -FilePath $TMP1 -Append
}

BAR

CODE "[SRV-022] 계정의 비밀번호 미설정, 빈 암호 사용 관리 미흡"

@"
[양호]: 모든 계정에 비밀번호가 설정되어 있고 빈 비밀번호를 사용하는 계정이 없는 경우
[취약]: 비밀번호가 설정되지 않거나 빈 비밀번호를 사용하는 계정이 있는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# Windows 시스템에서 사용자 계정 정보를 가져와 비밀번호 정책을 확인합니다.
$emptyPasswords = 0
$accounts = Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount=True"

foreach ($account in $accounts) {
    if (-not $account.PasswordRequired) {
        WARN "비밀번호가 설정되지 않은 계정: $($account.Name)" 
        $emptyPasswords++
    } else {
        OK "비밀번호가 설정된 계정: $($account.Name)"
    }
}

# 비밀번호가 설정되지 않거나 빈 비밀번호를 사용하는 계정이 있는지 확인합니다.
if ($emptyPasswords -gt 0) {
    "[결과] 취약: 비밀번호가 설정되지 않거나 빈 비밀번호를 사용하는 계정이 존재합니다." | Out-File -FilePath $TMP1 -Append
} else {
    "[결과] 양호: 모든 계정에 비밀번호가 설정되어 있고 빈 비밀번호를 사용하는 계정이 없습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 최종 결과를 출력합니다.
Get-Content $TMP1 | Write-Output
