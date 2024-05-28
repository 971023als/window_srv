# 결과 파일 정의
$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
Remove-Item -Path $TMP1 -ErrorAction Ignore
New-Item -Path $TMP1 -ItemType File

# 시작 정보 출력
@"
CODE [SRV-123] 최종 로그인 사용자 계정 노출

[양호]: 최종 로그인 사용자 정보가 노출되지 않는 경우
[취약]: 최종 로그인 사용자 정보가 노출되는 경우
"@ | Out-File -FilePath $TMP1

# 로그온 화면에서 마지막으로 로그인한 사용자 이름 숨기기 설정 검사 및 조정
try {
    $policyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    $policyName = "DontDisplayLastUserName"
    $policyValue = Get-ItemPropertyValue -Path $policyPath -Name $policyName -ErrorAction SilentlyContinue

    if ($policyValue -eq 1) {
        "OK: 로그온 화면에서 최종 로그인 사용자 이름이 숨겨져 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        Set-ItemProperty -Path $policyPath -Name $policyName -Value 1
        "UPDATED: 로그온 화면에서 최종 로그인 사용자 이름을 숨기도록 설정되었습니다." | Out-File -FilePath $TMP1 -Append
    }
} catch {
    "ERROR: 로그온 화면 설정을 조정하는 동안 오류가 발생했습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1
