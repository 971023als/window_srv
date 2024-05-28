@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Anonymous FTP access analysis
set "csvFile=!resultDir!\Anonymous_FTP_Access.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-013"
set "riskLevel=중"
set "diagnosisItem=Anonymous FTP 접속 제한 설정 검사"
set "diagnosisResult="
set "status="

:: 익명 FTP 접속 제한 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $FtpSites = Get-WebSite | Where-Object { $_.bindings -match 'ftp' };
    $results = '';
    foreach ($site in $FtpSites) {
        $siteName = $site.name;
        $FtpSettings = Get-WebConfigurationProperty -filter '/system.applicationHost/sites/site[@name='"'$siteName'"']/ftpServer/security/authorization' -PSPath 'MACHINE/WEBROOT/APPHOST' -name '.';
        $AnonymousAccess = $FtpSettings.Collection | Where-Object { $_.accessType -eq 'Allow' -and $_.users -eq 'anonymous' };
        if ($AnonymousAccess) {
            $results += 'FTP site: ' + $siteName + ' allows anonymous access; ';
        } else {
            $results += 'FTP site: ' + $siteName + ' blocks anonymous access; ';
        }
    }
    if ($results -eq '') {
        $results = 'No FTP sites found or they do not allow anonymous access.'
    }
    \"$results\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!diagnosisResult!","!status!" >> "!csvFile!"

REM Display the CSV content
type "!csvFile!"
echo

endlocal
