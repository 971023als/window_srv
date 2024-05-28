function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-105] 불필요한 시작프로그램 존재"

Add-Content -Path $global:TMP1 -Value "[양호]: 불필요한 시작 프로그램이 존재하지 않는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 불필요한 시작 프로그램이 존재하는 경우"

BAR

# 시스템 시작 프로그램 및 서비스 확인 및 비활성화
$startupPrograms = Get-CimInstance Win32_StartupCommand
$enabledServices = Get-WmiObject Win32_Service | Where-Object { $_.StartMode -eq "Auto" -and $_.State -eq "Running" }

# 여기서는 모든 시작 프로그램과 서비스를 나열합니다.
# 실제로는 불필요한 항목을 구체적으로 식별하고 비활성화해야 합니다.

foreach ($program in $startupPrograms) {
    # 예시: 특정 프로그램 이름을 기준으로 비활성화
    # if ($program.Caption -like "*OneDrive*") {
        # Disable the startup program
        # Add-Content -Path $global:TMP1 -Value "DISABLED: 시작 프로그램 $($program.Caption) 비활성화됨"
    # }
    Add-Content -Path $global:TMP1 -Value "의심스러운 시작 프로그램: $($program.Caption)"
}

foreach ($service in $enabledServices) {
    # 예시: 특정 서비스를 비활성화하는 조건
    # if ($service.DisplayName -like "*OneDrive*") {
        # Set-Service -Name $service.Name -StartupType Disabled
        # Add-Content -Path $global:TMP1 -Value "DISABLED: 서비스 $($service.DisplayName) 비활성화됨"
    # }
    Add-Content -Path $global:TMP1 -Value "의심스러운 서비스: $($service.DisplayName)"
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
