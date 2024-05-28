# 로그 파일 경로 및 초기화
$TMP1 = "$env:SCRIPTNAME.log"
"" | Out-File -FilePath $TMP1

# 로그 파일에 내용 추가
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-134] 스택 영역 실행 방지 미설정" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 스택 영역 실행 방지가 활성화된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 스택 영역 실행 방지가 비활성화된 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# DEP 및 ASLR 설정 확인
$depStatus = Get-ProcessMitigation -System | Select-Object -ExpandProperty Dep
$aslrStatus = Get-ProcessMitigation -System | Select-Object -ExpandProperty Aslr

if ($depStatus.Enable -eq 'ON' -and $aslrStatus.ForceRelocateImages -eq 'ON') {
    'OK: 스택 영역 실행 방지가 활성화되어 있습니다.' | Out-File -FilePath $TMP1 -Append
} else {
    'WARN: 스택 영역 실행 방지가 비활성화되어 있습니다.' | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Out-Host
