@echo off
REM Bu dosyayi yonetici olarak calistirin

echo ============================================================
echo SQL SERVER DIS PORT KAPATMA ISLEMI
echo ============================================================
echo.

echo 1. Port 6543 engelleniyor (Inbound)...
netsh advfirewall firewall add rule name="SQL_EXTERNAL_BLOCK_6543" dir=in action=block protocol=TCP localport=6543 profile=domain,private,public
if %errorlevel% == 0 (
    echo    OK: Inbound kurali eklendi
) else (
    echo    UYARI: Kural eklenemedi veya zaten mevcut
)

echo.
echo 2. Port 6543 engelleniyor (Outbound)...
netsh advfirewall firewall add rule name="SQL_EXTERNAL_BLOCK_OUT_6543" dir=out action=block protocol=TCP localport=6543 profile=domain,private,public
if %errorlevel% == 0 (
    echo    OK: Outbound kurali eklendi
) else (
    echo    UYARI: Kural eklenemedi veya zaten mevcut
)

echo.
echo 3. Kontrol ediliyor...
netsh advfirewall firewall show rule name="SQL_EXTERNAL_BLOCK_6543"
echo.

echo ============================================================
echo ISLEM TAMAMLANDI
echo ============================================================
echo.
echo NOT: SQL Server servisini yeniden baslatmaniz gerekebilir.
echo Kontrol: netstat -ano ^| findstr LISTENING
echo.
pause
