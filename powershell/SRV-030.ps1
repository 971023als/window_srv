# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$ResultDirectory = "C:\Window_${env:COMPUTERNAME}_result"
$RawDataDirectory = "C:\Window_${env:COMPUTERNAME}_raw"
$SeceditExportPath = Join-Path $RawDataDirectory "Local_Security_Policy.txt"

# 관리자 권한 확인 및 스크립트 재실행
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Start-Process powershell.exe -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 디렉터리 설정 및 초기화
Remove-Item -Path $RawDataDirectory, $ResultDirectory -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $RawDataDirectory, $ResultDirectory -ItemType Directory -Force | Out-Null

# 보안 정책 내보내기
secedit /export /cfg $SeceditExportPath

# 시스템 정보 수집
$systemInfo = systeminfo
$systemInfo | Set-Content -Path (Join-Path $RawDataDirectory "systeminfo.txt")

# IIS 설정 수집
$iisConfigPath = "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
if (Test-Path $iisConfigPath)
{
    Get-Content $iisConfigPath | Select-String "physicalPath|bindingInformation" | Set-Content -Path (Join-Path $RawDataDirectory "iis_settings.txt")
}

# SMTP 서비스 상태 확인
$smtpStatus = Get-Service -Name 'SMTP' -ErrorAction SilentlyContinue
$smtpStatus | Out-File -FilePath (Join-Path $ResultDirectory "W-Window-${env:COMPUTERNAME}-rawdata.txt")

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-030"
    위험도 = "중간"
    진단항목 = "시스템 설정 및 보안 구성"
    진단결과 = "(변수: 설정 상세)"
    현황 = @{
        SystemInfo = $systemInfo
        IISConfig = if (Test-Path $iisConfigPath) { Get-Content $iisConfigPath } else { "IIS 설정 파일 없음" }
        SMTPStatus = $smtpStatus.Status
    }
    대응방안 = "시스템 및 서비스 설정에 따른 보안 권고 사항을 적용하십시오."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
