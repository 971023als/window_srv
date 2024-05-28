# 결과 파일 정의
$TMP1 = "$(SCRIPTNAME).log"
Remove-Item -Path $TMP1 -ErrorAction Ignore
New-Item -Path $TMP1 -ItemType File

# 시작 정보 출력
@"
CODE [SRV-125] 화면보호기 미설정

[양호]: 화면보호기가 설정되어 있는 경우
[취약]: 화면보호기가 설정되어 있지 않은 경우
"@ | Out-File -FilePath $TMP1

# 화면보호기 설정 확인
$screenSaverStatus = Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name ScreenSaveActive

if ($screenSaverStatus.ScreenSaveActive -eq "1") {
    "OK: 화면보호기가 설정되어 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "WARN: 화면보호기가 설정되어 있지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1
