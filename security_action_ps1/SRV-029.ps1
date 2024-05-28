# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 구분자 함수
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-029] SMB 세션 중단 관리 설정 미비" | Out-File -FilePath $TMP1 -Append
@"
[양호]: SMB 서비스의 세션 중단 시간이 적절하게 설정된 경우
[취약]: SMB 서비스의 세션 중단 시간 설정이 미비한 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# SMB 세션 중단 시간 설정 확인 및 조정
$path = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters'
$deadtime = Get-ItemPropertyValue -Path $path -Name 'autodisconnect' -ErrorAction SilentlyContinue
$desiredDeadTime = 15 # 분

if ($null -ne $deadtime) {
    if ($deadtime -eq $desiredDeadTime) {
        "OK: SMB 세션 중단 시간(autodisconnect)이 이미 적절하게 설정되어 있습니다: $deadtime 분" | Out-File -FilePath $TMP1 -Append
    } else {
        Set-ItemProperty -Path $path -Name 'autodisconnect' -Value $desiredDeadTime
        "CHANGE: SMB 세션 중단 시간(autodisconnect)을 $desiredDeadTime 분으로 조정하였습니다." | Out-File -FilePath $TMP1 -Append
    }
} else {
    New-ItemProperty -Path $path -Name 'autodisconnect' -Value $desiredDeadTime -PropertyType DWORD
    "CHANGE: SMB 세션 중단 시간(autodisconnect) 설정이 없어 $desiredDeadTime 분으로 설정하였습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력 및 로그 파일 삭제
Get-Content $TMP1 | Write-Host
Remove-Item $TMP1 -Force
