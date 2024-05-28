@echo off
setlocal enabledelayedexpansion

set "TMP1=%SCRIPTNAME%.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-018] 불필요한 하드디스크 기본 공유 활성화 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: NFS 또는 SMB/CIFS의 불필요한 하드디스크 공유가 비활성화된 경우 >> !TMP1!
echo [취약]: NFS 또는 SMB/CIFS에서 불필요한 하드디스크 기본 공유가 활성화된 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: SMB 공유 활성화 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $SmbShares = Get-SmbShare;
    foreach ($share in $SmbShares) {
        if ($share.Name -match '\$$') {
            Add-Content !TMP1! ('WARN: SMB/CIFS에서 불필요한 하드디스크 기본 공유가 활성화된 경우: ' + $share.Name);
        } else {
            Add-Content !TMP1! ('OK: SMB/CIFS의 불필요한 하드디스크 공유가 비활성화된 경우: ' + $share.Name);
        }
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
