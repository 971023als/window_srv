# 결과 파일 정의
$TMP1 = "$(SCRIPTNAME).log"
Remove-Item -Path $TMP1 -ErrorAction Ignore
New-Item -Path $TMP1 -ItemType File

# 시작 정보 출력
@"
CODE [SRV-123] 최종 로그인 사용자 계정 노출

[양호]: 최종 로그인 사용자 정보가 노출되지 않는 경우
[취약]: 최종 로그인 사용자 정보가 노출되는 경우
"@ | Out-File -FilePath $TMP1

# Windows에서는 로그온 메시지를 그룹 정책을 통해 설정합니다.
# 이 스크립트는 로그온 메시지 설정을 검사합니다.
try {
    $logonMessage = Get-GPOReport -All -ReportType Xml | Select-String -Pattern "InteractiveLogon_MessageTitleForUsersAttemptingToLogOn"

    if ($logonMessage -ne $null) {
        "OK: 로그온 메시지가 설정되어 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "WARN: 로그온 메시지가 설정되지 않았습니다." | Out-File -FilePath $TMP1 -Append
    }
} catch {
    "INFO: 그룹 정책 설정을 검사하는 동안 오류가 발생했습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1
