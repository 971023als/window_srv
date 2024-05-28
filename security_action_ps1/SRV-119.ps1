function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-119] 백신 프로그램 업데이트 미흡"

Add-Content -Path $global:TMP1 -Value "[양호]: 백신 프로그램이 최신 버전으로 업데이트 되어 있는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 백신 프로그램이 최신 버전으로 업데이트 되어 있지 않은 경우"

BAR

# Windows Defender의 업데이트 상태 확인 및 업데이트 수행
try {
    $defenderStatus = Get-MpComputerStatus
    $antivirusSignatureAge = $defenderStatus.AntivirusSignatureAge

    if ($antivirusSignatureAge -le 1) {
        Add-Content -Path $global:TMP1 -Value "OK: Windows Defender의 바이러스 정의가 최신 상태입니다. (업데이트된 지 $antivirusSignatureAge 일)"
    } else {
        Update-MpSignature
        Add-Content -Path $global:TMP1 -Value "UPDATED: Windows Defender의 바이러스 정의가 업데이트되었습니다."
    }
} catch {
    Add-Content -Path $global:TMP1 -Value "ERROR: Windows Defender의 업데이트 상태 확인 또는 업데이트 실행 중 오류가 발생했습니다."
}

# 결과 파일 출력
Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 실행 완료."
