# 결과 파일 초기화
$TMP1 = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name) + ".log"
"" | Set-Content $TMP1

Function BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Function OK {
    Param ([string]$message)
    "OK: $message" | Out-File -FilePath $TMP1 -Append
}

BAR

"CODE [SRV-013] Anonymous 계정의 FTP 서비스 접속 제한 미비" | Out-File -FilePath $TMP1 -Append

@"
[양호]: Anonymous FTP (익명 ftp) 접속을 차단한 경우
[취약]: Anonymous FTP (익명 ftp) 접속을 차단하지 않는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# 익명 계정 접속 제한 설정 확인
$ftpUserExists = Get-Content -Path "C:\Windows\System32\drivers\etc\passwd" -ErrorAction SilentlyContinue | Where-Object { $_ -match "^(ftp|anonymous)" }

if (-not $ftpUserExists) {
    OK "Anonymous FTP (익명 ftp) 접속이 차단되었습니다."
} else {
    # FTP 설정 파일 검색
    $ftpConfFiles = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue -Filter "*.conf" | Where-Object { $_.Name -match "proftpd|vsftpd" }

    if ($ftpConfFiles.Count -eq 0) {
        WARN "FTP 설정 파일이 발견되지 않았습니다. 익명 FTP 접속 설정을 수동으로 검증해야 할 수 있습니다."
    } else {
        foreach ($file in $ftpConfFiles) {
            $content = Get-Content -Path $file.FullName -ErrorAction SilentlyContinue
            if ($file.Name -match "proftpd" -and $content -match '<Anonymous.*?>.*</Anonymous>') {
                WARN "${file.FullName} 파일에서 익명 접속(<Anonymous>) 설정이 발견되었습니다."
            } elseif ($file.Name -match "vsftpd" -and $content -match '^anonymous_enable=YES') {
                WARN "${file.FullName} 파일에서 'anonymous_enable=YES' 설정이 발견되었습니다."
            } else {
                OK "${file.FullName} 파일에서 익명 FTP 접속이 적절히 제한되었습니다."
            }
        }
    }
}

BAR

Get-Content $TMP1 | Write-Output
