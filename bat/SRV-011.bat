@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for FTP access restriction analysis
set "csvFile=!resultDir!\FTP_Access_Restriction.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-011"
set "riskLevel=높음"
set "diagnosisItem=FTP 시스템 관리자 계정 접근 제한 설정 검사"
set "diagnosisResult="
set "status="

:: 시스템 관리자 계정의 FTP 접근 제한 여부 확인 (PowerShell 사용 예시)
powershell -Command "& {
    # IIS FTP 서비스 설정 확인 또는 Windows FTP 서비스 설정 확인
    # 예: IIS FTP 계정 접근 제한 설정 확인
    $FtpAccountRestrictions = Get-WebConfigurationProperty -filter '/system.ftpServer/security/authorization' -PSPath 'IIS:\Sites\YourFtpSiteName' -name '.collection';
    If ($FtpAccountRestrictions | Where-Object { $_.Users -match 'root' -and $_.Access -ne 'Allow' }) {
        $result = 'FTP 서비스에서 시스템 관리자(root) 계정의 접근이 제한됩니다.'
        $status = '양호'
    } Else {
        $result = 'FTP 서비스에서 시스템 관리자(root) 계정의 접근이 제한되지 않습니다.'
        $status = '취약'
    }
    \"$result, $status\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!diagnosisResult!","!status!" >> "!csvFile!"

REM Display the CSV content
type "!csvFile!"
echo

endlocal
