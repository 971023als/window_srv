# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 관리자 권한으로 스크립트 실행 요청
function Ensure-Admin {
    If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process powershell.exe "-File",($MyInvocation.MyCommand.Definition) -Verb RunAs
        exit
    }
}

# 환경 설정 및 데이터 수집
function Setup-Environment {
    Remove-Item -Path $rawDir, $resultDir -Force -Recurse -ErrorAction SilentlyContinue
    New-Item -Path $rawDir, $resultDir -ItemType Directory -Force

    secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
    Get-SystemInfo | Out-File "$rawDir\systeminfo.txt"
    if (Test-Path $env:windir\System32\Inetsrv\Config\applicationHost.Config) {
        Get-Content $env:windir\System32\Inetsrv\Config\applicationHost.Config | Out-File "$rawDir\iis_setting.txt"
    }
}

# 하드디스크 기본 공유 진단
function Check-DiskShares {
    $shares = Get-WmiObject -Class Win32_Share -Filter "Name='C$' OR Name='D$'"
    if ($shares) {
        @{
            SharesFound = $true
            Message = "Default shares found. Consider removing them if not needed."
            DiagnosisResult = "취약"
        }
    } else {
        @{
            SharesFound = $false
            Message = "No default shares found. This is good for security."
            DiagnosisResult = "양호"
        }
    }
}

# SMTP 서비스 실행 여부 확인
function Check-SMTPService {
    $smtpService = Get-Service -Name "SMTP" -ErrorAction SilentlyContinue
    if ($smtpService -and $smtpService.Status -eq 'Running') {
        @{
            SMTPRunning = $true
            Message = "$smtpService.DisplayName is running."
            DiagnosisResult = "취약"
        }
    } else {
        @{
            SMTPRunning = $false
            Message = "SMTP Service is not running or not installed."
            DiagnosisResult = "양호"
        }
    }
}

# JSON 데이터 구성 및 파일 저장
function Save-Results {
    $jsonData = @{
        분류 = "시스템 보안"
        코드 = "SRV-019"
        위험도 = "중간"
        진단항목 = "하드디스크 기본 공유 및 SMTP 서비스 상태"
        진단결과 = "(변수: 양호, 취약) "
        하드디스크공유현황 = (Check-DiskShares)
        SMTP서비스현황 = (Check-SMTPService)
        대응방안 = "불필요한 서비스 및 공유를 비활성화하세요."
    }
    $jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath
}

# 실행
Ensure-Admin
Setup-Environment
Save-Results

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
