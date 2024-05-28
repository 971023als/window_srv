# 결과 파일 정의
$TMP1 = "SCRIPTNAME.log"
Remove-Item -Path $TMP1 -ErrorAction Ignore
New-Item -Path $TMP1 -ItemType File

# 시작 정보 출력
@"
CODE [SRV-128] NTFS 파일 시스템 미사용

[양호]: NTFS 파일 시스템이 사용되지 않는 경우
[취약]: NTFS 파일 시스템이 사용되는 경우
"@ | Out-File -FilePath $TMP1

# NTFS 파일 시스템 사용 여부 확인
$ntfsDrives = Get-Volume | Where-Object { $_.FileSystem -eq "NTFS" }

if ($ntfsDrives) {
    foreach ($drive in $ntfsDrives) {
        "WARN: NTFS 파일 시스템이 사용되고 있습니다: Drive $($drive.DriveLetter)" | Out-File -FilePath $TMP1 -Append
    }
} else {
    "OK: NTFS 파일 시스템이 사용되지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1
