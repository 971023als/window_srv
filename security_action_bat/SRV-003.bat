@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-003] SNMP 접근 통제 미설정 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: SNMP 접근 제어가 적절하게 설정된 경우 >> "!TMP1!"
echo [취약]: SNMP 접근 제어가 설정되지 않거나 미흡한 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: SNMP 서비스 실행 중인지 확인
sc queryex SNMP | find /i "RUNNING" > nul
if errorlevel 1 (
    echo SNMP 서비스가 실행 중이지 않습니다. >> "!TMP1!"
) else (
    :: SNMP 접근 통제 설정 확인 (PowerShell을 사용하여 레지스트리 검사)
    powershell -Command "& {
        $snmpRegPathACL = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers';
        $snmpACLs = Get-ItemProperty -Path $snmpRegPathACL;
        if ($snmpACLs -eq $null) {
            echo 'SNMP 접근 통제 설정이 발견되지 않았습니다.' >> '!TMP1!';
        } else {
            $aclCount = 0;
            foreach ($acl in $snmpACLs.PSObject.Properties) {
                if ($acl.Name -ne 'PSPath' -and $acl.Name -ne 'PSParentPath' -and $acl.Name -ne 'PSChildName' -and $acl.Name -ne 'PSDrive' -and $acl.Name -ne 'PSProvider') {
                    $aclCount++;
                    echo '허용된 관리자: ' + $acl.Value >> '!TMP1!';
                }
            }
            if ($aclCount -gt 0) {
                echo '양호: SNMP 접근 제어가 적절하게 설정되었습니다.' >> '!TMP1!';
            } else {
                echo '취약: SNMP 접근 제어가 설정되지 않았습니다.' >> '!TMP1!';
            }
        }
    }"
)

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
