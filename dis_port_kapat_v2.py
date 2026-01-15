# -*- coding: utf-8 -*-
import pyodbc
import subprocess
import sys
from datetime import datetime

# Çıktıyı hem ekrana hem dosyaya yaz
log_dosya = open('dis_port_kapat_sonuc.txt', 'w', encoding='utf-8')

def yazdir(*args, **kwargs):
    mesaj = ' '.join(str(arg) for arg in args)
    print(mesaj, **kwargs)
    log_dosya.write(mesaj + '\n')
    log_dosya.flush()

yazdir("=" * 60)
yazdir("DIS PORT KAPATMA ISLEMI")
yazdir("=" * 60)
yazdir(f"Tarih: {datetime.now()}")
yazdir("\nUYARI: Bu islem dis portu kapatacak!")
yazdir("Sadece kendi bilgisayarinizdan baglanabileceksiniz!")
yazdir("Uzak bilgisayarlardan baglanilamayacak!\n")

try:
    # Bağlantı bilgileri
    SERVER = '127.0.0.1,6543'
    UID = 'sa'
    PWD = 'Petro1410+!'
    DRIVER = 'ODBC Driver 17 for SQL Server'
    
    yazdir("1. SQL Server'a baglaniyor...")
    conn = pyodbc.connect(
        f'DRIVER={{{DRIVER}}};'
        f'SERVER={SERVER};'
        f'DATABASE=master;'
        f'UID={UID};'
        f'PWD={PWD};'
        f'TrustServerCertificate=yes'
    )
    yazdir("   OK: Baglanti basarili\n")
    
    cursor = conn.cursor()
    
    # Önce mevcut ayarları kontrol et
    yazdir("1.1. Mevcut ayarlar kontrol ediliyor...")
    try:
        cursor.execute("EXEC sp_configure 'remote access'")
        row = cursor.fetchone()
        if row:
            yazdir(f"   Mevcut remote access degeri: {row[1]}")
    except Exception as e:
        yazdir(f"   UYARI: Kontrol edilemedi: {e}")
    
    # Uzak girişi kapat
    yazdir("\n2. Uzak giris kapatiliyor...")
    try:
        cursor.execute("EXEC sp_configure 'remote access', 0")
        yazdir("   sp_configure komutu calistirildi")
        
        cursor.execute("RECONFIGURE")
        yazdir("   RECONFIGURE komutu calistirildi")
        yazdir("   OK: Uzak giris kapatildi\n")
    except Exception as e:
        yazdir(f"   HATA: {e}")
        import traceback
        yazdir(traceback.format_exc())
        raise
    
    # Remote login'i kapat
    yazdir("3. Remote login kapatiliyor...")
    try:
        cursor.execute("EXEC sp_configure 'remote login timeout', 0")
        yazdir("   sp_configure komutu calistirildi")
        
        cursor.execute("RECONFIGURE")
        yazdir("   RECONFIGURE komutu calistirildi")
        yazdir("   OK: Remote login kapatildi\n")
    except Exception as e:
        yazdir(f"   HATA: {e}")
        import traceback
        yazdir(traceback.format_exc())
        raise
    
    yazdir("4. Degisiklikler kaydediliyor...")
    conn.commit()
    yazdir("   OK: Degisiklikler kaydedildi")
    conn.close()
    yazdir("   OK: Baglanti kapatildi\n")
    
    # Firewall'dan da kapat
    yazdir("5. Windows Firewall'dan port kapatiliyor...")
    try:
        result = subprocess.run(
            ['netsh', 'advfirewall', 'firewall', 'add', 'rule',
             'name=SQL Server Port 6543 Block',
             'dir=in',
             'action=block',
             'protocol=TCP',
             'localport=6543'],
            capture_output=True,
            text=True,
            shell=True,
            timeout=10
        )
        if result.returncode == 0:
            yazdir("   OK: Port 6543 engellendi\n")
        else:
            yazdir(f"   UYARI: {result.stderr}")
            yazdir("   Yonetici yetkisi gerekebilir!\n")
    except subprocess.TimeoutExpired:
        yazdir("   HATA: Firewall komutu zaman asimi!")
    except Exception as e:
        yazdir(f"   HATA: {e}")
        yazdir("   Yonetici yetkisi gerekebilir!\n")
    
    yazdir("=" * 60)
    yazdir("OK: ISLEM TAMAMLANDI")
    yazdir("=" * 60)
    yazdir("\nONEMLI:")
    yazdir("   1. SQL Server'i yeniden baslatmaniz gerekebilir")
    yazdir("   2. Ic port (127.0.0.1) hala acik - Petronet calismaya devam edecek")
    yazdir("   3. Dis port (uzak baglantilar) kapatildi")
    
except Exception as e:
    yazdir(f"\nHATA: {e}")
    import traceback
    yazdir(traceback.format_exc())

log_dosya.close()

print("\n" + "=" * 60)
print("ISLEM TAMAMLANDI!")
print("Sonuclar 'dis_port_kapat_sonuc.txt' dosyasina kaydedildi.")
print("=" * 60)
print("\nCikmak icin Enter'a basin...")
input()
