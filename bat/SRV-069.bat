#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-069] 비밀번호 관리정책 설정 미비

cat << EOF >> $TMP1
[양호]: 서버의 비밀번호 관리정책이 적절하게 설정된 경우
[취약]: 서버의 비밀번호 관리정책이 미비하게 설정된 경우
EOF

BAR
# 변수 초기화
file_exists_count=0
minlen_file_exists_count=0
no_settings_in_minlen_file=0
mininput_file_exists_count=0
no_settings_in_mininput_file=0
input_options=("lcredit" "ucredit" "dcredit" "ocredit")
input_modules=("pam_pwquality.so" "pam_cracklib.so" "pam_unix.so")

# 패스워드 정책 검사 함수
check_password_policy() {
    local file_path=$1
    local setting_type=$2
    local setting_name=$3
    local min_value=$4
    local message=$5

    if [ -f "$file_path" ]; then
        ((file_exists_count++))
        local setting_count
        local setting_value
        case $setting_type in
            "minlen")
                ((minlen_file_exists_count++))
                setting_count=`grep -vE '^#|^\s#' $file_path | grep -i $setting_name | wc -l`
                if [ $setting_count -gt 0 ]; then
                    setting_value=`grep -vE '^#|^\s#' $file_path | grep -i $setting_name | awk '{print $2}'`
                    if [ $setting_value -lt $min_value ]; then
                        WARN " $file_path 파일에 $message" >> $TMP1
                    fi
                else
                    ((no_settings_in_minlen_file++))
                fi
                ;;
            "mininput")
                ((mininput_file_exists_count++))
                setting_count=`grep -vE '^#|^\s#' $file_path | grep -i $setting_name | wc -l`
                if [ $setting_count -gt 0 ]; then
                    setting_value=`grep -vE '^#|^\s#' $file_path | grep -i $setting_name | awk '{print $2}'`
                    if [ $setting_value -lt $min_value ]; then
                        WARN " $file_path 파일에 $message" >> $TMP1
                    fi
                else
                    ((no_settings_in_mininput_file++))
                fi
                ;;
        esac
    fi
}

# 비밀번호 정책 설정 파일 검사
check_password_policy "/etc/login.defs" "minlen" "PASS_MIN_LEN" 8 "패스워드 최소 길이가 8 미만으로 설정되어 있습니다."
for file in "/etc/pam.d/system-auth" "/etc/pam.d/password-auth"; do
    for module in "${input_modules[@]}"; do
        check_password_policy "$file" "minlen" "minlen" 8 "패스워드 최소 길이가 8 미만으로 설정되어 있습니다."
        for option in "${input_options[@]}"; do
            check_password_policy "$file" "mininput" "$option" 1 "패스워드의 영문, 숫자, 특수문자의 최소 입력이 1 미만으로 설정되어 있습니다."
        done
    done
done
check_password_policy "/etc/security/pwquality.conf" "minlen" "minlen" 8 "패스워드 최소 길이가 8 미만으로 설정되어 있습니다."
for option in "${input_options[@]}"; do
    check_password_policy "/etc/security/pwquality.conf" "mininput" "$option" 1 "패스워드의 영문, 숫자, 특수문자의 최소 입력이 1 미만으로 설정되어 있습니다."
done

# 패스워드 최대 사용 기간 검사
if [ -f /etc/login.defs ]; then
    etc_logindefs_maxdays_count=`grep -vE '^#|^\s#' /etc/login.defs | grep -i 'PASS_MAX_DAYS' | awk '{print $2}' | wc -l`
    if [ $etc_logindefs_maxdays_count -gt 0 ]; then
        etc_logindefs_maxdays_value=`grep -vE '^#|^\s#' /etc/login.defs | grep -i 'PASS_MAX_DAYS' | awk '{print $2}'`
        if [ $etc_logindefs_maxdays_value -gt 90 ]; then
            WARN " /etc/login.defs 파일에 패스워드 최대 사용 기간이 91일 이상으로 설정되어 있습니다." >> $TMP1
        else
            OK "※ U-47 결과 : 양호(Good)" >> $TMP1
        fi
    else
        WARN " /etc/login.defs 파일에 패스워드 최대 사용 기간이 설정되어 있지 않습니다." >> $TMP1
    fi
else
    WARN " /etc/login.defs 파일이 없습니다." >> $TMP1
fi

# 패스워드 최소 사용 기간 검사
if [ -f /etc/login.defs ]; then
    etc_logindefs_mindays_count=`grep -vE '^#|^\s#' /etc/login.defs | grep -i 'PASS_MIN_DAYS' | awk '{print $2}' | wc -l`
    if [ $etc_logindefs_mindays_count -gt 0 ]; then
        etc_logindefs_mindays_value=`grep -vE '^#|^\s#' /etc/login.defs | grep -i 'PASS_MIN_DAYS' | awk '{print $2}'`
        if [ $etc_logindefs_mindays_value -lt 1 ]; then
            WARN " /etc/login.defs 파일에 패스워드 최소 사용 기간이 1일 미만으로 설정되어 있습니다." >> $TMP1
        else
            OK "※ U-48 결과 : 양호(Good)" >> $TMP1
        fi
    else
        WARN " /etc/login.defs 파일에 패스워드 최소 사용 기간이 설정되어 있지 않습니다." >> $TMP1
    fi
else
    WARN " /etc/login.defs 파일이 없습니다." >> $TMP1
fi

# 쉐도우 패스워드 사용 여부 검사
if [ `awk -F : '$2!="x"' /etc/passwd | wc -l` -gt 0 ]; then
    WARN " 쉐도우 패스워드를 사용하고 있지 않습니다." >> $TMP1
else
    OK "※ U-04 결과 : 양호(Good)" >> $TMP1
fi

# 결과 파일 출력
cat $TMP1

echo ; echo

