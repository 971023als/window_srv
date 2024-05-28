# 스크립트 이름 정의 및 로그 파일 경로 설정
$ScriptName = "SCRIPTNAME"
$TMP1 = "$ScriptName.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 정보 출력
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-144] 불필요한 파일 존재 여부 확인" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 지정된 경로에 불필요한 파일이 존재하지 않는 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 지정된 경로에 불필요한 파일이 존재하는 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# 지정된 디렉토리 설정
$targetDir = "C:\Windows\Temp"

# 파일 수 확인
$fileCount = (Get-ChildItem -Path $targetDir -File).Count

if ($fileCount -gt 0) {
    "WARN: $targetDir 디렉토리에 $fileCount 개의 불필요한 파일이 존재합니다." | Out-File -FilePath $TMP1 -Append
} else {
    "OK: $targetDir 디렉토리에 불필요한 파일이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Write-Output
