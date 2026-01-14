@echo off
REM CURSOR VE PROJE GERI GETIRME
echo ========================================
echo CURSOR VE PROJE GERI GETIRILIYOR...
echo ========================================

REM Cursor dosyalarını görünür yap
cd /d D:\
attrib -h *cursor* /s /d 2>nul

REM Proje klasörünü görünür yap
cd /d D:\tayfun
attrib -h *.* /s /d

echo.
echo Tamamlandi!
echo.
echo Simdi Cursor'u acip D:\tayfun klasorunu workspace olarak secin.
pause
