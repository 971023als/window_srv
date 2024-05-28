# 결과 파일 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Set-Content $TMP1

Function BAR {
    "--------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR

"CODE [SRV-012] .netrc 파일 내 중요 정보 노출" | Out-File -FilePath $TMP1 -Append

@"
[양호]: 시스템 전체에서 .netrc 파일이 존재하지 않는 경우
[취약]: 시스템 전체에서 .netrc 파일이 존재하는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# 시스템 전체에서 .netrc 파일 찾기
$netrcFiles = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue -Filter ".netrc" -Force

if ($netrcFiles.Count -eq 0) {
    "OK: 시스템에 .netrc 파일이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    foreach ($file in $netrcFiles) {
        "WARN: .netrc 파일이 발견되었습니다. 위치: $($file.FullName)" | Out-File -FilePath $TMP1 -Append
        # 발견된 .netrc 파일 처리 예시. 실제 조치를 취하기 전에 필요한 조치를 결정하세요.
        # 예시: 파일 삭제
        # Remove-Item $file.FullName -Force
        # 예시: 안전한 위치로 파일 이동
        # Move-Item $file.FullName -Destination "안전한_디렉토리_경로"
    }
}

BAR

Get-Content $TMP1 | Write-Output
Write-Host `n
