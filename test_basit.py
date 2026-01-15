# -*- coding: utf-8 -*-
import sys

print("TEST: Script calisiyor mu?")
print("=" * 60)

try:
    import pyodbc
    print("OK: pyodbc modulu yuklendi")
    
    SERVER = '127.0.0.1,6543'
    UID = 'sa'
    PWD = 'Petro1410+!'
    DRIVER = 'ODBC Driver 17 for SQL Server'
    
    print("Baglanti deneniyor...")
    conn = pyodbc.connect(
        f'DRIVER={{{DRIVER}}};'
        f'SERVER={SERVER};'
        f'DATABASE=master;'
        f'UID={UID};'
        f'PWD={PWD};'
        f'TrustServerCertificate=yes'
    )
    print("OK: SQL Server'a baglanildi")
    
    cursor = conn.cursor()
    
    # Uzak girişi kapat
    print("\nUzak giris kapatiliyor...")
    cursor.execute("EXEC sp_configure 'remote access', 0")
    cursor.execute("RECONFIGURE")
    print("OK: Uzak giris kapatildi")
    
    cursor.execute("EXEC sp_configure 'remote login timeout', 0")
    cursor.execute("RECONFIGURE")
    print("OK: Remote login kapatildi")
    
    conn.commit()
    conn.close()
    
    print("\n" + "=" * 60)
    print("OK: ISLEM TAMAMLANDI")
    print("=" * 60)
    print("\nNOT: SQL Server'i yeniden baslatmaniz gerekebilir")
    
except Exception as e:
    print(f"HATA: {e}")
    import traceback
    traceback.print_exc()

print("\nCikmak icin Enter'a basin...")
input()
