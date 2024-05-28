@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-012] .netrc 파일 내 중요 정보 노출 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: 시스템 전체에서 .netrc 파일이 존재하지 않는 경우 >> !TMP1!
echo [취약]: 시스템 전체에서 .netrc 파일이 존재하는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: .netrc 파일 존재 여부 및 권한 확인 (PowerShell 사용)
powershell -Command "& {
    $netrcFiles = Get-ChildItem -Path C:\ -Recurse -Filter '.netrc' -ErrorAction SilentlyContinue -Force;
    If ($netrcFiles -eq $null) {
        Add-Content !TMP1! 'OK: 시스템에 .netrc 파일이 존재하지 않습니다.';
    } Else {
        Add-Content !TMP1! 'WARN: 다음 위치에 .netrc 파일이 존재합니다:';
        foreach ($file in $netrcFiles) {
            $permissions = (Get-Acl $file.FullName).AccessToString;
            Add-Content !TMP1! ('권한 확인: ' + $permissions + ' 파일 경로: ' + $file.FullName);
        }
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
