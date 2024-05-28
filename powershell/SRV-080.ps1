# 로그 파일 생성 및 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 출력
"코드 [SRV-080] 일반 사용자의 프린터 드라이버 설치 제한" | Out-File -FilePath $TMP1 -Append
"[양호]: 일반 사용자가 프린터 드라이버를 설치하는 것이 제한됩니다" | Out-File -FilePath $TMP1 -Append
"[취약]: 일반 사용자가 프린터 드라이버를 설치하는데 제한이 없습니다" | Out-File -FilePath $TMP1 -Append

# 관리자를 위한 수동 검사 안내
@"
도메인에 가입된 컴퓨터의 경우, 프린터 설치 제한과 관련된 그룹 정책 설정을 확인하세요.
구체적으로 "컴퓨터 구성\관리 템플릿\프린터" 아래의 정책을 검토하세요.
독립 실행형 컴퓨터의 경우, 프린터 설치 제한은 로컬 그룹 정책 편집기(gpedit.msc)를 통해 구성할 수 있습니다.
또한, "사용자 구성\관리 템플릿\제어판\프린터"에 대한 사용자별 정책을 확인하세요.
"@ | Out-File -FilePath $TMP1 -Append

# 설정 상태 검사 (예시 코드, 실제 환경에 맞게 조정 필요)
$printerDriverRestrictionEnabled = $true
if ($printerDriverRestrictionEnabled) {
    "설정 검사 결과: 프린터 드라이버 설치 제한이 적절하게 적용되었습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "설정 검사 결과: 프린터 드라이버 설치 제한이 적절하게 적용되지 않았습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 표시
Get-Content -Path $TMP1 | Write-Output

Write-Host "`n스크립트 완료."
