# 결과 파일 정의
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_DuplicateUIDCheck.log"

# 결과 파일에 헤더 추가
"중복 UID가 부여된 계정 존재" | Out-File -FilePath $TMP1
"=================================" | Out-File -FilePath $TMP1 -Append

# /etc/passwd 파일 대응하는 Windows 시스템의 모든 사용자 계정과 그 UID(SID) 가져오기
$users = Get-WmiObject -Class Win32_UserAccount

# UID(SID) 별로 그룹화하고 중복된 항목 찾기
$duplicateUids = $users | Group-Object -Property SID | Where-Object { $_.Count -gt 1 }

# 결과 평가 및 로그 파일에 기록
if ($duplicateUids.Count -gt 0) {
    "WARN: 동일한 UID로 설정된 사용자 계정이 존재합니다." | Out-File -FilePath $TMP1 -Append
    $duplicateUids | ForEach-Object {
        $_.Group | ForEach-Object {
            "중복 UID: $($_.SID), 계정 이름: $($_.Name)" | Out-File -FilePath $TMP1 -Append
        }
    }
} else {
    "OK: 중복 UID가 부여된 계정이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 내용 출력
Get-Content -Path $TMP1 | Write-Output
