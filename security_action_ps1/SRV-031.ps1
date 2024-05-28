# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 구분자
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-031] 계정 목록 및 네트워크 공유 이름 노출" | Out-File -FilePath $TMP1 -Append
@"
[양호]: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 노출되지 않는 경우
[취약]: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 노출되는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# 네트워크 공유의 열거 제한 설정 확인
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters'
$restrictNullSessAccess = Get-ItemPropertyValue -Path $registryPath -Name 'RestrictNullSessAccess' -ErrorAction SilentlyContinue
if ($null -ne $restrictNullSessAccess -and $restrictNullSessAccess -eq 1) {
    'OK: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 적절하게 보호되고 있습니다.' | Out-File -FilePath $TMP1 -Append
} else {
    'WARN: SMB 서비스에서 계정 목록 또는 네트워크 공유 이름이 노출될 수 있습니다.' | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content -Path $TMP1 | Write-Host
