# 로그 파일 생성 및 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 출력
"코드 [SRV-055] 웹 서비스 설정 파일 노출" | Out-File -FilePath $TMP1 -Append
"[양호]: 웹 서비스 설정 파일이 외부에서 접근 불가능함" | Out-File -FilePath $TMP1 -Append
"[취약]: 웹 서비스 설정 파일이 외부에서 접근 가능함" | Out-File -FilePath $TMP1 -Append

# IIS 웹.config 설정 파일의 예시 경로
$IIS_CONFIG = "$env:SystemRoot\System32\inetsrv\config\applicationHost.config"

# IIS 설정 파일 권한 확인
if (Test-Path $IIS_CONFIG) {
    $acl = Get-Acl $IIS_CONFIG
    $everyoneAccess = $acl.Access | Where-Object { $_.IdentityReference -eq 'Everyone' -and $_.FileSystemRights -eq 'Read' }
    if ($null -ne $everyoneAccess) {
        "경고: IIS 설정 파일 ($IIS_CONFIG) 권한이 취약함." | Out-File -FilePath $TMP1 -Append
    } else {
        "OK: IIS 설정 파일 ($IIS_CONFIG)이 외부 접근으로부터 보호됨." | Out-File -FilePath $TMP1 -Append
    }
} else {
    "정보: IIS 설정 파일 ($IIS_CONFIG)이 존재하지 않음." | Out-File -FilePath $TMP1 -Append
}

# 결과 표시
Get-Content -Path $TMP1 | Write-Output

Write-Host "`n스크립트 완료."
