# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 구분자 함수
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-041] 웹 서비스의 CGI 스크립트 관리 미흡" | Out-File -FilePath $TMP1 -Append

@"
[양호]: CGI 스크립트 관리가 적절하게 설정된 경우
[취약]: CGI 스크립트 관리가 미흡한 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# CGI 스크립트 실행 설정 확인 및 제거
Import-Module WebAdministration
$cgiSettings = Get-WebConfiguration -Filter '/system.webServer/handlers' -PSPath 'IIS:\'
$cgiHandlers = $cgiSettings.Collection | Where-Object { $_.path -eq '*.cgi' -or $_.path -eq '*.pl' }

if ($cgiHandlers) {
    foreach ($handler in $cgiHandlers) {
        Remove-WebConfigurationProperty -Filter '/system.webServer/handlers' -PSPath 'IIS:\' -Name '.' -AtElement @{path=$handler.path}
        "CHANGE: CGI 스크립트 ($($handler.path)) 실행이 제한되었습니다." | Out-File -FilePath $TMP1 -Append
    }
} else {
    "OK: CGI 스크립트 실행이 이미 적절하게 제한되어 있습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력 및 로그 파일 삭제
Get-Content -Path $TMP1 | Write-Host
Remove-Item $TMP1 -Force
