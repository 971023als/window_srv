# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-075] 유추 가능한 계정 비밀번호 존재 조치"
Add-Content -Path $TMP1 -Value $CODE

BAR

# 비밀번호 정책 강화
# 비밀번호 최소 길이를 12자로 설정
$minLength = 12
$minLengthCommand = "MinimumPasswordLength = $minLength"

# 비밀번호 복잡성 요구사항 활성화
$passwordComplexity = "PasswordComplexity = 1"

# 비밀번호 기억 길이 설정
$passwordHistorySize = "PasswordHistorySize = 24"

# 임시 파일 생성
$tempFile = "$env:TEMP\secpol.cfg"

# 현재 보안 정책 내보내기
secedit /export /cfg $tempFile

# 보안 정책 수정
(Get-Content $tempFile) -replace 'MinimumPasswordLength = \d+', $minLengthCommand `
                         -replace 'PasswordComplexity = \d', $passwordComplexity `
                         -replace 'PasswordHistorySize = \d+', $passwordHistorySize |
    Set-Content $tempFile

# 수정된 보안 정책 가져오기
secedit /configure /db secedit.sdb /cfg $tempFile /areas SECURITYPOLICY

# 임시 파일 삭제
Remove-Item $tempFile -ErrorAction SilentlyContinue

OK "비밀번호 정책이 강화되었습니다: 최소 길이 - $minLength, 복잡성 - 활성화, 기억 길이 - $passwordHistorySize"

Get-Content -Path $TMP1 | Out-Host

Write-Host "`n스크립트 완료. 비밀번호 정책이 강화되었습니다."
