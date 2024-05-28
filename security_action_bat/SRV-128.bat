@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-128] NTFS 파일 시스템 미사용 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: NTFS 파일 시스템이 사용되지 않는 경우 >> %TMP1%
echo [취약]: NTFS 파일 시스템이 사용되는 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 모든 드라이브의 파일 시스템 유형 확인
powershell -Command "& {
    $drives = Get-Volume | Where-Object { $_.FileSystem -eq 'NTFS' }
    if ($drives) {
        foreach ($drive in $drives) {
            $driveLetter = $drive.DriveLetter
            $fileSystem = $drive.FileSystem
            echo 'WARN: 드라이브 ' + $driveLetter + ': ' + $fileSystem + ' 파일 시스템이 사용되고 있습니다.' >> '%TMP1%'
        }
    } else {
        echo 'OK: NTFS 파일 시스템이 사용되지 않습니다.' >> '%TMP1%'
    }
}" >> %TMP1%

type %TMP1%

echo.
echo.

endlocal
