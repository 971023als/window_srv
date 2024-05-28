$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-087] C 컴파일러 존재 및 권한 설정 미흡"

Add-Content -Path $TMP1 -Value "[양호]: C 컴파일러가 존재하지 않거나, 적절한 권한으로 설정된 경우"
Add-Content -Path $TMP1 -Value "[취약]: C 컴파일러가 존재하며 권한 설정이 미흡한 경우"

BAR

# C 컴파일러 위치 확인
$CompilerPath = Get-Command gcc -ErrorAction SilentlyContinue

# 컴파일러 존재 여부 및 권한 확인
if (-not $CompilerPath) {
    Add-Content -Path $TMP1 -Value "OK: C 컴파일러(gcc)가 시스템에 설치되어 있지 않습니다."
} else {
    # 권한 확인
    $CompilerPerms = (Get-Acl $CompilerPath.Source).AccessToString
    if ($CompilerPerms -match "FullControl") {
        Add-Content -Path $TMP1 -Value "OK: C 컴파일러(gcc)의 권한이 적절합니다."
    } else {
        Add-Content -Path $TMP1 -Value "WARN: C 컴파일러(gcc)의 권한이 부적절합니다."
    }
}

Get-Content -Path $TMP1

Write-Host "`n"
