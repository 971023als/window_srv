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

CODE "[SRV-021] FTP 서비스 접근 제어 설정 미비"

@"
[양호]: FTP 서비스에서 적절한 접근 제어가 설정된 경우
[취약]: FTP 서비스에서 접근 제어가 미비한 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# IIS FTP 서비스 접근 제어 설정 점검
$ftpSites = Get-WebSite | Where-Object { $_.bindings.Collection -match "ftp" }

if ($ftpSites.Count -eq 0) {
    INFO "FTP 서비스가 설치되지 않았거나 활성화되지 않았습니다." | Out-File -FilePath $TMP1 -Append
} else {
    foreach ($site in $ftpSites) {
        $siteName = $site.Name
        $ftpAuthorizationRules = Get-WebConfiguration -Filter "system.ftpServer/security/authorization" -PSPath "IIS:\Sites\$siteName"
        if ($ftpAuthorizationRules.Collection.Count -eq 0) {
            WARN "FTP 사이트 '$siteName'에 접근 제어 규칙이 설정되지 않았습니다." | Out-File -FilePath $TMP1 -Append
        } else {
            OK "FTP 사이트 '$siteName'에 접근 제어 규칙이 설정되었습니다." | Out-File -FilePath $TMP1 -Append
        }
    }
}

BAR

Get-Content $TMP1 | Write-Output
