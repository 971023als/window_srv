# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 구분자 함수
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-042] 웹 서비스 상위 디렉터리 접근 제한 설정 미흡" | Out-File -FilePath $TMP1 -Append

@"
[양호]: DocumentRoot가 별도의 보안 디렉터리로 지정된 경우
[취약]: DocumentRoot가 기본 디렉터리 또는 민감한 디렉터리로 지정된 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# 디렉터리 접근 권한 설정 확인
Import-Module WebAdministration
$sites = Get-Website

foreach ($site in $sites) {
    $rootPath = Get-WebApplication -Site $site.Name | Select -ExpandProperty PhysicalPath
    $accessPolicy = Get-WebConfigurationProperty -pspath "IIS:\Sites\$($site.Name)" -filter "system.webServer/security/authorization" -name ".Collection"
    
    if ($accessPolicy.Count -eq 0) {
        "WARN: 웹 사이트 '$($site.Name)'에서 상위 디렉터리 접근 제한 설정이 미흡합니다. 루트 경로: $rootPath" | Out-File -FilePath $TMP1 -Append
    } else {
        "OK: 웹 사이트 '$($site.Name)'에서 상위 디렉터리 접근 제한 설정이 적절합니다. 루트 경로: $rootPath" | Out-File -FilePath $TMP1 -Append
    }
}

BAR

# 결과 출력
Get-Content -Path $TMP1 | Write-Host
