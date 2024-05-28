# function.ps1 파일 포함 (BAR, WARN, OK 함수가 정의되어 있다고 가정)
. .\function.ps1

$TMP1 = "$(Get-Location)\SRV-059_log.txt"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-059] IIS 웹 서비스 서버 명령 실행 기능 제한 설정 미흡"
Add-Content -Path $TMP1 -Value $CODE

BAR

# IIS 웹 서비스의 서버 명령 실행 제한 설정 변경
Import-Module WebAdministration

$siteNames = Get-ChildItem IIS:\Sites

foreach ($site in $siteNames) {
    $handlers = Get-WebConfiguration "/system.webServer/handlers" -PSPath IIS:\Sites\$($site.Name)
    # CGI 및 PHP 스크립트 실행을 제한하기 위해 해당 핸들러 제거
    $handlersToRemove = $handlers.Collection | Where-Object { $_.scriptProcessor -match "cgi|php" }

    foreach ($handlerToRemove in $handlersToRemove) {
        $handlers.Collection.Remove($handlerToRemove)
        WARN "제거됨: $($site.Name)에서 $($handlerToRemove.scriptProcessor) 핸들러"
    }

    # 변경 사항 저장
    if ($handlersToRemove.Count -gt 0) {
        $handlers | Set-WebConfiguration "/system.webServer/handlers" -PSPath IIS:\Sites\$($site.Name)
        OK "IIS에서 $($site.Name)에 대해 서버 명령 실행 기능이 적절하게 제한됨."
    }
}

Get-Content -Path $TMP1 | Out-Host

Write-Host "`n스크립트 완료."
