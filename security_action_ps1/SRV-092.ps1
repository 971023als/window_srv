function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-092] 사용자 홈 디렉터리 설정 미흡"

Add-Content -Path $global:TMP1 -Value "[양호]: 모든 사용자의 홈 디렉터리가 적절히 설정되어 있는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 하나 이상의 사용자의 홈 디렉터리가 적절히 설정되지 않은 경우"

BAR

# 사용자 프로필 디렉터리 정보 추출 및 확인
Get-WmiObject -Class Win32_UserProfile | ForEach-Object {
    $userProfile = $_
    $userSid = $userProfile.SID
    $userProfilePath = $userProfile.LocalPath

    if (-not (Test-Path $userProfilePath)) {
        # 홈 디렉터리가 없는 경우 생성
        New-Item -Path $userProfilePath -ItemType Directory -Force | Out-Null
        Add-Content -Path $global:TMP1 -Value "FIXED: 사용자 SID $userSid 에 대한 홈 디렉터리($userProfilePath)가 생성되었습니다."
    } else {
        Add-Content -Path $global:TMP1 -Value "OK: 사용자 SID $userSid 의 홈 디렉터리($userProfilePath)가 적절히 설정되었습니다."
    }
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
