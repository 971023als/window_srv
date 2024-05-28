@echo off
setlocal enabledelayedexpansion

set "TMP1=%SCRIPTNAME%.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-023] 원격 터미널 서비스의 암호화 수준 설정 미흡 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: SSH 서비스의 암호화 수준이 적절하게 설정된 경우 >> !TMP1!
echo [취약]: SSH 서비스의 암호화 수준 설정이 미흡한 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: SSH 암호화 관련 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $SshConfigFile = 'C:\ProgramData\ssh\sshd_config';
    $EncryptionSettings = @('KexAlgorithms', 'Ciphers', 'MACs');
    $ConfigExists = Test-Path $SshConfigFile;
    if (-not $ConfigExists) {
        Add-Content !TMP1! 'WARN: SSH 구성 파일이 존재하지 않습니다.';
        exit;
    }
    foreach ($setting in $EncryptionSettings) {
        $ConfigContent = Get-Content $SshConfigFile;
        $SettingConfigured = $ConfigContent | Where-Object { $_ -match """"^$setting"""" };
        if ($SettingConfigured) {
            Add-Content !TMP1! 'OK: ' + $SshConfigFile + ' 파일에서 ' + $setting + ' 설정이 적절하게 구성되어 있습니다.';
        } else {
            Add-Content !TMP1! 'WARN: ' + $SshConfigFile + ' 파일에서 ' + $setting + ' 설정이 미흡합니다.';
        }
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
