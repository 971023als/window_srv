# function.sh와 동일한 PowerShell 함수 파일을 포함해야 함
. .\function.ps1

$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-059] 웹 서비스 서버 명령 실행 기능 제한 설정 미흡"

$result = "결과 파일 경로 지정 필요"
Add-Content -Path $result -Value "[양호]: 웹 서비스에서 서버 명령 실행 기능이 적절하게 제한된 경우"
Add-Content -Path $result -Value "[취약]: 웹 서비스에서 서버 명령 실행 기능의 제한이 미흡한 경우"

BAR

# Apache 또는 Nginx 웹 서비스의 서버 명령 실행 제한 설정 확인
$APACHE_CONFIG_FILE = "/etc/apache2/apache2.conf"
$NGINX_CONFIG_FILE = "/etc/nginx/nginx.conf"

# Apache에서 서버 명령 실행 제한 확인
If ((Select-String -Path $APACHE_CONFIG_FILE -Pattern "^\s*ScriptAlias" -Quiet)) {
    WARN "Apache에서 서버 명령 실행이 허용될 수 있습니다: $APACHE_CONFIG_FILE"
} Else {
    OK "Apache에서 서버 명령 실행 기능이 적절하게 제한됩니다: $APACHE_CONFIG_FILE"
}

# Nginx에서 FastCGI 스크립트 실행 제한 확인
If ((Select-String -Path $NGINX_CONFIG_FILE -Pattern "fastcgi_pass" -Quiet)) {
    WARN "Nginx에서 FastCGI를 통한 서버 명령 실행이 허용될 수 있습니다: $NGINX_CONFIG_FILE"
} Else {
    OK "Nginx에서 FastCGI를 통한 서버 명령 실행 기능이 적절하게 제한됩니다: $NGINX_CONFIG_FILE"
}

Get-Content -Path $result

Write-Host "`n"
