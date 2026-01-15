# -*- coding: utf-8 -*-
import pyodbc

SERVER = '127.0.0.1,6543'
UID = 'sa'
PWD = 'Petro1410+!'
DRIVER = 'ODBC Driver 17 for SQL Server'

print("=" * 60)
print("SQL SERVER PORT DURUMU KONTROLU")
print("=" * 60)

try:
    conn = pyodbc.connect(
        f'DRIVER={{{DRIVER}}};'
        f'SERVER={SERVER};'
        f'DATABASE=master;'
        f'UID={UID};'
        f'PWD={PWD};'
        f'TrustServerCertificate=yes'
    )
    print("OK: Baglanti basarili\n")
    
    cursor = conn.cursor()
    
    # Remote access durumu
    print("1. REMOTE ACCESS DURUMU:")
    cursor.execute("EXEC sp_configure 'remote access'")
    rows = cursor.fetchall()
    for row in rows:
        if row[0] == 'remote access':
            print(f"   Deger: {row[1]} (0=Kapali, 1=Acik)")
            print(f"   Config Degeri: {row[2]}")
            print(f"   Run Degeri: {row[3]}")
    
    # Remote login timeout
    print("\n2. REMOTE LOGIN TIMEOUT:")
    cursor.execute("EXEC sp_configure 'remote login timeout'")
    rows = cursor.fetchall()
    for row in rows:
        if row[0] == 'remote login timeout':
            print(f"   Deger: {row[1]} saniye")
            print(f"   Config Degeri: {row[2]}")
            print(f"   Run Degeri: {row[3]}")
    
    # IsRemoteLoginEnabled
    print("\n3. SERVERPROPERTY KONTROLU:")
    cursor.execute("SELECT SERVERPROPERTY('IsRemoteLoginEnabled') as IsRemoteLoginEnabled")
    row = cursor.fetchone()
    if row:
        print(f"   IsRemoteLoginEnabled: {row[0]} (1=Acik, 0=Kapali)")
    
    conn.close()
    print("\n" + "=" * 60)
    print("KONTROL TAMAMLANDI")
    print("=" * 60)
    
except Exception as e:
    print(f"HATA: {e}")
    import traceback
    traceback.print_exc()

input("\nCikmak icin Enter'a basin...")
