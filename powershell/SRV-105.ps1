$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-105] 불필요한 시작프로그램 존재"

Add-Content -Path $TMP1 -Value "[양호]: 불필요한 시작 프로그램이 존재하지 않는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 불필요한 시작 프로그램이 존재하는 경우"

BAR

# 시스템 시작 프로그램 및 서비스 확인
$startupPrograms = Get-CimInstance Win32_StartupCommand
$enabledServices = Get-WmiObject Win32_Service | Where-Object { $_.StartMode -eq "Auto" -and $_.State -eq "Running" }

# 불필요하거나 의심스러운 시작 프로그램 확인
foreach ($program in $startupPrograms) {
    # 알려진 안전한 서비스 목록과 비교 (가정)
    # if (-not $knownSafeServices -contains $program.Name) {
        Add-Content -Path $TMP1 -Value "의심스러운 시작 프로그램: $($program.Caption)"
    # }
}

# 불필요하거나 의심스러운 서비스 확인
foreach ($service in $enabledServices) {
    # 알려진 안전한 서비스 목록과 비교 (가정)
    # if (-not $knownSafeServices -contains $service.Name) {
        Add-Content -Path $TMP1 -Value "의심스러운 서비스: $($service.DisplayName)"
    # }
}

# 여기서는 모든 시작 프로그램과 서비스를 의심스러운 것으로 표시합니다.
# 실제 사용 시에는 `$knownSafeServices` 배열에 알려진 안전한 서비스 목록을 정의하고, 해당 조건문을 활성화하여 필터링해야 합니다.

# 필터링 로직이 활성화되지 않았으므로, 항상 아래 메시지 출력
# OK "시스템에 불필요한 시작 프로그램이 없습니다."

Get-Content -Path $TMP1

Write-Host "`n"
