# 스크립트 이름 정의 및 로그 파일 경로 설정
$ScriptName = "SCRIPTNAME"
$TMP1 = "$ScriptName.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 정보 출력
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-140] 이동식 미디어 포맷 및 꺼내기 허용 정책 설정 미흡" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 이동식 미디어의 포맷 및 꺼내기에 대한 사용 정책이 적절하게 설정되어 있는 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 이동식 미디어의 포맷 및 꺼내기에 대한 사용 정책이 설정되어 있지 않은 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# 이동식 미디어의 자동 재생 설정 확인
$autoPlay = Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoDriveTypeAutoRun' -ErrorAction SilentlyContinue
if ($autoPlay -and $autoPlay.NoDriveTypeAutoRun -ne $null) {
    if ($autoPlay.NoDriveTypeAutoRun -eq 255) {
        "OK: 이동식 미디어의 자동 재생이 비활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "WARN: 일부 이동식 미디어의 자동 재생이 활성화되어 있을 수 있습니다." | Out-File -FilePath $TMP1 -Append
    }
} else {
    "INFO: 자동 재생 설정이 레지스트리에 명시적으로 설정되어 있지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Write-Output
