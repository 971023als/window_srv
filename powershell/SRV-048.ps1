# 결과 파일 초기화
$TMP1 = "$(Get-Location)\SRV-048_log.txt"
"" | Set-Content $TMP1

Function Write-BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function Write-Result {
    Param ([string]$message)
    $message | Out-File -FilePath $TMP1 -Append
}

Write-BAR

@"
[양호]: 불필요한 웹 서비스가 실행되지 않고 있는 경우
[취약]: 불필요한 웹 서비스가 실행되고 있는 경우
"@ | Out-File -FilePath $TMP1 -Append

Write-BAR

# 웹 서비스 설정 파일 목록
$webconfFiles = @(".htaccess", "httpd.conf", "apache2.conf")
$serverRootDirectories = @()

# 설정 파일 검색 및 ServerRoot 디렉토리 찾기
foreach ($file in $webconfFiles) {
    $findWebconfFiles = Get-ChildItem -Path C:\ -Filter $file -Recurse -ErrorAction SilentlyContinue
    foreach ($f in $findWebconfFiles) {
        $content = Get-Content $f.FullName
        foreach ($line in $content) {
            if ($line -match "ServerRoot") {
                $serverRootDirectories += $line -replace '.*ServerRoot\s+"', '' -replace '"', ''
            }
        }
    }
}

# Apache 및 Httpd ServerRoot 설정 확인
# PowerShell에서 직접 Apache 및 Httpd 명령을 실행하여 ServerRoot를 가져오는 것은 일반적이지 않으므로, 이 부분은 실제 환경에 맞게 조정할 필요가 있습니다.

# ServerRoot 디렉토리 내 manual 디렉토리 검사
foreach ($dir in $serverRootDirectories) {
    $manualDirExists = Test-Path -Path "$dir\manual" -ErrorAction SilentlyContinue
    if ($manualDirExists) {
        Write-Result "WARN: Apache 홈 디렉터리 내 기본으로 생성되는 불필요한 파일 및 디렉터리가 제거되어 있지 않습니다."
        return
    }
}

Write-Result "OK: 결과 : 양호(Good)"

Get-Content $TMP1 | Write-Output
