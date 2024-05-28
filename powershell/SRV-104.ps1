$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-104] 보안 채널 데이터 디지털 암호화 또는 서명 기능 비활성화"

Add-Content -Path $TMP1 -Value "[양호]: 보안 채널 데이터의 디지털 암호화 및 서명 기능이 활성화되어 있는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 보안 채널 데이터의 디지털 암호화 및 서명 기능이 비활성화되어 있는 경우"

BAR

# SMB 서버 서명 설정 확인
$serverSigning = Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "RequireSecuritySignature" -ErrorAction SilentlyContinue

# SMB 클라이언트 서명 설정 확인
$clientSigning = Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" -Name "RequireSecuritySignature" -ErrorAction SilentlyContinue

# 결과 평가 및 출력
if ($serverSigning -eq 1 -and $clientSigning -eq 1) {
    Add-Content -Path $TMP1 -Value "OK: SMB 서버 및 클라이언트의 디지털 서명 기능이 모두 활성화되어 있습니다."
} else {
    if ($serverSigning -ne 1) {
        Add-Content -Path $TMP1 -Value "WARN: SMB 서버의 디지털 서명 기능이 비활성화되어 있습니다."
    }
    if ($clientSigning -ne 1) {
        Add-Content -Path $TMP1 -Value "WARN: SMB 클라이언트의 디지털 서명 기능이 비활성화되어 있습니다."
    }
}

Get-Content -Path $TMP1

Write-Host "`n"
