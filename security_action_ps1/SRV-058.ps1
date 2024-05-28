Function Write-BAR {
    "-------------------------------------------------" | Out-Host
}

# 결과 메시지 출력
Write-BAR

"조치 스크립트: IIS 웹 서비스에서 불필요한 스크립트 매핑 제거" | Out-Host

Write-BAR

# IIS 웹 서비스의 스크립트 매핑 설정 변경
Import-Module WebAdministration

# IIS에서 설정된 모든 사이트의 핸들러 매핑을 확인 및 제거
$siteNames = Get-ChildItem IIS:\Sites

foreach ($site in $siteNames) {
    $handlers = Get-WebConfiguration "/system.webServer/handlers" -PSPath IIS:\Sites\$($site.Name)
    # 특정 확장자 매핑을 제거할 때는 여기서 조건을 조정하세요.
    $unnecessaryHandlers = $handlers.Collection | Where-Object { $_.path -eq "*.php" -or $_.path -eq "*.cgi" } # 예시: .php와 .cgi 확장자 매핑 확인

    foreach ($handler in $unnecessaryHandlers) {
        # 불필요한 핸들러 매핑 제거
        $handlers.Collection.Remove($handler)
        "CHANGE: $($site.Name)에서 불필요한 스크립트 매핑 $($handler.path)이 제거됨" | Out-Host
    }

    # 변경 사항 저장
    $handlers | Set-WebConfiguration "/system.webServer/handlers" -PSPath IIS:\Sites\$($site.Name)
}

Write-BAR
"모든 불필요한 스크립트 매핑이 제거되었습니다. IIS를 재시작해 주세요." | Out-Host
