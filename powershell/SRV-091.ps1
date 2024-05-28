$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[U-91] 불필요하게 SUID, SGID bit가 설정된 파일 존재"

Add-Content -Path $TMP1 -Value "[양호]: SUID 및 SGID 비트가 필요하지 않은 파일에 설정되지 않은 경우"
Add-Content -Path $TMP1 -Value "[취약]: SUID 및 SGID 비트가 필요하지 않은 파일에 설정된 경우"

BAR

# PowerShell은 직접적으로 SUID/SGID 비트를 검사할 수 없으므로, 이 부분은 구현 생략
# 대신, Windows 환경에서 관리자 권한을 요구하는 파일 또는 설정을 검사할 수 있는 다른 메커니즘을 고려해야 합니다.

Add-Content -Path $TMP1 -Value "OK: Windows 환경에서는 SUID/SGID 비트 개념이 직접 적용되지 않습니다."

Get-Content -Path $TMP1

Write-Host "`n"
