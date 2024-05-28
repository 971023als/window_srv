@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-129] 백신 프로그램 미설치 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 백신 프로그램이 설치되어 있는 경우 >> %TMP1%
echo [취약]: 백신 프로그램이 설치되어 있지 않은 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 설치된 백신 프로그램 상태 확인
powershell -Command "& {
    $antivirusStatus = Get-CimInstance -Namespace 'root\SecurityCenter2' -ClassName 'AntivirusProduct'
    if ($antivirusStatus) {
        foreach ($product in $antivirusStatus) {
            $productName = $product.displayName
            $productStatus = '상태: ' + $product.productState
            echo 'OK: 설치된 백신 프로그램 - ' + $productName + ' ' + $productStatus >> '%TMP1%'
        }
    } else {
        echo 'WARN: 설치된 백신 프로그램이 없습니다.' >> '%TMP1%'
    }
}" >> %TMP1%

type %TMP1%

echo.
echo.

endlocal
