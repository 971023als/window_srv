#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-072] 기본 관리자 계정명(Administrator) 존재

cat << EOF >> $result
[양호]: 기본 'Administrator' 계정이 존재하지 않는 경우
[취약]: 기본 'Administrator' 계정이 존재하는 경우
EOF

BAR

# 'Administrator' 계정 확인
if grep -qi "Administrator" /etc/passwd; then
    WARN "기본 'Administrator' 계정이 존재합니다."
else
    OK "기본 'Administrator' 계정이 존재하지 않습니다."
fi

cat $result

echo ; echo
