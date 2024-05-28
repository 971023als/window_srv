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

CODE "[SRV-018] 불필요한 하드디스크 기본 공유 활성화"

@"
[양호]: NFS 또는 SMB/CIFS의 불필요한 하드디스크 공유가 비활성화된 경우
[취약]: NFS 또는 SMB/CIFS에서 불필요한 하드디스크 기본 공유가 활성화된 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# SMB 공유 점검
$SmbShares = Get-SmbShare

foreach ($share in $SmbShares) {
    if ($share.Name -match "C\$|D\$|E\$|F\$") {
        WARN "SMB 서비스에서 불필요한 하드디스크 기본 공유가 활성화되어 있습니다: $($share.Name)"
    } else {
        OK "SMB 서비스에서 불필요한 공유가 비활성화되어 있습니다: $($share.Name)"
    }
}

# Windows에서 NFS 공유 점검 (옵션)
If (Get-WindowsFeature FS-NFS-Service).InstallState -eq "Installed" {
    INFO "NFS 서비스가 설치되어 있습니다. NFS 공유 설정을 수동으로 점검하세요."
} else {
    INFO "NFS 서비스가 설치되어 있지 않습니다."
}

BAR

Get-Content $TMP1 | Write-Output
