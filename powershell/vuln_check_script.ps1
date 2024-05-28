# 현재 스크립트의 이름을 기반으로 로그 파일 이름을 설정합니다.
$scriptName = $MyInvocation.MyCommand.Name
$logFile = "$scriptName.log"

# 로그 파일 초기화
"" > $logFile

# 001부터 174까지 순회하면서 파일명 생성 및 실행
1..174 | ForEach-Object {
    $number = $_.ToString("000")
    $filename = "SRV-$number.ps1"
    Add-Content $logFile -Value "Executing $filename"
    
    # 파일이 존재하면 실행
    if (Test-Path $filename) {
        & .\$filename
    }
}

Add-Content $logFile ""
Add-Content $logFile "================================ 진단 결과 요약 ================================"
Add-Content $logFile ""
Add-Content $logFile "                              ★ 항목 개수 = $(Select-String -Path $logFile -Pattern '결과 : ' | Measure-Object).Count"
Add-Content $logFile "                              ☆ 취약 개수 = $(Select-String -Path $logFile -Pattern '결과 : OK' | Measure-Object).Count"
Add-Content $logFile "                              ★ 양호 개수 = $(Select-String -Path $logFile -Pattern '결과 : WARN' | Measure-Object).Count"
Add-Content $logFile "                              ☆ N/A 개수 = $(Select-String -Path $logFile -Pattern '결과 : N/A' | Measure-Object).Count"
Add-Content $logFile ""
Add-Content $logFile "=============================================================================="
Add-Content $logFile ""

