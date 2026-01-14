@echo off
echo ========================================
echo ARIA NET PROJESI BASLATILIYOR...
echo ========================================
echo.

cd /d D:\tayfun

echo Virtual environment kontrol ediliyor...
if not exist "venv\Scripts\python.exe" (
    echo Virtual environment bulunamadi, olusturuluyor...
    python -m venv venv
    echo Virtual environment olusturuldu.
)

echo Virtual environment aktif ediliyor...
call venv\Scripts\activate.bat

echo Gerekli paketler kontrol ediliyor...
pip install -q -r requirements.txt

echo.
echo ========================================
echo Django sunucusu baslatiliyor...
echo Tarayici: http://127.0.0.1:6543
echo Durdurmak icin CTRL+C basin
echo ========================================
echo.

python manage.py runserver 127.0.0.1:6543

pause

