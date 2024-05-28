# 결과 파일 정의
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_UnnecessaryFilesCheck.log"

# 결과 파일에 헤더 추가
"불필요한 파일 존재 여부 검사" | Out-File -FilePath $TMP1
"=================================" | Out-File -FilePath $TMP1 -Append

# 불필요한 파일 검사 경로 설정 (Windows의 임시 파일 경로 예시로 사용)
$checkPath = "C:\Windows\Temp"

# 지정된 경로에 파일이 존재하는지 확인
$unnecessaryFiles = Get-ChildItem -Path $checkPath -File

# 결과 평가 및 로그 파일에 기록
if ($unnecessaryFiles.Count -gt 0) {
    "WARN: $checkPath 디렉터리에 불필요한 파일이 존재합니다." | Out-File -FilePath $TMP1 -Append
    $unnecessaryFiles | ForEach-Object {
        "불필요한 파일: $($_.FullName)" | Out-File -FilePath $TMP1 -Append
    }
} else {
    "OK: $checkPath 디렉터리에 불필요한 파일이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 내용 출력
Get-Content -Path $TMP1 | Write-Output
