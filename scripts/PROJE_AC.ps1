# ARIA NET Projesi Başlatma Scripti
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "ARIA NET PROJESI BASLATILIYOR..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location D:\tayfun

Write-Host "Virtual environment kontrol ediliyor..." -ForegroundColor Yellow
if (-not (Test-Path "venv\Scripts\python.exe")) {
    Write-Host "Virtual environment bulunamadi, olusturuluyor..." -ForegroundColor Yellow
    python -m venv venv
    Write-Host "Virtual environment olusturuldu." -ForegroundColor Green
}

Write-Host "Virtual environment aktif ediliyor..." -ForegroundColor Yellow
& .\venv\Scripts\Activate.ps1

Write-Host "Gerekli paketler kontrol ediliyor..." -ForegroundColor Yellow
pip install -q -r requirements.txt

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Django sunucusu baslatiliyor..." -ForegroundColor Cyan
Write-Host "Tarayici: http://127.0.0.1:6543" -ForegroundColor Green
Write-Host "Durdurmak icin CTRL+C basin" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

python manage.py runserver 127.0.0.1:6543

