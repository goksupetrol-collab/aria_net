@echo off
REM GERI GETIRME SCRIPTI - Tüm gizli dosyaları görünür yapar
cd /d D:\tayfun

echo Gizli dosyalar geri getiriliyor...

REM Klasörü görünür yap
attrib -h "D:\tayfun" /s /d

REM Tüm dosya ve klasörleri görünür yap
attrib -h *.* /s /d

echo Tamamlandi! Tum dosyalar gorunur hale getirildi.
pause
