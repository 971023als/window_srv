@echo off
setlocal enabledelayedexpansion

set "TMP1=%SCRIPTNAME%.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-014] NFS 접근통제 미비 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: 불필요한 NFS 서비스를 사용하지 않거나, 불가피하게 사용 시 everyone 공유를 제한한 경우 >> !TMP1!
echo [취약]: 불필요한 NFS 서비스를 사용하거나, 불가피하게 사용 시 everyone 공유를 제한하지 않는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: NFS 공유 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $NfsShares = Get-NfsShare;
    If ($NfsShares) {
        foreach ($share in $NfsShares) {
            $ShareName = $share.Name;
            $SharePath = $share.Path;
            $SharePermissions = $share.Permission;
            If ($SharePermissions -match 'Everyone') {
                Add-Content !TMP1! ('WARN: NFS 공유 (' + $ShareName + ') 에 everyone 공유가 허용됩니다. 경로: ' + $SharePath);
            } else {
                Add-Content !TMP1! ('OK: NFS 공유 (' + $ShareName + ') 에서 everyone 공유가 제한됩니다. 경로: ' + $SharePath);
            }
        }
    } else {
        Add-Content !TMP1! 'OK: 활성화된 NFS 공유가 없습니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
