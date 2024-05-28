# 로그 파일 경로 설정 및 초기화
$TMP1 = "$env:SCRIPTNAME.log"
"" | Out-File -FilePath $TMP1

# 로그 파일에 내용 추가
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-138] 백업 및 복구 권한 설정 미흡" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 백업 및 복구 권한이 적절히 설정된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 백업 및 복구 권한이 적절히 설정되지 않은 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# 백업 디렉토리 경로 설정
$backupDir = "C:\Backup"

# 디렉토리 존재 여부 확인 및 권한 분석
if (Test-Path -Path $backupDir) {
    $acl = Get-Acl -Path $backupDir
    $acl.Access | Out-File -FilePath $TMP1 -Append
    "권한 분석 결과는 $TMP1 파일을 참조하세요." | Out-File -FilePath $TMP1 -Append
} else {
    "INFO: $backupDir 디렉토리가 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Out-Host
