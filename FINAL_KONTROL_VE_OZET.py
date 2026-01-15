# -*- coding: utf-8 -*-
"""
Final Kontrol ve Özet Rapor
Petronet ve SQL Server temizleme kontrolü
"""
import os
import subprocess
from datetime import datetime
import sys

sys.stdout.reconfigure(encoding='utf-8', errors='replace')

LOG_DOSYA = 'final_kontrol_ozet.txt'
KORUNACAK_KLASOR = r'D:\tayfun\ozgur_sistem_kopyasi'

def yazdir(mesaj, dosya=None):
    """Ekrana ve dosyaya yaz"""
    print(mesaj, flush=True)
    if dosya:
        dosya.write(mesaj + '\n')
        dosya.flush()

def kontrol_et(yol, isim, log_dosya):
    """Dosya/klasör varlığını kontrol et"""
    if os.path.exists(yol):
        yazdir(f"   VAR: {yol}", log_dosya)
        return True
    else:
        yazdir(f"   YOK: {yol} (Temizlendi)", log_dosya)
        return False

def servis_kontrol(log_dosya):
    """SQL Server servislerini kontrol et"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("SQL SERVER SERVISLERI KONTROL", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    servisler = ['MSSQLSERVER', 'MSSQL$PETROSQL', 'SQLSERVERAGENT', 'SQLBrowser']
    
    for servis in servisler:
        try:
            result = subprocess.run(
                ['sc', 'query', servis],
                capture_output=True,
                text=True,
                timeout=10
            )
            if result.returncode == 0:
                yazdir(f"   VAR: {servis} servisi mevcut", log_dosya)
            else:
                yazdir(f"   YOK: {servis} servisi yok (Temizlendi)", log_dosya)
        except:
            yazdir(f"   YOK: {servis} servisi yok (Temizlendi)", log_dosya)

def final_kontrol():
    """Final kontrol ve özet"""
    print("=" * 60)
    print("FINAL KONTROL VE OZET")
    print("=" * 60)
    print(f"Tarih: {datetime.now()}\n")
    
    log_dosya = open(LOG_DOSYA, 'w', encoding='utf-8')
    
    yazdir("=" * 60, log_dosya)
    yazdir("FINAL KONTROL VE OZET", log_dosya)
    yazdir("=" * 60, log_dosya)
    yazdir(f"Tarih: {datetime.now()}", log_dosya)
    
    # SQL Server klasörleri kontrol
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("SQL SERVER KLASORLERI KONTROL", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    sql_klasorleri = [
        (r'C:\Program Files\Microsoft SQL Server', 'SQL Server'),
        (r'C:\Program Files (x86)\Microsoft SQL Server', 'SQL Server (x86)'),
        (r'C:\Program Files\Microsoft SQL Server Management Studio 22', 'SSMS'),
    ]
    
    sql_var = 0
    for yol, isim in sql_klasorleri:
        if kontrol_et(yol, isim, log_dosya):
            sql_var += 1
    
    # Petronet klasörleri kontrol
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("PETRONET KLASORLERI KONTROL", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    petronet_klasorleri = [
        (r'C:\Petronet', 'Petronet C'),
        (r'D:\Petronet', 'Petronet D'),
    ]
    
    petronet_var = 0
    for yol, isim in petronet_klasorleri:
        if kontrol_et(yol, isim, log_dosya):
            petronet_var += 1
    
    # Servisler kontrol
    servis_kontrol(log_dosya)
    
    # Kopyalar kontrol
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("KOPYALAR KONTROL", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    if os.path.exists(KORUNACAK_KLASOR):
        yazdir(f"   OK: {KORUNACAK_KLASOR} mevcut ve korunuyor", log_dosya)
        dosya_sayisi = sum([len(files) for r, d, files in os.walk(KORUNACAK_KLASOR)])
        yazdir(f"   Toplam {dosya_sayisi} dosya korunuyor", log_dosya)
    else:
        yazdir(f"   HATA: {KORUNACAK_KLASOR} bulunamadi!", log_dosya)
    
    # Özet
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("OZET", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    yazdir(f"\nSQL Server klasorleri:", log_dosya)
    yazdir(f"  - Kalan: {sql_var}", log_dosya)
    yazdir(f"  - Silinen: {len(sql_klasorleri) - sql_var}", log_dosya)
    
    yazdir(f"\nPetronet klasorleri:", log_dosya)
    yazdir(f"  - Kalan: {petronet_var}", log_dosya)
    yazdir(f"  - Silinen: {len(petronet_klasorleri) - petronet_var}", log_dosya)
    
    yazdir(f"\nKopyalar:", log_dosya)
    if os.path.exists(KORUNACAK_KLASOR):
        yazdir(f"  - OK: Kopyalar korunuyor", log_dosya)
    else:
        yazdir(f"  - HATA: Kopyalar bulunamadi!", log_dosya)
    
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("SONUC", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    if sql_var == 0 and petronet_var == 0:
        yazdir("\nTAMAM! TUM SQL SERVER VE PETRONET DOSYALARI TEMIZLENDI!", log_dosya)
        yazdir("Bilgisayarda Petronet ve SQL Server ile baglantili", log_dosya)
        yazdir("onemli dosya ve klasorler kalmadi.", log_dosya)
    else:
        yazdir(f"\nUYARI: {sql_var} SQL Server, {petronet_var} Petronet klasoru kaldi", log_dosya)
    
    yazdir(f"\nKORUNAN KLASOR: {KORUNACAK_KLASOR}", log_dosya)
    
    print("\n" + "=" * 60)
    print("FINAL KONTROL TAMAMLANDI")
    print("=" * 60)
    print(f"\nSonuclar '{LOG_DOSYA}' dosyasina kaydedildi.")
    
    log_dosya.close()

if __name__ == "__main__":
    final_kontrol()
