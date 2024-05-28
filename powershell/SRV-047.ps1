# 로그 파일 생성 및 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 출력
"코드 [SRV-047] 웹 서비스 경로 내 불필요한 링크 파일 존재" | Out-File -FilePath $TMP1 -Append
"[양호]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재하지 않음" | Out-File -FilePath $TMP1 -Append
"[취약]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재함" | Out-File -FilePath $TMP1 -Append

# IIS 웹 서비스 경로 설정
$IIS_WEB_SERVICE_PATH = "C:\inetpub\wwwroot"

# IIS 웹 서비스 경로 내 심볼릭 링크(.lnk 및 기타 링크 파일) 검색
"$( $IIS_WEB_SERVICE_PATH ) 내 심볼릭 링크 파일 검사 중:" | Out-File -FilePath $TMP1 -Append
Get-ChildItem -Path $IIS_WEB_SERVICE_PATH -Filter "*.lnk" -Recurse | Select-Object -ExpandProperty FullName | Out-File -FilePath $TMP1 -Append
Get-ChildItem -Path $IIS_WEB_SERVICE_PATH -Filter "*.url" -Recurse | Select-Object -ExpandProperty FullName | Out-File -FilePath $TMP1 -Append

# 관리자에게의 주의사항
"주의: 이 스크립트는 .lnk 및 .url 바로가기 파일을 나열합니다. 수동으로 검토하여 필요한 파일인지 확인해 주세요." | Out-File -FilePath $TMP1 -Append

# 결과 표시
Get-Content -Path $TMP1 | Write-Output

Write-Host "`n스크립트 완료."
