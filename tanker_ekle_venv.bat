@echo off
cd /d D:\tayfun
echo Tanker MenuItem ekleniyor...
echo.

REM Virtual environment aktif et
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
    echo Virtual environment aktif edildi.
) else (
    echo Virtual environment bulunamadi!
    pause
    exit /b 1
)

REM Script'i çalıştır
python tanker_ekle_direct.py

echo.
pause
