@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for file system type status analysis
set "csvFile=!resultDir!\FileSystem_Type_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-128"
set "riskLevel=낮음"
set "diagnosisItem=NTFS 파일 시스템 사용 여부 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-128] NTFS 파일 시스템 미사용 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: NTFS 파일 시스템이 사용되지 않는 경우 >> "!TMP1!"
echo [취약]: NTFS 파일 시스템이 사용되는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: NTFS 파일 시스템 사용 여부 확인 (PowerShell 사용)
powershell -Command "& {
    $drives = Get-Volume | Where-Object { $_.FileSystem -eq 'NTFS' }
    if ($drives) {
        $status = 'WARN: 다음 드라이브에서 NTFS 파일 시스템이 사용되고 있습니다: '
        foreach ($drive in $drives) {
            $status += '드라이브 ' + $drive.DriveLetter + ': ' + $drive.FileSystem + '; '
        }
    } else {
        $status = 'OK: NTFS 파일 시스템이 사용되지 않습니다.'
    }
    \"$status\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo Script complete.

endlocal
