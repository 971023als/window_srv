@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for .netrc file exposure analysis
set "csvFile=!resultDir!\Netrc_File_Exposure.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=보안 관리"
set "code=SRV-012"
set "riskLevel=높음"
set "diagnosisItem=.netrc 파일 존재 및 권한 검사"
set "diagnosisResult="
set "status="

:: .netrc 파일 존재 여부 및 권한 확인 (PowerShell 사용)
powershell -Command "& {
    $netrcFiles = Get-ChildItem -Path C:\ -Recurse -Filter '.netrc' -ErrorAction SilentlyContinue -Force;
    If ($netrcFiles -eq $null) {
        $result = '시스템에 .netrc 파일이 존재하지 않습니다.'
        $status = '양호'
    } Else {
        $result = '다음 위치에 .netrc 파일이 존재합니다: '
        foreach ($file in $netrcFiles) {
            $permissions = (Get-Acl $file.FullName).AccessToString;
            $result += ('권한 확인: ' + $permissions + ', 파일 경로: ' + $file.FullName + '; ')
        }
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
