# 결과 파일 정의 및 초기화
$ScriptName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
$TMP1 = "$ScriptName.log"
"" | Set-Content -Path $TMP1

# 헤더 정보 출력
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-161] ftpusers 파일의 소유자 및 권한 설정 미흡" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: ftpusers 파일의 소유자가 root이고, 권한이 644 이하인 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: ftpusers 파일의 소유자가 root가 아니거나, 권한이 644 이상인 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# 파일 경로 설정 - 실제 경로로 변경 필요
$file_path = "C:\path\to\your\file.txt"

# 파일 존재 여부 확인
if (-not (Test-Path -Path $file_path)) {
    "WARN: 지정된 파일이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    # 파일 권한 확인 (icacls 사용)
    "파일 권한:" | Out-File -FilePath $TMP1 -Append
    icacls $file_path | Out-File -FilePath $TMP1 -Append
    # 실제 권한 분석 및 조건 비교 로직은 여기에 구현
}

# 결과 출력
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
Get-Content -Path $TMP1 | Write-Output

Write-Host "`nScript complete."
