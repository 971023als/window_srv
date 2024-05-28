@echo off
Setlocal EnableDelayedExpansion

:: 임시 파일 생성
Set TMP1=%~dp0%SCRIPTNAME%.log
> "%TMP1%" (

    Echo ----------------------------------------
    Echo CODE [SRV-122] UMASK 설정 미흡
    Echo ----------------------------------------
    Echo [양호]: 시스템 전체 UMASK 설정이 022 또는 더 엄격한 경우
    Echo [취약]: 시스템 전체 UMASK 설정이 022보다 덜 엄격한 경우
    Echo ----------------------------------------

    :: PowerShell을 사용하여 "Documents" 폴더에 대한 기본 권한 설정
    Powershell -Command "& {
        \$FolderPath = 'C:\Users\Public\Documents'
        \$Acl = Get-Acl \$FolderPath
        \$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule('Everyone', 'Read', 'Allow')
        \$Acl.SetAccessRule(\$Ar)
        Set-Acl -Path \$FolderPath -AclObject \$Acl
        If ((Get-Acl \$FolderPath).Access | Where-Object { \$_ -match 'Everyone' -and \$_ -match 'Read' }) {
            Write-Output 'UMASK 설정이 적용되었습니다: Everyone -> Read 권한'
        } Else {
            Write-Output 'UMASK 설정 적용 실패'
        }
    }"
)

:: 결과 파일 출력
Type "%TMP1%"

Endlocal
