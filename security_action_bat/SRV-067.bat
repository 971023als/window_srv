# 비밀번호 정책 조회
$PasswordPolicies = @(
    "MinimumPasswordLength",
    "PasswordComplexity",
    "MaximumPasswordAge",
    "MinimumPasswordAge"
)

foreach ($policy in $PasswordPolicies) {
    $secpol = secedit /export /cfg secpol.cfg
    $policyValue = (Get-Content -Path .\secpol.cfg | Select-String $policy).ToString().Split('=')[1].Trim()
    Write-Host "$policy: $policyValue"
}

# 생성한 임시 파일 삭제
Remove-Item -Path .\secpol.cfg
