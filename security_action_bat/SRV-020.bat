@echo off
setlocal enabledelayedexpansion

set "TMP1=%SCRIPTNAME%.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-020] 공유에 대한 접근 통제 미비 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: NFS 또는 SMB/CIFS 공유에 대한 접근 통제가 적절하게 설정된 경우 >> !TMP1!
echo [취약]: NFS 또는 SMB/CIFS 공유에 대한 접근 통제가 미비한 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: SMB 공유 접근 통제 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $SmbShares = Get-SmbShare;
    foreach ($share in $SmbShares) {
        $SharePermissions = Get-SmbShareAccess -Name $share.Name;
        foreach ($perm in $SharePermissions) {
            if ($perm.AccountName -eq 'Everyone' -and $perm.AccessRight -eq 'Full') {
                Add-Content !TMP1! ('WARN: ' + $share.Name + ' SMB 공유에서 Everyone에게 전체 접근 권한이 부여됨');
            } else {
                Add-Content !TMP1! ('OK: ' + $share.Name + ' SMB 공유의 접근 통제가 적절함');
            }
        }
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
