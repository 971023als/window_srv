# 로그 파일 경로 및 초기화
$TMP1 = "$env:SCRIPTNAME.log"
"" | Out-File -FilePath $TMP1

# 로그 파일에 내용 추가
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-135] TCP 보안 설정 미비" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 필수 TCP 보안 설정이 적절히 구성된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 필수 TCP 보안 설정이 구성되지 않은 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# TCP 관련 레지스트리 설정 확인 및 수정
$settings = @{
    'TcpWindowSize' = @{
        'Path' = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
        'Value' = 65536
    }
    'Tcp1323Opts' = @{
        'Path' = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
        'Value' = 1
    }
    'SynAttackProtect' = @{
        'Path' = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
        'Value' = 2
    }
}

foreach ($setting in $settings.GetEnumerator()) {
    $currentValue = Get-ItemPropertyValue -Path $setting.Value.Path -Name $setting.Key -ErrorAction SilentlyContinue
    if ($null -eq $currentValue) {
        "WARN: $($setting.Key) 설정이 없습니다. 설정을 추가합니다." | Out-File -FilePath $TMP1 -Append
        New-ItemProperty -Path $setting.Value.Path -Name $setting.Key -Value $setting.Value.Value -PropertyType DWORD -Force | Out-Null
        "$($setting.Key)가 $($setting.Value.Value)로 설정되었습니다." | Out-File -FilePath $TMP1 -Append
    } elseif ($currentValue -ne $setting.Value.Value) {
        "WARN: $($setting.Key)의 현재 값은 $currentValue 입니다. 권장 값으로 업데이트합니다." | Out-File -FilePath $TMP1 -Append
        Set-ItemProperty -Path $setting.Value.Path -Name $setting.Key -Value $setting.Value.Value
        "$($setting.Key)가 $($setting.Value.Value)로 업데이트되었습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "OK: $($setting.Key)는 이미 권장 값($($setting.Value.Value))으로 설정되어 있습니다." | Out-File -FilePath $TMP1 -Append
    }
}

# 결과 파일 출력
Get-Content -Path
