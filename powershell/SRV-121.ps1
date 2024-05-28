$TMP1 = "$(SCRIPTNAME).log"
Remove-Item -Path $TMP1 -ErrorAction Ignore
New-Item -Path $TMP1 -ItemType File

"CODE [SRV-121] root 계정의 PATH 환경변수 설정 미흡" | Out-File -FilePath $TMP1 -Append

@"
[양호]: root 계정의 PATH 환경변수가 안전하게 설정되어 있는 경우
[취약]: root 계정의 PATH 환경변수에 안전하지 않은 경로가 포함된 경우
"@ | Out-File -FilePath $TMP1 -Append

# 시스템 환경 변수 PATH 검사
$systemPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine)
$unsafePathPatterns = @(".", "::")

$containsUnsafePath = $false
foreach ($pattern in $unsafePathPatterns) {
    if ($systemPath -like "*$pattern*") {
        $containsUnsafePath = $true
        "WARN: PATH 환경 변수 내에 `"$pattern`"이(가) 포함되어 있습니다." | Out-File -FilePath $TMP1 -Append
        break
    }
}

if (-not $containsUnsafePath) {
    "OK: 시스템의 PATH 환경변수가 안전하게 설정되어 있습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1
