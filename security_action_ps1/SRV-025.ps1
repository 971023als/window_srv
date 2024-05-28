# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Set-Content -FilePath $TMP1

# 메시지 구분자
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-025] 취약한 hosts.equiv 또는 .rhosts 설정 존재" | Out-File -FilePath $TMP1 -Append
@"
[양호]: hosts.equiv 및 .rhosts 파일이 없거나, 안전하게 구성된 경우
[취약]: hosts.equiv 또는 .rhosts 파일에 취약한 설정이 있는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# hosts.equiv 및 .rhosts 파일 점검 (Windows 환경에서는 일반적으로 적용되지 않으나, 가정용 스크립트)
$HostsEquivPath = "C:\hosts.equiv"
$RhostsPath = "C:\.rhosts"
$FilesToCheck = @($HostsEquivPath, $RhostsPath)
foreach ($file in $FilesToCheck) {
    if (Test-Path $file) {
        Add-Content $TMP1 "WARN: 취약한 파일 설정 존재: $file"
    } else {
        Add-Content $TMP1 "OK: 취약한 파일($file)이 존재하지 않습니다."
    }
}

BAR

# SSH 보안 설정 확인 (가정된 경로와 설정)
$SshdConfigPath = 'C:\ProgramData\ssh\sshd_config'
if (Test-Path $SshdConfigPath) {
    $ConfigContent = Get-Content $SshdConfigPath
    $SecureSettings = @('PermitEmptyPasswords no', 'PasswordAuthentication yes')
    foreach ($setting in $SecureSettings) {
        if (-not ($ConfigContent -contains $setting)) {
            Add-Content $TMP1 "WARN: SSH 설정에서 보안이 미흡한 설정 발견: $setting"
        }
    }
} else {
    Add-Content $TMP1 'INFO: SSH 구성 파일(sshd_config)이 존재하지 않습니다.'
}

BAR

# 결과 출력
Get-Content $TMP1 | Write-Host
