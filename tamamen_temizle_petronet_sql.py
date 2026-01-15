# -*- coding: utf-8 -*-
"""
Petronet ve SQL Server Tamamen Temizleme Scripti
Masaüstü, C, D dahil tüm dosyalar, klasörler, exe'ler, bağlantılar
"""
import os
import shutil
import subprocess
from datetime import datetime
import sys
import winreg

sys.stdout.reconfigure(encoding='utf-8', errors='replace')

LOG_DOSYA = 'tamamen_temizleme_sonuc.txt'
KORUNACAK_KLASOR = r'D:\tayfun\ozgur_sistem_kopyasi'

def yazdir(mesaj, dosya=None):
    """Ekrana ve dosyaya yaz"""
    print(mesaj, flush=True)
    if dosya:
        dosya.write(mesaj + '\n')
        dosya.flush()

def klasor_sil(yol, log_dosya):
    """Klasörü sil (korunacak klasör hariç)"""
    try:
        if KORUNACAK_KLASOR and yol.startswith(KORUNACAK_KLASOR):
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
        if KORUNACAK_KLASOR and yol.startswith(KORUNACAK_KLASOR):
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

def servisleri_durdur_ve_kaldir(log_dosya):
    """SQL Server servislerini durdur ve kaldır"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("SQL SERVER SERVISLERI DURDURMA VE KALDIRMA", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    servisler = ['MSSQLSERVER', 'MSSQL$PETROSQL', 'SQLSERVERAGENT', 'SQLBrowser']
    
    for servis in servisler:
        try:
            # Servisi durdur
            yazdir(f"\n   {servis} servisi durduruluyor...", log_dosya)
            subprocess.run(['net', 'stop', servis], capture_output=True, timeout=30)
            
            # Servisi kaldır
            yazdir(f"   {servis} servisi kaldiriliyor...", log_dosya)
            result = subprocess.run(
                ['sc', 'delete', servis],
                capture_output=True,
                text=True,
                timeout=30
            )
            if result.returncode == 0:
                yazdir(f"   OK: {servis} kaldirildi", log_dosya)
            else:
                yazdir(f"   NOT: {servis} kaldirilemedi", log_dosya)
        except Exception as e:
            yazdir(f"   HATA: {servis} - {str(e)}", log_dosya)

def petronet_sql_bul_ve_sil(arama_yolu, log_dosya):
    """Petronet ve SQL Server dosyalarını bul ve sil"""
    yazdir(f"\n   Araniyor: {arama_yolu}", log_dosya)
    
    silinen_dosya = 0
    silinen_klasor = 0
    
    if not os.path.exists(arama_yolu):
        return silinen_dosya, silinen_klasor
    
    try:
        for root, dirs, files in os.walk(arama_yolu):
            # Korunacak klasörü atla
            if KORUNACAK_KLASOR and root.startswith(KORUNACAK_KLASOR):
                dirs[:] = []  # Alt klasörlere girme
                continue
            
            # Petronet veya SQL Server içeren klasörleri sil
            for dir_name in dirs[:]:
                if 'petronet' in dir_name.lower() or 'petro' in dir_name.lower() or 'sql' in dir_name.lower():
                    tam_yol = os.path.join(root, dir_name)
                    if klasor_sil(tam_yol, log_dosya):
                        silinen_klasor += 1
                        dirs.remove(dir_name)  # Listeden çıkar
            
            # Petronet veya SQL Server içeren dosyaları sil
            for file_name in files:
                if any(keyword in file_name.lower() for keyword in ['petronet', 'petro', 'sql', '.mdf', '.ldf', '.bak']):
                    tam_yol = os.path.join(root, file_name)
                    if dosya_sil(tam_yol, log_dosya):
                        silinen_dosya += 1
    except Exception as e:
        yazdir(f"   UYARI: {arama_yolu} taranamadi: {str(e)}", log_dosya)
    
    return silinen_dosya, silinen_klasor

def masaustu_temizle(log_dosya):
    """Masaüstünü temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("MASUSTU TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    masaustu_yollari = [
        os.path.join(os.path.expanduser('~'), 'Desktop'),
        os.path.join(os.path.expanduser('~'), 'Masaüstü'),
        r'C:\Users\Public\Desktop',
    ]
    
    silinen = 0
    for masaustu in masaustu_yollari:
        if os.path.exists(masaustu):
            for item in os.listdir(masaustu):
                tam_yol = os.path.join(masaustu, item)
                if any(keyword in item.lower() for keyword in ['petronet', 'petro', 'sql']):
                    if os.path.isdir(tam_yol):
                        if klasor_sil(tam_yol, log_dosya):
                            silinen += 1
                    else:
                        if dosya_sil(tam_yol, log_dosya):
                            silinen += 1
    
    yazdir(f"\n   Toplam {silinen} masaustu ogesi silindi", log_dosya)
    return silinen

