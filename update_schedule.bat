@echo off
chcp 65001
cls

echo ========================================================
echo      입항일정표 자동 업데이트 및 배포 도구 (v1.0)
echo ========================================================

IF "%~1"=="" (
    echo [오류] 엑셀 파일을 이 아이콘 위로 드래그 앤 드롭해주세요!
    echo.
    pause
    exit /b
)

echo [1/4] 엑셀 파일 처리 중...
echo 파일: %~1
cd python_server
python generate_shipment_data.py "%~1"

IF %ERRORLEVEL% NEQ 0 (
    echo [오류] 데이터 변환 실패! 엑셀 파일을 확인해주세요.
    pause
    exit /b
)
cd ..

echo.
echo [2/4] Flutter 의존성 확인 중...
call flutter pub get

echo.
echo [3/4] 웹 버전 빌드 중... (시간이 조금 걸립니다)
call flutter build web --release --no-tree-shake-icons

IF %ERRORLEVEL% NEQ 0 (
    echo [오류] 빌드 실패!
    pause
    exit /b
)

echo.
echo [4/4] Firebase Hosting 배포 중...
call firebase deploy --only hosting

IF %ERRORLEVEL% NEQ 0 (
    echo [오류] 배포 실패! 인터넷 연결을 확인해주세요.
    pause
    exit /b
)

echo.
echo ========================================================
echo           🎉 모든 작업이 완료되었습니다! 🎉
echo ========================================================
echo.
pause