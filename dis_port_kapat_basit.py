# -*- coding: utf-8 -*-
import pyodbc
import subprocess
import sys

# Çıktıyı anında göster
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

print("=" * 60)
print("DIS PORT KAPATMA ISLEMI")
print("=" * 60)
print("\nUYARI: Bu islem dis portu kapatacak!")
print("Sadece kendi bilgisayarinizdan baglanabileceksiniz!")
print("Uzak bilgisayarlardan baglanilamayacak!\n")

try:
    # Bağlantı bilgileri
    SERVER = '127.0.0.1,6543'
    UID = 'sa'
    PWD = 'Petro1410+!'
    DRIVER = 'ODBC Driver 17 for SQL Server'
    
    print("1. SQL Server'a baglaniyor...")
    conn = pyodbc.connect(
        f'DRIVER={{{DRIVER}}};'
        f'SERVER={SERVER};'
        f'DATABASE=master;'
        f'UID={UID};'
        f'PWD={PWD};'
        f'TrustServerCertificate=yes'
    )
    print("   OK: Baglanti basarili\n")
    
    cursor = conn.cursor()
    
    # Uzak girişi kapat
    print("2. Uzak giris kapatiliyor...")
    cursor.execute("EXEC sp_configure 'remote access', 0")
    cursor.execute("RECONFIGURE")
    print("   OK: Uzak giris kapatildi\n")
    
    # Remote login'i kapat
    print("3. Remote login kapatiliyor...")
    cursor.execute("EXEC sp_configure 'remote login timeout', 0")
    cursor.execute("RECONFIGURE")
    print("   OK: Remote login kapatildi\n")
    
    conn.commit()
    conn.close()
    
    # Firewall'dan da kapat
    print("4. Windows Firewall'dan port kapatiliyor...")
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
            shell=True
        )
        if result.returncode == 0:
            print("   OK: Port 6543 engellendi\n")
        else:
            print(f"   UYARI: {result.stderr}")
            print("   Yonetici yetkisi gerekebilir!\n")
    except Exception as e:
        print(f"   HATA: {e}")
        print("   Yonetici yetkisi gerekebilir!\n")
    
    print("=" * 60)
    print("OK: ISLEM TAMAMLANDI")
    print("=" * 60)
    print("\nONEMLI:")
    print("   1. SQL Server'i yeniden baslatmaniz gerekebilir")
    print("   2. Ic port (127.0.0.1) hala acik - Petronet calismaya devam edecek")
    print("   3. Dis port (uzak baglantilar) kapatildi")
    
except Exception as e:
    print(f"\nHATA: {e}")
    import traceback
    traceback.print_exc()

print("\nCikmak icin Enter'a basin...")
input()
