# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(SCRIPTNAME).log"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-075] 유추 가능한 계정 비밀번호 존재"

$result = "결과 파일 경로를 지정해야 함"
Add-Content -Path $result -Value "[양호]: 암호 정책이 강력하게 설정되어 있는 경우"
Add-Content -Path $result -Value "[취약]: 암호 정책이 약하게 설정되어 있는 경우"

BAR

# 비밀번호 정책 검사 (예시)
# 실제 비밀번호 정책 검사는 시스템 설정에 따라 달라질 수 있으며, 세부 구현이 필요할 수 있습니다.
# Windows 환경에서 비밀번호 정책을 직접 확인하는 방법은 제한적일 수 있습니다.

# 비밀번호 최소 길이 검사
$minLength = (secedit /export /cfg "$env:TEMP\secpol.cfg" | Out-Null; (Get-Content "$env:TEMP\secpol.cfg" | Select-String "MinimumPasswordLength" -SimpleMatch).ToString().Split('=')[1].Trim(); Remove-Item "$env:TEMP\secpol.cfg")
if ($minLength -lt 8) {
    Add-Content -Path $TMP1 -Value "WARN: 패스워드 최소 길이가 8 미만으로 설정되어 있습니다."
} else {
    Add-Content -Path $TMP1 -Value "※ U-47 결과 : 양호(Good)"
}

# 추가적인 비밀번호 정책 검사가 필요할 수 있습니다. 예를 들어, 복잡성 요구 사항, 최대/최소 사용 기간 등

Get-Content -Path $result

Write-Host "`n"
