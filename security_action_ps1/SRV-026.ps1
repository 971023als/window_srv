# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Set-Content -FilePath $TMP1

# 메시지 구분자
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-026] root 계정 원격 접속 제한 미비" | Out-File -FilePath $TMP1 -Append
@"
[양호]: SSH를 통한 Administrator 계정의 원격 접속이 제한된 경우
[취약]: SSH를 통한 Administrator 계정의 원격 접속이 제한되지 않은 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# SSH 구성 파일에서 PermitRootLogin 설정 확인
$SshdConfigPath = 'C:\ProgramData\ssh\sshd_config'
if (Test-Path $SshdConfigPath) {
    $ConfigContent = Get-Content $SshdConfigPath
    $PermitRootLogin = $ConfigContent | Where-Object { $_ -match 'PermitRootLogin' }
    if ($PermitRootLogin -match 'no') {
        "OK: SSH를 통한 Administrator 계정의 원격 접속이 제한되어 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "WARN: SSH를 통한 Administrator 계정의 원격 접속 제한 설정이 미흡합니다. PermitRootLogin 설정을 'no'로 변경하세요." | Out-File -FilePath $TMP1 -Append
    }
} else {
    "INFO: OpenSSH 구성 파일(sshd_config)이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1 | Write-Host
