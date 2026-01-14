@echo off
REM CHROME CHATGPT SOHBETLERINI TEMIZLEME
echo ========================================
echo CHROME CHATGPT SOHBETLERI TEMIZLENIYOR...
echo ========================================
echo.
echo NOT: Chrome kapali olmali!
echo.
pause

REM Chrome kullanıcı verileri yolu
set CHROME_PATH=%LOCALAPPDATA%\Google\Chrome\User Data\Default

REM ChatGPT ile ilgili yerel depolama
if exist "%CHROME_PATH%\Local Storage\leveldb" (
    echo Local Storage temizleniyor...
    del /f /q "%CHROME_PATH%\Local Storage\leveldb\*" 2>nul
)

REM IndexedDB temizleme
if exist "%CHROME_PATH%\IndexedDB" (
    echo IndexedDB temizleniyor...
    for /d %%d in ("%CHROME_PATH%\IndexedDB\*chatgpt*") do rd /s /q "%%d" 2>nul
    for /d %%d in ("%CHROME_PATH%\IndexedDB\*openai*") do rd /s /q "%%d" 2>nul
)

REM Cookies (ChatGPT domain'leri)
echo.
echo NOT: Tam temizlik icin Chrome'u kapatip bu scripti tekrar calistirin.
echo      Veya Chrome'da: Ayarlar > Gizlilik > Tarama verilerini temizle
echo.
echo Tamamlandi!
pause
