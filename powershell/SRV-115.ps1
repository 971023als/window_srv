$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-115] 로그의 정기적 검토 및 보고 미수행"

Add-Content -Path $TMP1 -Value "[양호]: 로그가 정기적으로 검토 및 보고되고 있는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 로그가 정기적으로 검토 및 보고되지 않는 경우"

BAR

# 로그 검토 및 보고 스크립트 존재 여부 확인
$logReviewScriptPath = "C:\Path\To\Log\Review\Script.ps1"
if (-not (Test-Path -Path $logReviewScriptPath)) {
    Add-Content -Path $TMP1 -Value "WARN: 로그 검토 및 보고 스크립트가 존재하지 않습니다."
} else {
    Add-Content -Path $TMP1 -Value "OK: 로그 검토 및 보고 스크립트가 존재합니다."
}

# 로그 보고서 존재 여부 확인
$logReportPath = "C:\Path\To\Log\Report.txt"
if (-not (Test-Path -Path $logReportPath)) {
    Add-Content -Path $TMP1 -Value "WARN: 로그 보고서가 존재하지 않습니다."
} else {
    Add-Content -Path $TMP1 -Value "OK: 로그 보고서가 존재합니다."
}

# 결과 파일 출력
Get-Content -Path $TMP1

Write-Host "`n"
