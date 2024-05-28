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
    'WARN: 스택 영역 실행 방지가 비활성화되어 있습니다. 관리자 권한으로 시스템 설정을 확인하고 DEP 및 ASLR을 활성화하세요.' | Out-File -FilePath $TMP1 -Append
    'ACTION REQUIRED: 시스템 속성 -> 고급 시스템 설정 -> 성능 설정 -> 데이터 실행 방지에서 DEP 설정을 조정할 수 있습니다. ASLR 설정은 보안 정책을 통해 조정 가능합니다.' | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Out-Host
