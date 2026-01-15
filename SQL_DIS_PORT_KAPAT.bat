@echo off
echo ============================================================
echo SQL SERVER DIS PORT KAPATMA ISLEMI
echo ============================================================
echo.

REM Port tespiti
echo 1. Port tespiti yapiliyor...
netstat -ano | findstr "6543.*LISTENING"
echo.

REM Firewall kurallari ekle
echo 2. Firewall kurallari ekleniyor...
netsh advfirewall firewall add rule name="SQL_EXTERNAL_BLOCK_6543" dir=in action=block protocol=TCP localport=6543 profile=domain,private,public
netsh advfirewall firewall add rule name="SQL_EXTERNAL_BLOCK_OUT_6543" dir=out action=block protocol=TCP localport=6543 profile=domain,private,public
echo.

REM Kontrol
echo 3. Firewall kurallari kontrol ediliyor...
netsh advfirewall firewall show rule name="SQL_EXTERNAL_BLOCK_6543"
echo.

echo ============================================================
echo ISLEM TAMAMLANDI
echo ============================================================
echo.
echo ONEMLI: SQL Server servisini yeniden baslatmaniz gerekebilir.
echo Kontrol: netstat -ano ^| findstr LISTENING
echo.
pause
