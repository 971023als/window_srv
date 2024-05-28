# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Set-Content -FilePath $TMP1

# 메시지 구분자 함수
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-023] 원격 터미널 서비스의 암호화 수준 설정 미흡" | Out-File -FilePath $TMP1 -Append
@"
[양호]: SSH 서비스의 암호화 수준이 적절하게 설정된 경우
[취약]: SSH 서비스의 암호화 수준 설정이 미흡한 경우
"@ | Out-File -FilePath $TMP1 -Append
BAR

# SSH 암호화 관련 설정 확인
$SshConfigFile = 'C:\ProgramData\ssh\sshd_config'
$EncryptionSettings = @('KexAlgorithms', 'Ciphers', 'MACs')
$ConfigExists = Test-Path $SshConfigFile
if (-not $ConfigExists) {
    "WARN: SSH 구성 파일이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    $ConfigContent = Get-Content $SshConfigFile
    foreach ($setting in $EncryptionSettings) {
        $SettingConfigured = $ConfigContent | Where-Object { $_ -match "^$setting" }
        if ($SettingConfigured) {
            "OK: $SshConfigFile 파일에서 $setting 설정이 적절하게 구성되어 있습니다." | Out-File -FilePath $TMP1 -Append
        } else {
            "WARN: $SshConfigFile 파일에서 $setting 설정이 미흡합니다." | Out-File -FilePath $TMP1 -Append
        }
    }
}

BAR

# 결과 출력
Get-Content $TMP1 | Write-Output
