function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-087] C 컴파일러 존재 및 권한 설정 미흡"

Add-Content -Path $global:TMP1 -Value "[양호]: C 컴파일러가 존재하지 않거나, 적절한 권한으로 설정된 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: C 컴파일러가 존재하며 권한 설정이 미흡한 경우"

BAR

# C 컴파일러 위치 확인
$CompilerPath = Get-Command gcc -ErrorAction SilentlyContinue

# 컴파일러 존재 여부 및 권한 확인 및 수정
if (-not $CompilerPath) {
    Add-Content -Path $global:TMP1 -Value "OK: C 컴파일러(gcc)가 시스템에 설치되어 있지 않습니다."
} else {
    # 권한 확인 및 수정
    $acl = Get-Acl $CompilerPath.Source
    $isFullControl = $acl.Access | Where-Object {
        $_.FileSystemRights -eq "FullControl" -and
        $_.IdentityReference -match "Everyone"
    }

    if ($isFullControl) {
        # 권한 제거 (예: Everyone의 FullControl 제거)
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "None", "None", "Remove")
        $acl.ModifyAccessRule([System.Security.AccessControl.AccessControlModification]::Remove, $rule, [ref]$false)
        Set-Acl -Path $CompilerPath.Source -AclObject $acl

        Add-Content -Path $global:TMP1 -Value "FIXED: C 컴파일러(gcc)의 권한이 제한적으로 수정되었습니다."
    } else {
        Add-Content -Path $global:TMP1 -Value "OK: C 컴파일러(gcc)의 권한이 적절합니다."
    }
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
