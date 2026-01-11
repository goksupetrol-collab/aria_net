@echo off
cd /d D:\tayfun
echo Fiyat Degisimi MenuItem ekleniyor...
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
python fiyat_degisimi_ekle.py

echo.
pause
