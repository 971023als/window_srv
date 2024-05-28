# 로그 파일 경로 및 초기화
$TMP1 = "$env:SCRIPTNAME.log"
"" | Out-File -FilePath $TMP1

# 로그 파일에 내용 추가
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-135] TCP 보안 설정 미비" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 필수 TCP 보안 설정이 적절히 구성된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 필수 TCP 보안 설정이 구성되지 않은 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# TCP 관련 레지스트리 설정 확인
$paths = @(
    'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\TcpWindowSize',
    'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Tcp1323Opts',
    'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\SynAttackProtect'
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        $value = (Get-ItemProperty -Path $path)."(default)"
        "OK: $path 설정이 존재합니다: $value" | Out-File -FilePath $TMP1 -Append
    } else {
        "WARN: $path 설정이 없습니다." | Out-File -FilePath $TMP1 -Append
    }
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Out-Host
