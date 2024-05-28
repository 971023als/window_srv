Function Write-BAR {
    "-------------------------------------------------" | Out-Host
}

# 결과 메시지 출력
Write-BAR

@"
[양호]: IIS 웹 서비스에서 불필요한 스크립트 매핑이 존재하지 않는 경우
[취약]: IIS 웹 서비스에서 불필요한 스크립트 매핑이 존재하는 경우
"@ | Out-Host

Write-BAR

# IIS 웹 서비스의 스크립트 매핑 설정 확인
Import-Module WebAdministration

# IIS에서 설정된 모든 사이트의 핸들러 매핑을 확인
$siteNames = Get-ChildItem IIS:\Sites

foreach ($site in $siteNames) {
    $handlers = Get-WebConfiguration "/system.webServer/handlers" -PSPath IIS:\Sites\$($site.Name)
    $unnecessaryHandlers = $handlers.Collection | Where-Object { $_.path -eq "*.php" -or $_.path -eq "*.cgi" } # 예시: .php와 .cgi 확장자 매핑 확인

    if ($unnecessaryHandlers) {
        foreach ($handler in $unnecessaryHandlers) {
            "WARN: $($site.Name)에서 불필요한 스크립트 매핑이 발견됨: $($handler.path)" | Out-Host
        }
    } else {
        "OK: $($site.Name)에서 불필요한 스크립트 매핑이 발견되지 않음" | Out-Host
    }
}

Write-BAR
