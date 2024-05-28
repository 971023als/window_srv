# 결과 파일 정의
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_RemovableMediaPolicy.log"

# 레지스트리 경로 및 키 정의
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices"
$denyAll = Get-ItemProperty -Path $registryPath -Name "Deny_All" -ErrorAction SilentlyContinue

# 이동식 미디어 정책 설정 확인
if ($null -ne $denyAll) {
    if ($denyAll.Deny_All -eq 1) {
        "OK: 이동식 미디어의 포맷 및 꺼내기에 대한 사용 정책이 적절하게 설정되어 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "WARN: 이동식 미디어의 포맷 및 꺼내기에 대한 사용 정책이 설정되어 있지 않은 경우." | Out-File -FilePath $TMP1 -Append
    }
} else {
    "INFO: 이동식 미디어에 대한 정책 설정이 레지스트리에 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1
