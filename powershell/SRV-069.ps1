# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(SCRIPTNAME).log"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-069] 비밀번호 관리정책 설정 미비"

Add-Content -Path $TMP1 -Value "[양호]: 서버의 비밀번호 관리정책이 적절하게 설정된 경우"
Add-Content -Path $TMP1 -Value "[취약]: 서버의 비밀번호 관리정책이 미비하게 설정된 경우"

BAR

# 변수 초기화
$file_exists_count = 0
$minlen_file_exists_count = 0
$no_settings_in_minlen_file = 0
$mininput_file_exists_count = 0
$no_settings_in_mininput_file = 0
$input_options = @("lcredit", "ucredit", "dcredit", "ocredit")
$input_modules = @("pam_pwquality.so", "pam_cracklib.so", "pam_unix.so")

# 패스워드 정책 검사 함수
function Check-PasswordPolicy {
    param (
        [string]$file_path,
        [string]$setting_type,
        [string]$setting_name,
        [int]$min_value,
        [string]$message
    )

    if (Test-Path $file_path) {
        $file_exists_count++
        switch ($setting_type) {
            "minlen" {
                $minlen_file_exists_count++
                $setting_count = (Select-String -Path $file_path -Pattern $setting_name -NotMatch "^#|^\s#" | Measure-Object).Count
                if ($setting_count -gt 0) {
                    $setting_value = (Select-String -Path $file_path -Pattern $setting_name -NotMatch "^#|^\s#" | ForEach-Object { $_.Matches.Groups[1].Value }).Trim()
                    if ($setting_value -lt $min_value) {
                        Add-Content -Path $TMP1 -Value "WARN: $file_path 파일에 $message"
                    }
                } else {
                    $no_settings_in_minlen_file++
                }
            }
            "mininput" {
                $mininput_file_exists_count++
                $setting_count = (Select-String -Path $file_path -Pattern $setting_name -NotMatch "^#|^\s#" | Measure-Object).Count
                if ($setting_count -gt 0) {
                    $setting_value = (Select-String -Path $file_path -Pattern $setting_name -NotMatch "^#|^\s#" | ForEach-Object { $_.Matches.Groups[1].Value }).Trim()
                    if ($setting_value -lt $min_value) {
                        Add-Content -Path $TMP1 -Value "WARN: $file_path 파일에 $message"
                    }
                } else {
                    $no_settings_in_mininput_file++
                }
            }
        }
    }
}

# 비밀번호 정책 설정 파일 검사
Check-PasswordPolicy -file_path "/etc/login.defs" -setting_type "minlen" -setting_name "PASS_MIN_LEN" -min_value 8 -message "패스워드 최소 길이가 8 미만으로 설정되어 있습니다."
"/etc/pam.d/system-auth", "/etc/pam.d/password-auth" | ForEach-Object {
    $file = $_
    $input_modules | ForEach-Object {
        $module = $_
        Check-PasswordPolicy -file_path $file -setting_type "minlen" -setting_name "minlen" -min_value 8 -message "패스워드 최소 길이가 8 미만으로 설정되어 있습니다."
        $input_options | ForEach-Object {
            $option = $_
            Check-PasswordPolicy -file_path $file -setting_type "mininput" -setting_name $option -min_value 1 -message "패스워드의 영문, 숫자, 특수문자의 최소 입력이 1 미만으로 설정되어 있습니다."
        }
