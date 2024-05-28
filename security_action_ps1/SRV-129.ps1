# 결과 파일 정의
$TMP1 = "$(Get-Location)\SCRIPTNAME.log"
Remove-Item -Path $TMP1 -ErrorAction Ignore
New-Item -Path $TMP1 -ItemType File

# 시작 정보 출력
@"
CODE [SRV-129] 백신 프로그램 미설치

[양호]: 백신 프로그램이 설치되어 있는 경우
[취약]: 백신 프로그램이 설치되어 있지 않은 경우
"@ | Out-File -FilePath $TMP1

# Windows 보안 센터를 통해 백신 상태 확인
$AntivirusStatus = Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct

if ($AntivirusStatus) {
    $installedAntivirus = $AntivirusStatus.displayName
    "OK: 설치된 백신 프로그램: $installedAntivirus" | Out-File -FilePath $TMP1 -Append
} else {
    "WARN: 설치된 백신 프로그램이 없습니다." | Out-File -FilePath $TMP1 -Append
    "ACTION: 안전한 컴퓨터 사용을 위해, Microsoft Defender를 활성화하거나, 신뢰할 수 있는 백신 프로그램을 설치하세요." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1
