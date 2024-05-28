# 로그 파일 생성 및 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 출력
"코드 [SRV-045] 웹 서비스 프로세스 권한 제한 미비" | Out-File -FilePath $TMP1 -Append
"[양호]: 웹 서비스 프로세스가 과도한 권한으로 실행되지 않음" | Out-File -FilePath $TMP1 -Append
"[취약]: 웹 서비스 프로세스가 과도한 권한으로 실행됨" | Out-File -FilePath $TMP1 -Append

# 웹 서비스의 서비스 이름 지정 (예: Apache2.4, IIS의 경우 W3SVC)
$SERVICE_NAME = "Apache2.4"

# 서비스가 어떤 계정 아래에서 실행되고 있는지 확인
$serviceDetails = Get-WmiObject -Class Win32_Service -Filter "Name = '$SERVICE_NAME'"
$serviceStartName = $serviceDetails.StartName

# 서비스 시작 계정 정보 로그 파일에 추가
"서비스 시작 계정: $serviceStartName" | Out-File -FilePath $TMP1 -Append

# 주의 메시지 추가
"주의: 서비스 계정이 과도한 권한을 가지고 있지 않은지 수동으로 검토해 주세요." | Out-File -FilePath $TMP1 -Append

# 결과 출력
Get-Content -Path $TMP1 | Write-Host

Write-Host "`n스크립트 완료."
