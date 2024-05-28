@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for FTP access control analysis
set "csvFile=!resultDir!\FTP_Access_Control.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-021"
set "riskLevel=중"
set "diagnosisItem=FTP 서비스 접근 제어 설정 검사"
set "diagnosisResult="
set "status="

:: FTP 서비스 사용자 접근 제어 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $FtpSites = Get-WebSite | Where-Object { $_.bindings -match 'ftp' };
    $result = '';
    foreach ($site in $FtpSites) {
        $siteName = $site.name;
        $FtpAuthorizationRules = Get-WebConfigurationProperty -filter '/system.ftpServer/security/authorization' -PSPath 'IIS:\Sites\'$siteName -name '.collection';
        if ($FtpAuthorizationRules) {
            foreach ($rule in $FtpAuthorizationRules) {
                if ($rule.Permissions -match 'Read, Write' -and $rule.Users -match 'anonymous') {
                    $result += 'WARN: ' + $siteName + ' FTP site allows read/write access to anonymous; '
                } else {
                    $result += 'OK: ' + $siteName + ' FTP site has appropriate access controls; '
                }
            }
        } else {
            $result += 'INFO: ' + $siteName + ' FTP site has no defined permission rules; '
        }
    }
    if ($result -eq '') {
        $result = 'No FTP sites found or they do not match specified conditions.'
    }
    \"$result\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!diagnosisResult!","!status!" >> "!csvFile!"

REM Display the CSV content
type "!csvFile!"
echo

endlocal
