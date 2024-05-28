# 결과 파일 경로 설정
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_WebServerConfigCheck.log"

# 결과 파일에 헤더 추가
"웹 서버 정보 노출 설정 확인" | Out-File -FilePath $TMP1
"=================================" | Out-File -FilePath $TMP1 -Append

# 웹 서버 구성 파일 경로 지정
$webConfFiles = @("C:\path\to\.htaccess", "C:\path\to\httpd.conf", "C:\path\to\apache2.conf")

# 각 파일에 대한 설정 확인
foreach ($file in $webConfFiles) {
    if (Test-Path $file) {
        $serverTokens = Get-Content $file | Where-Object { $_ -match "ServerTokens\s+Prod" }
        $serverSignature = Get-Content $file | Where-Object { $_ -match "ServerSignature\s+Off" }
        
        if ($serverTokens -and $serverSignature) {
            "OK: $file 파일에서 ServerTokens 및 ServerSignature 설정이 적절히 구성되어 있습니다." | Out-File -FilePath $TMP1 -Append
        } else {
            if (-not $serverTokens) {
                "WARN: $file 파일에 ServerTokens Prod 설정이 없습니다." | Out-File -FilePath $TMP1 -Append
            }
            if (-not $serverSignature) {
                "WARN: $file 파일에 ServerSignature Off 설정이 없습니다." | Out-File -FilePath $TMP1 -Append
            }
        }
    }
}

# Apache 서비스 실행 여부 확인 (예시: Apache 서비스 이름이 "Apache2.4"인 경우)
$apacheService = Get-Service -Name "Apache2.4" -ErrorAction SilentlyContinue

if ($apacheService -and $apacheService.Status -eq 'Running') {
    "Apache 서비스가 실행 중입니다." | Out-File -FilePath $TMP1 -Append
    if ($webConfFiles.Where({ Test-Path $_ }).Count -eq 0) {
        "WARN: Apache 서비스를 사용하고, ServerTokens Prod, ServerSignature Off를 설정하는 파일이 없습니다." | Out-File -FilePath $TMP1 -Append
    }
} else {
    "OK: Apache 서비스가 비활성화되어 있거나, 적절한 설정이 확인되었습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 내용 출력
Get-Content -Path $TMP1 | Write-Output
