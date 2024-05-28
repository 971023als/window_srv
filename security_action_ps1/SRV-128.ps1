# 결과 파일 정의
$TMP1 = "$(Get-Location)\SCRIPTNAME.log"
Remove-Item -Path $TMP1 -ErrorAction Ignore
New-Item -Path $TMP1 -ItemType File

# 시작 정보 출력
@"
CODE [SRV-128] NTFS 파일 시스템 사용 권장

[양호]: 모든 드라이브가 NTFS 파일 시스템을 사용하는 경우
[취약]: 하나 이상의 드라이브가 NTFS 파일 시스템을 사용하지 않는 경우
"@ | Out-File -FilePath $TMP1

# 모든 드라이브의 파일 시스템 사용 여부 확인
$drives = Get-Volume

$nonNtfsDrives = $drives | Where-Object { $_.FileSystem -ne "NTFS" }

if ($nonNtfsDrives) {
    foreach ($drive in $nonNtfsDrives) {
        "WARN: NTFS 파일 시스템을 사용하지 않고 있습니다: Drive $($drive.DriveLetter) - $($drive.FileSystem)" | Out-File -FilePath $TMP1 -Append
    }
} else {
    "OK: 모든 드라이브가 NTFS 파일 시스템을 사용합니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1
