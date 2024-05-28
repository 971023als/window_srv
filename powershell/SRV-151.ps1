# 결과 파일 초기화
$TMP1 = "SRV-151_AnonymousSIDNameTranslationPolicyCheck.log"
"익명 SID/이름 변환 허용 정책 확인" | Out-File -FilePath $TMP1
"====================================" | Out-File -FilePath $TMP1 -Append

# 익명 SID/이름 변환 허용 정책 확인
$policyCheck = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "DisableAnonymousSIDNameTranslation"

# 결과 분석 및 파일에 기록
if ($policyCheck.DisableAnonymousSIDNameTranslation -eq 1) {
    "익명 SID/이름 변환을 허용하지 않습니다. (정책 활성화)" | Out-File -FilePath $TMP1 -Append
} else {
    "익명 SID/이름 변환을 허용합니다. (정책 비활성화 또는 설정되지 않음)" | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 내용 출력
Get-Content -Path $TMP1 | Write-Output
