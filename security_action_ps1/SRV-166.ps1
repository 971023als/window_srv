# 필요한 외부 스크립트 또는 모듈 호출 (여기서는 가정된 예시입니다)
# . .\function.ps1

# 결과 파일 정의
$TMP1 = "$env:SCRIPTNAME.log"
# 결과 파일 초기화
"" | Set-Content -Path $TMP1

# 구분선 함수
Function Bar {
    "----------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Bar

# 코드 및 상태 정보 출력
@"
CODE [SRV-166] 불필요한 숨김 파일 또는 디렉터리 존재
[양호]: 불필요한 숨김 파일 또는 디렉터리가 존재하지 않는 경우
[취약]: 불필요한 숨김 파일 또는 디렉터리가 존재하는 경우
"@ | Out-File -FilePath $TMP1 -Append

Bar

# 시스템에서 숨김 파일 및 디렉터리 검색
$hiddenFiles = Get-ChildItem -Path "C:\" -Recurse -File -Hidden -ErrorAction SilentlyContinue
$hiddenDirs = Get-ChildItem -Path "C:\" -Recurse -Directory -Hidden -ErrorAction SilentlyContinue

if ($hiddenFiles.Count -eq 0 -and $hiddenDirs.Count -eq 0) {
    "OK: 불필요한 숨김 파일 또는 디렉터리가 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    $allHidden = $hiddenFiles + $hiddenDirs
    "WARN: 다음의 불필요한 숨김 파일 또는 디렉터리가 존재합니다: $($allHidden -join ', ')" | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Write-Output

Write-Host "`nScript complete."