def program_files_temizle(log_dosya):
    """Program Files klasörlerini temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("PROGRAM FILES TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    program_klasorleri = [
        r'C:\Program Files',
        r'C:\Program Files (x86)',
        r'D:\Program Files',
        r'D:\Program Files (x86)',
        r'C:\ProgramData',
        r'D:\ProgramData',
    ]
    
    silinen_dosya = 0
    silinen_klasor = 0
    
    for klasor in program_klasorleri:
        dosya, klasor_sayisi = petronet_sql_bul_ve_sil(klasor, log_dosya)
        silinen_dosya += dosya
        silinen_klasor += klasor_sayisi
    
    yazdir(f"\n   Toplam {silinen_dosya} dosya, {silinen_klasor} klasor silindi", log_dosya)
    return silinen_dosya, silinen_klasor

def appdata_temizle(log_dosya):
    """AppData klasörlerini temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("APPDATA TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    appdata_yollari = [
        os.path.join(os.path.expanduser('~'), 'AppData', 'Local'),
        os.path.join(os.path.expanduser('~'), 'AppData', 'Roaming'),
        os.path.join(os.path.expanduser('~'), 'AppData', 'LocalLow'),
    ]
    
    silinen_dosya = 0
    silinen_klasor = 0
    
    for yol in appdata_yollari:
        if os.path.exists(yol):
            dosya, klasor_sayisi = petronet_sql_bul_ve_sil(yol, log_dosya)
            silinen_dosya += dosya
            silinen_klasor += klasor_sayisi
    
    yazdir(f"\n   Toplam {silinen_dosya} dosya, {silinen_klasor} klasor silindi", log_dosya)
    return silinen_dosya, silinen_klasor

def kok_dizinler_temizle(log_dosya):
    """C ve D kök dizinlerini temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("KOK DIZINLER TEMIZLEME (C: ve D:)", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    kok_dizinler = [r'C:\\', r'D:\\']
    
    silinen_dosya = 0
    silinen_klasor = 0
    
    for kok in kok_dizinler:
        if os.path.exists(kok):
            # Sadece kök dizindeki dosya/klasörleri kontrol et (derinlemesine değil)
            try:
                for item in os.listdir(kok):
                    tam_yol = os.path.join(kok, item)
                    if any(keyword in item.lower() for keyword in ['petronet', 'petro', 'sql']):
                        if os.path.isdir(tam_yol):
                            if klasor_sil(tam_yol, log_dosya):
                                silinen_klasor += 1
                        else:
                            if dosya_sil(tam_yol, log_dosya):
                                silinen_dosya += 1
            except Exception as e:
                yazdir(f"   UYARI: {kok} okunamadi: {str(e)}", log_dosya)
    
    yazdir(f"\n   Toplam {silinen_dosya} dosya, {silinen_klasor} klasor silindi", log_dosya)
    return silinen_dosya, silinen_klasor

def registry_temizle(log_dosya):
    """Registry kayıtlarını temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("REGISTRY TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    registry_yollari = [
        (winreg.HKEY_LOCAL_MACHINE, r'SOFTWARE\Microsoft\Microsoft SQL Server'),
        (winreg.HKEY_LOCAL_MACHINE, r'SOFTWARE\Petronet'),
        (winreg.HKEY_CURRENT_USER, r'SOFTWARE\Microsoft\Microsoft SQL Server'),
        (winreg.HKEY_CURRENT_USER, r'SOFTWARE\Petronet'),
    ]
    
    silinen = 0
    for hkey, path in registry_yollari:
        try:
            yazdir(f"\n   Registry temizleniyor: {path}", log_dosya)
            key = winreg.OpenKey(hkey, path, 0, winreg.KEY_ALL_ACCESS)
            winreg.DeleteKey(key, '')
            winreg.CloseKey(key)
            yazdir(f"   OK: {path} silindi", log_dosya)
            silinen += 1
        except Exception as e:
            yazdir(f"   NOT: {path} silinemedi: {str(e)}", log_dosya)
    
    yazdir(f"\n   Toplam {silinen} registry kaydi silindi", log_dosya)
    return silinen

