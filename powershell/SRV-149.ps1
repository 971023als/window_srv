# 결과 파일 경로 설정
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_DiskEncryptionCheck.log"

# 결과 파일에 헤더 추가
"디스크 볼륨 암호화 확인" | Out-File -FilePath $TMP1
"====================================" | Out-File -FilePath $TMP1 -Append

# BitLocker로 암호화된 드라이브 확인
$encryptedVolumes = Get-BitLockerVolume

if ($encryptedVolumes.Count -eq 0) {
    "WARN: 암호화된 디스크 볼륨이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    $encryptedVolumes | ForEach-Object {
        $volInfo = "볼륨: $($_.MountPoint) - 암호화 상태: $($_.ProtectionStatus)"
        "OK: 다음의 암호화된 디스크 볼륨이 존재합니다: $volInfo" | Out-File -FilePath $TMP1 -Append
    }
}

# 결과 파일 내용 출력
Get-Content -Path $TMP1 | Write-Output
