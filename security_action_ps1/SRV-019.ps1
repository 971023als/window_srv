# 관리자 권한으로 스크립트 실행 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process powershell.exe "-File",($MyInvocation.MyCommand.Definition) -Verb RunAs
    exit
}

# 환경 설정
$computerName = $env:COMPUTERNAME
$resultDir = "C:\Window_${computerName}_Security_Check"

# 기존 디렉터리 삭제 및 새 디렉터리 생성
Remove-Item -Path $resultDir -Force -Recurse -ErrorAction SilentlyContinue
New-Item -Path $resultDir -ItemType Directory -Force

# 로컬 보안 정책 및 시스템 정보 수집
secedit /export /cfg "$resultDir\Local_Security_Policy.cfg"
systeminfo | Out-File "$resultDir\SystemInfo.txt"

# IIS 설정 수집
if (Test-Path $env:windir\System32\inetsrv\config\applicationHost.config) {
    Copy-Item $env:windir\System32\inetsrv\config\applicationHost.config -Destination "$resultDir\IIS_Config.xml"
}

# 하드디스크 기본 공유 진단
$defaultShares = Get-SmbShare | Where-Object { $_.Name -match '^[C-Z]\$$' }
foreach ($share in $defaultShares) {
    "$($share.Name) default share exists." | Out-File "$resultDir\Default_Shares.txt" -Append
}

# AutoShareServer 및 AutoShareWks 레지스트리 값 확인 및 조정
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$autoShareWks = Get-ItemPropertyValue -Path $regPath -Name "AutoShareWks" -ErrorAction SilentlyContinue
$autoShareServer = Get-ItemPropertyValue -Path $regPath -Name "AutoShareServer" -ErrorAction SilentlyContinue

If ($autoShareWks -eq 1) {
    Set-ItemProperty -Path $regPath -Name "AutoShareWks" -Value 0
    "AutoShareWks was enabled and has been disabled." | Out-File "$resultDir\AutoShareSettings.txt" -Append
}

If ($autoShareServer -eq 1) {
    Set-ItemProperty -Path $regPath -Name "AutoShareServer" -Value 0
    "AutoShareServer was enabled and has been disabled." | Out-File "$resultDir\AutoShareSettings.txt" -Append
}

# SMTP 서비스 실행 여부 확인 및 조치
$smtpService = Get-Service -Name "SMTPSVC" -ErrorAction SilentlyContinue
if ($smtpService -and $smtpService.Status -eq 'Running') {
    Stop-Service -Name "SMTPSVC" -Force
    "SMTP Service was running and has been stopped." | Out-File "$resultDir\SMTP_Service.txt" -Append
} else {
    "SMTP Service is not running." | Out-File "$resultDir\SMTP_Service.txt" -Append
}