def tamamen_temizle():
    """Petronet ve SQL Server'ı tamamen temizle"""
    print("=" * 60)
    print("PETRONET VE SQL SERVER TAMAMEN TEMIZLEME")
    print("=" * 60)
    print(f"Tarih: {datetime.now()}\n")
    print(f"KORUNACAK KLASOR: {KORUNACAK_KLASOR}\n")
    
    log_dosya = open(LOG_DOSYA, 'w', encoding='utf-8')
    
    yazdir("=" * 60, log_dosya)
    yazdir("PETRONET VE SQL SERVER TAMAMEN TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    yazdir(f"Tarih: {datetime.now()}", log_dosya)
    yazdir(f"KORUNACAK KLASOR: {KORUNACAK_KLASOR}", log_dosya)
    
    try:
        # 1. Servisleri durdur ve kaldır
        servisleri_durdur_ve_kaldir(log_dosya)
        
        # 2. Masaüstünü temizle
        masaustu_silinen = masaustu_temizle(log_dosya)
        
        # 3. Program Files temizle
        pf_dosya, pf_klasor = program_files_temizle(log_dosya)
        
        # 4. AppData temizle
        appdata_dosya, appdata_klasor = appdata_temizle(log_dosya)
        
        # 5. Kök dizinler temizle
        kok_dosya, kok_klasor = kok_dizinler_temizle(log_dosya)
        
        # 6. Registry temizle
        registry_silinen = registry_temizle(log_dosya)
        
        yazdir("\n" + "=" * 60, log_dosya)
        yazdir("TEMIZLEME TAMAMLANDI", log_dosya)
        yazdir("=" * 60, log_dosya)
        yazdir(f"\nToplam silinen:", log_dosya)
        yazdir(f"  - Masaustu ogeleri: {masaustu_silinen}", log_dosya)
        yazdir(f"  - Program Files dosyalari: {pf_dosya}", log_dosya)
        yazdir(f"  - Program Files klasorleri: {pf_klasor}", log_dosya)
        yazdir(f"  - AppData dosyalari: {appdata_dosya}", log_dosya)
        yazdir(f"  - AppData klasorleri: {appdata_klasor}", log_dosya)
        yazdir(f"  - Kok dizin dosyalari: {kok_dosya}", log_dosya)
        yazdir(f"  - Kok dizin klasorleri: {kok_klasor}", log_dosya)
        yazdir(f"  - Registry kayitlari: {registry_silinen}", log_dosya)
        yazdir(f"\nKORUNAN KLASOR: {KORUNACAK_KLASOR}", log_dosya)
        
        print("\n" + "=" * 60)
        print("TEMIZLEME TAMAMLANDI")
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
    tamamen_temizle()
