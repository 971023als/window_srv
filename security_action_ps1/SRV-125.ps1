# 결과 파일 정의
$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
Remove-Item -Path $TMP1 -ErrorAction Ignore
New-Item -Path $TMP1 -ItemType File

# 시작 정보 출력
@"
CODE [SRV-125] 화면보호기 미설정

[양호]: 화면보호기가 설정되어 있는 경우
[취약]: 화면보호기가 설정되어 있지 않은 경우
"@ | Out-File -FilePath $TMP1

# 화면보호기 설정 확인 및 설정
try {
    $screenSaverStatus = Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name ScreenSaveActive
    if ($screenSaverStatus.ScreenSaveActive -eq "1") {
        "OK: 화면보호기가 설정되어 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name ScreenSaveActive -Value 1
        "UPDATED: 화면보호기가 설정되었습니다." | Out-File -FilePath $TMP1 -Append
        # 추가적으로 화면보호기 대기 시간 설정 (예: 10분)
        Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name ScreenSaveTimeOut -Value 600
        # 화면보호기 실행 파일 설정 (예: Ribbons.scr)
        Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name SCRNSAVE.EXE -Value 'C:\Windows\System32\Ribbons.scr'
    }
} catch {
    "ERROR: 화면보호기 설정 상태를 확인하거나 설정하는 중 오류가 발생했습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1
