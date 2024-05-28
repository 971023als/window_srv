# 스크립트 이름과 로그 파일 설정
$SCRIPTNAME = $MyInvocation.MyCommand.Name.Replace(".ps1", "")
$TMP1 = "$SCRIPTNAME.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 헤더 및 정보 추가
"BAR" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-172] 불필요한 시스템 자원 공유 존재" | Out-File -FilePath $TMP1 -Append
"[양호]: 불필요한 시스템 자원이 공유되지 않는 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 불필요한 시스템 자원이 공유되는 경우" | Out-File -FilePath $TMP1 -Append
"BAR" | Out-File -FilePath $TMP1 -Append

# Windows 공유 상태 확인
$shares = Get-SmbShare | Where-Object { $_.Name -match '^(C|D|E)\$$' }

if ($shares) {
    foreach ($share in $shares) {
        "WARN 불필요한 시스템 자원이 공유됩니다: $($share.Name)" | Out-File -FilePath $TMP1 -Append
    }
} else {
    "OK 불필요한 시스템 자원이 공유되지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Write-Output
