# -*- coding: utf-8 -*-
"""
SQL Server ve Petronet Dosyalarını Bul ve Sil - V2
Kopyalar hariç tüm SQL Server dosyalarını sil
"""
import os
import shutil
import subprocess
from datetime import datetime
import sys

sys.stdout.reconfigure(encoding='utf-8', errors='replace')

LOG_DOSYA = 'sql_server_dosya_silme_sonuc.txt'
KORUNACAK_KLASOR = r'D:\tayfun\ozgur_sistem_kopyasi'

def yazdir(mesaj, dosya=None):
    """Ekrana ve dosyaya yaz"""
    print(mesaj, flush=True)
    if dosya:
        dosya.write(mesaj + '\n')
        dosya.flush()

def sql_servis_durdur(log_dosya):
    """SQL Server servislerini durdur"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("SQL SERVER SERVISLERI DURDURMA", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    servisler = ['MSSQLSERVER', 'MSSQL$PETROSQL', 'SQLSERVERAGENT', 'SQLBrowser']
    
    for servis in servisler:
        try:
            yazdir(f"\n   {servis} servisi durduruluyor...", log_dosya)
            result = subprocess.run(
                ['net', 'stop', servis],
                capture_output=True,
                text=True,
                timeout=30
            )
            if result.returncode == 0:
                yazdir(f"   OK: {servis} durduruldu", log_dosya)
            else:
                yazdir(f"   NOT: {servis} durdurulamadi (zaten durmus olabilir)", log_dosya)
        except Exception as e:
            yazdir(f"   NOT: {servis} - {str(e)}", log_dosya)

def klasor_sil(yol, log_dosya):
    """Klasörü sil (korunacak klasör hariç)"""
    try:
        # Korunacak klasör kontrolü
        if KORUNACAK_KLASOR and yol.startswith(KORUNACAK_KLASOR):
            yazdir(f"   KORUNDU: {yol}", log_dosya)
            return False
        
        if os.path.exists(yol):
            yazdir(f"   Siliniyor: {yol}", log_dosya)
            shutil.rmtree(yol, ignore_errors=True)
            yazdir(f"   OK: {yol} silindi", log_dosya)
            return True
        return False
    except Exception as e:
        yazdir(f"   HATA: {yol} silinemedi: {str(e)}", log_dosya)
        return False

def dosya_sil(yol, log_dosya):
    """Dosyayı sil (korunacak klasör hariç)"""
    try:
        # Korunacak klasör kontrolü
        if KORUNACAK_KLASOR and yol.startswith(KORUNACAK_KLASOR):
            yazdir(f"   KORUNDU: {yol}", log_dosya)
            return False
        
        if os.path.exists(yol):
            yazdir(f"   Siliniyor: {yol}", log_dosya)
            os.remove(yol)
            yazdir(f"   OK: {yol} silindi", log_dosya)
            return True
        return False
    except Exception as e:
        yazdir(f"   HATA: {yol} silinemedi: {str(e)}", log_dosya)
        return False

def sql_server_klasorleri_sil(log_dosya):
    """SQL Server klasörlerini sil"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("SQL SERVER KLASORLERI SILME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    # SQL Server kurulum klasörleri
    sql_klasorleri = [
        r'C:\Program Files\Microsoft SQL Server',
        r'C:\Program Files (x86)\Microsoft SQL Server',
        r'D:\Program Files\Microsoft SQL Server',
        r'D:\Program Files (x86)\Microsoft SQL Server',
        r'C:\ProgramData\Microsoft\Microsoft SQL Server',
        r'D:\ProgramData\Microsoft\Microsoft SQL Server',
    ]
    
    silinen = 0
    for klasor in sql_klasorleri:
        if klasor_sil(klasor, log_dosya):
            silinen += 1
    
    yazdir(f"\n   Toplam {silinen} SQL Server klasoru silindi", log_dosya)
    return silinen

def petronet_klasorleri_sil(log_dosya):
    """Petronet klasörlerini sil"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("PETRONET KLASORLERI SILME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    # Petronet klasörleri
    petronet_klasorleri = [
        r'C:\Petronet',
        r'D:\Petronet',
        r'C:\Program Files\Petronet',
        r'D:\Program Files\Petronet',
        r'C:\Program Files (x86)\Petronet',
        r'D:\Program Files (x86)\Petronet',
    ]
    
    silinen = 0
    for klasor in petronet_klasorleri:
        if klasor_sil(klasor, log_dosya):
            silinen += 1
    
    yazdir(f"\n   Toplam {silinen} Petronet klasoru silindi", log_dosya)
    return silinen

def sql_server_dosyalari_sil():
    """SQL Server ve Petronet dosyalarını sil"""
    print("=" * 60)
    print("SQL SERVER VE PETRONET DOSYALARI SILME")
    print("=" * 60)
    print(f"Tarih: {datetime.now()}\n")
    print(f"KORUNACAK KLASOR: {KORUNACAK_KLASOR}\n")
    
    log_dosya = open(LOG_DOSYA, 'w', encoding='utf-8')
    
    yazdir("=" * 60, log_dosya)
    yazdir("SQL SERVER VE PETRONET DOSYALARI SILME", log_dosya)
    yazdir("=" * 60, log_dosya)
    yazdir(f"Tarih: {datetime.now()}", log_dosya)
    yazdir(f"KORUNACAK KLASOR: {KORUNACAK_KLASOR}", log_dosya)
    
    try:
        # 1. SQL Server servislerini durdur
        sql_servis_durdur(log_dosya)
        
        # 2. SQL Server klasörlerini sil
        sql_silinen = sql_server_klasorleri_sil(log_dosya)
        
        # 3. Petronet klasörlerini sil
        petronet_silinen = petronet_klasorleri_sil(log_dosya)
        
        yazdir("\n" + "=" * 60, log_dosya)
        yazdir("SILME TAMAMLANDI", log_dosya)
        yazdir("=" * 60, log_dosya)
        yazdir(f"\nToplam silinen:", log_dosya)
        yazdir(f"  - SQL Server klasorleri: {sql_silinen}", log_dosya)
        yazdir(f"  - Petronet klasorleri: {petronet_silinen}", log_dosya)
        yazdir(f"\nKORUNAN KLASOR: {KORUNACAK_KLASOR}", log_dosya)
        
        print("\n" + "=" * 60)
        print("SILME TAMAMLANDI")
        print("=" * 60)
        print(f"\nSonuclar '{LOG_DOSYA}' dosyasina kaydedildi.")
        print(f"\nKORUNAN KLASOR: {KORUNACAK_KLASOR}")
        
    except Exception as e:
        yazdir(f"\nHATA: {str(e)}", log_dosya)
        import traceback
        yazdir(traceback.format_exc(), log_dosya)
        print(f"\nHATA: {e}")
    finally:
        log_dosya.close()

if __name__ == "__main__":
    sql_server_dosyalari_sil()
