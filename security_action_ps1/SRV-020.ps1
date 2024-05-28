# 결과 파일 초기화
$TMP1 = "$(Split-Path -Leaf $MyInvocation.MyCommand.Definition).log"
"" | Set-Content $TMP1

Function BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function CODE {
    Param ([string]$message)
    $message | Out-File -FilePath $TMP1 -Append
}

Function WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Function OK {
    Param ([string]$message)
    "OK: $message" | Out-File -FilePath $TMP1 -Append
}

Function INFO {
    Param ([string]$message)
    "INFO: $message" | Out-File -FilePath $TMP1 -Append
}

BAR

CODE "[SRV-020] 공유에 대한 접근 통제 미비"

@"
[양호]: NFS 또는 SMB/CIFS 공유에 대한 접근 통제가 적절하게 설정된 경우
[취약]: NFS 또는 SMB/CIFS 공유에 대한 접근 통제가 미비한 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# SMB 공유 접근 통제 검사
$shares = Get-SmbShare -ErrorAction SilentlyContinue | Get-SmbShareAccess

foreach ($share in $shares) {
    $everyoneAccess = $share | Where-Object { $_.AccountName -eq 'Everyone' -and $_.AccessRight -eq 'Full' }
    if ($everyoneAccess) {
        WARN "SMB/CIFS 서비스에서 'Everyone' 그룹에 대한 전체 접근 통제가 설정된 공유가 발견됨: $($share.Name)"
    } else {
        OK "SMB/CIFS 서비스에서 공유 접근 통제가 적절하게 설정됨: $($share.Name)"
    }
}

BAR

Get-Content $TMP1 | Write-Output
