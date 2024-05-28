# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-074] 불필요하거나 관리되지 않는 계정 존재 조치"
Add-Content -Path $TMP1 -Value $CODE

BAR

# 시스템에서 제거해야 할 불필요한 계정 목록
$unnecessaryAccounts = @('daemon', 'bin', 'sys', 'adm', 'listen', 'nobody', 'nobody4', 'noaccess', 'diag', 'operator', 'gopher', 'games', 'ftp', 'apache', 'httpd', 'www-data', 'mysql', 'mariadb', 'postgres', 'mail', 'postfix', 'news', 'lp', 'uucp', 'nuucp')

# 불필요한 계정 제거
foreach ($account in $unnecessaryAccounts) {
    $existingAccount = Get-LocalUser -Name $account -ErrorAction SilentlyContinue
    if ($existingAccount) {
        Remove-LocalUser -Name $account -ErrorAction SilentlyContinue
        if ($?) {
            OK "불필요한 계정이 제거되었습니다: $account"
        } else {
            WARN "불필요한 계정 제거 실패: $account"
        }
    }
}

# 관리자 그룹에서 불필요한 계정 제거
$adminGroupMembers = Get-LocalGroupMember -Group "Administrators" | ForEach-Object { $_.Name.Split('\')[-1] }
foreach ($account in $unnecessaryAccounts) {
    if ($adminGroupMembers -contains $account) {
        Remove-LocalGroupMember -Group "Administrators" -Member $account -ErrorAction SilentlyContinue
        if ($?) {
            OK "관리자 그룹(Administrators)에서 불필요한 계정이 제거되었습니다: $account"
        } else {
            WARN "관리자 그룹(Administrators)에서 불필요한 계정 제거 실패: $account"
        }
    }
}

Get-Content -Path $TMP1 | Out-Host

Write-Host "`n스크립트 완료. 불필요한 계정이 시스템에서 제거되었습니다."
