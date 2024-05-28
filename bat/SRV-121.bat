#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [SRV-121] root 계정의 PATH 환경변수 설정 미흡

cat << EOF >> $TMP1
[양호]: root 계정의 PATH 환경변수가 안전하게 설정되어 있는 경우
[취약]: root 계정의 PATH 환경변수에 안전하지 않은 경로가 포함된 경우
EOF

BAR

if [ `echo $PATH | grep -E '\.:|::' | wc -l` -gt 0 ]; then
		WARN " PATH 환경 변수 내에 "." 또는 "::"이 포함되어 있습니다." >> $TMP1
		return 0
	else
		# /etc 디렉터리 내 설정 파일의 PATH 변수 중 누락이 있을 가능성을 생각하여 추가 확인함
		path_settings_files=("/etc/profile" "/etc/.login" "/etc/csh.cshrc" "/etc/csh.login" "/etc/environment")
		for ((i=0; i<${#path_settings_files[@]}; i++))
		do
			if [ -f ${path_settings_files[$i]} ]; then
				path_settings_file_path_variable_exists_count=`grep -vE '^#|^\s#' ${path_settings_files[$i]} | grep 'PATH=' | wc -l`
				if [ $path_settings_file_path_variable_exists_count -gt 0 ]; then
					path_settings_file_path_variable_value_count=`grep -vE '^#|^\s#' ${path_settings_files[$i]} | grep 'PATH=' | grep -E '\.:|::' | wc -l`
					if [ $path_settings_file_path_variable_value_count -gt 0 ]; then
						WARN " /etc 디렉터리 내 Start Profile에 설정된 PATH 환경 변수 내에 "." 또는 "::"이 포함되어 있습니다." >> $TMP1
						return 0
					fi
				fi
			fi
		done
		# 사용자 홈 디렉터리 내 설정 파일의 PATH 변수 중 누락이 있을 가능성을 생각하여 추가 확인함
		path_settings_files=(".profile" ".cshrc" ".login" ".kshrc" ".bash_profile" ".bashrc" ".bash_login")
		user_homedirectory_path=(`awk -F : '$7!="/bin/false" && $7!="/sbin/nologin" && $6!=null {print $6}' /etc/passwd | uniq`) # /etc/passwd 파일에 설정된 홈 디렉터리 배열 생성
		user_homedirectory_path2=(/home/*) # /home 디렉터래 내 위치한 홈 디렉터리 배열 생성
		for ((i=0; i<${#user_homedirectory_path2[@]}; i++))
		do
			user_homedirectory_path[${#user_homedirectory_path[@]}]=${user_homedirectory_path2[$i]} # 두 개의 배열 합침
		done
		user_homedirectory_path[${#user_homedirectory_path[@]}]=/root
		for ((i=0; i<${#user_homedirectory_path[@]}; i++))
		do
			for ((j=0; j<${#path_settings_files[@]}; j++))
			do
				if [ -f ${user_homedirectory_path[$i]}/${path_settings_files[$j]} ]; then
					path_settings_file_path_variable_exists_count=`grep -vE '^#|^\s#' ${user_homedirectory_path[$i]}/${path_settings_files[$j]} | grep 'PATH=' | wc -l`
					if [ $path_settings_file_path_variable_exists_count -gt 0 ]; then
						path_settings_file_path_variable_value_count=`grep -vE '^#|^\s#' ${user_homedirectory_path[$i]}/${path_settings_files[$j]} | grep 'PATH=' | grep -E '\.:|::' | wc -l`
						if [ $path_settings_file_path_variable_value_count -gt 0 ]; then
							WARN " ${user_homedirectory_path[$i]} 디렉터리 내 ${path_settings_files[$j]} 파일에 설정된 PATH 환경 변수 내에 "." 또는 "::"이 포함되어 있습니다." >> $TMP1
							return 0
						fi
					fi
				fi
			done
		done
	fi
	OK "※ U-05 결과 : 양호(Good)" >> $TMP1
	return 0

user_homedirectory_path=(`awk -F : '$7!="/bin/false" && $7!="/sbin/nologin" && $6!=null {print $6}' /etc/passwd`) # /etc/passwd 파일에 설정된 홈 디렉터리 배열 생성
	user_homedirectory_path2=(/home/*) # /home 디렉터래 내 위치한 홈 디렉터리 배열 생성
	for ((i=0; i<${#user_homedirectory_path2[@]}; i++))
	do
		user_homedirectory_path[${#user_homedirectory_path[@]}]=${user_homedirectory_path2[$i]} # 두 개의 배열 합침
	done
	user_homedirectory_owner_name=(`awk -F : '$7!="/bin/false" && $7!="/sbin/nologin" && $6!=null {print $1}' /etc/passwd`) # /etc/passwd 파일에 설정된 사용자명 배열 생성
	user_homedirectory_owner_name2=() # user_homedirectory_path2 배열에서 사용자명만 따로 출력하여 저장할 빈 배열 생성
	for ((i=0; i<${#user_homedirectory_path2[@]}; i++))
	do
		user_homedirectory_owner_name2[${#user_homedirectory_owner_name2[@]}]=`echo ${user_homedirectory_path2[$i]} | awk -F / '{print $3}'` # user_homedirectory_path2 배열에서 사용자명만 따로 출력하여 배열에 저장함
	done
	for ((i=0; i<${#user_homedirectory_owner_name2[@]}; i++))
	do
		user_homedirectory_owner_name[${#user_homedirectory_owner_name[@]}]=${user_homedirectory_owner_name2[$i]} # 두 개의 배열 합침
	done
	start_files=(".profile" ".cshrc" ".login" ".kshrc" ".bash_profile" ".bashrc" ".bash_login")
	for ((i=0; i<${#user_homedirectory_path[@]}; i++))
	do
		for ((j=0; j<${#start_files[@]}; j++))
		do
			if [ -f ${user_homedirectory_path[$i]}/${start_files[$j]} ]; then
				user_homedirectory_owner_name2=`ls -l ${user_homedirectory_path[$i]}/${start_files[$j]} | awk '{print $3}'`
				if [[ $user_homedirectory_owner_name2 =~ root ]] || [[ $user_homedirectory_owner_name2 =~ ${user_homedirectory_owner_name[$i]} ]]; then
					user_homedirectory_other_execute_permission=`ls -l ${user_homedirectory_path[$i]}/${start_files[$j]} | awk '{print substr($1,9,1)}'`
					if [[ $user_homedirectory_other_execute_permission =~ w ]]; then
						WARN " ${user_homedirectory_path[$i]} 홈 디렉터리 내 ${start_files[$j]} 환경 변수 파일에 다른 사용자(other)의 쓰기(w) 권한이 부여 되어 있습니다." >> $TMP1
						return 0
					fi
				else
					WARN " ${user_homedirectory_path[$i]} 홈 디렉터리 내 ${start_files[$j]} 환경 변수 파일의 소유자(owner)가 root 또는 해당 계정이 아닙니다." >> $TMP1
					return 0
				fi
			fi
		done
	done
	OK "※ U-14 결과 : 양호(Good)" >> $TMP1
	return 0

cat $result

echo ; echo
