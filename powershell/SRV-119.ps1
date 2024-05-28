$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-119] 백신 프로그램 업데이트 미흡"

Add-Content -Path $TMP1 -Value "[양호]: 백신 프로그램이 최신 버전으로 업데이트 되어 있는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 백신 프로그램이 최신 버전으로 업데이트 되어 있지 않은 경우"

BAR

# Windows Defender의 업데이트 상태 확인
try {
    $defenderStatus = Get-MpComputerStatus
    $antivirusSignatureAge = $defenderStatus.AntivirusSignatureAge

    if ($antivirusSignatureAge -le 1) {
        Add-Content -Path $TMP1 -Value "OK: Windows Defender의 바이러스 정의가 최신 상태입니다. (업데이트된 지 $antivirusSignatureAge 일)"
    } else {
        Add-Content -Path $TMP1 -Value "WARN: Windows Defender의 바이러스 정의가 최신 상태가 아닙니다. (업데이트된 지 $antivirusSignatureAge 일)"
    }
} catch {
    Add-Content -Path $TMP1 -Value "WARN: Windows Defender의 업데이트 상태를 확인하는 데 실패했습니다."
}

# 결과 파일 출력
Get-Content -Path $TMP1

Write-Host "`n"
