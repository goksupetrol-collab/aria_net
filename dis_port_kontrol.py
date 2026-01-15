# -*- coding: utf-8 -*-
import pyodbc
import subprocess

SERVER = '127.0.0.1,6543'
UID = 'sa'
PWD = 'Petro1410+!'
DRIVER = 'ODBC Driver 17 for SQL Server'

print("=" * 60)
print("DIS PORT KONTROLU")
print("=" * 60)

try:
    # SQL Server'a bağlan
    print("\n1. SQL Server'a baglaniyor...")
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
    
    # Remote access durumu
    print("2. REMOTE ACCESS DURUMU:")
    cursor.execute("EXEC sp_configure 'remote access'")
    rows = cursor.fetchall()
    for row in rows:
        if row[0] == 'remote access':
            deger = row[1]
            config_deger = row[2]
            run_deger = row[3]
            print(f"   Config Degeri: {config_deger} (0=Kapali, 1=Acik)")
            print(f"   Run Degeri: {run_deger} (0=Kapali, 1=Acik)")
            if run_deger == 0:
                print("   SONUC: DIS PORT KAPALI")
            else:
                print("   SONUC: DIS PORT ACIK!")
    
    # Remote login timeout
    print("\n3. REMOTE LOGIN TIMEOUT:")
    cursor.execute("EXEC sp_configure 'remote login timeout'")
    rows = cursor.fetchall()
    for row in rows:
        if row[0] == 'remote login timeout':
            print(f"   Deger: {row[1]} saniye")
    
    # IsRemoteLoginEnabled
    print("\n4. SERVERPROPERTY KONTROLU:")
    cursor.execute("SELECT SERVERPROPERTY('IsRemoteLoginEnabled') as IsRemoteLoginEnabled")
    row = cursor.fetchone()
    if row:
        deger = row[0]
        print(f"   IsRemoteLoginEnabled: {deger} (1=Acik, 0=Kapali)")
        if deger == 0:
            print("   SONUC: DIS PORT KAPALI")
        else:
            print("   SONUC: DIS PORT ACIK!")
    
    conn.close()
    
    # Port dinleme durumu
    print("\n5. PORT DINLEME DURUMU:")
    try:
        result = subprocess.run(
            ['netstat', '-an'],
            capture_output=True,
            text=True,
            shell=True
        )
        port_satirlari = [satir for satir in result.stdout.split('\n') if '6543' in satir]
        if port_satirlari:
            print("   Bulunan port baglantilari:")
            for satir in port_satirlari:
                print(f"   {satir.strip()}")
                if '0.0.0.0:6543' in satir or ':::6543' in satir:
                    print("   UYARI: Tum IP'lerden dinleniyor (DIS PORT ACIK!)")
                elif '127.0.0.1:6543' in satir:
                    print("   OK: Sadece localhost'tan dinleniyor (DIS PORT KAPALI)")
        else:
            print("   Port 6543 dinlenmiyor")
    except Exception as e:
        print(f"   HATA: {e}")
    
    # Firewall durumu
    print("\n6. WINDOWS FIREWALL DURUMU:")
    try:
        result = subprocess.run(
            ['netsh', 'advfirewall', 'firewall', 'show', 'rule', 'name=all', 'dir=in'],
            capture_output=True,
            text=True,
            shell=True
        )
        if '6543' in result.stdout:
            print("   Port 6543 ile ilgili firewall kurallari var")
            # Block kuralı var mı kontrol et
            result_block = subprocess.run(
                ['netsh', 'advfirewall', 'firewall', 'show', 'rule', 'name="SQL Server Port 6543 Block"'],
                capture_output=True,
                text=True,
                shell=True
            )
            if result_block.returncode == 0:
                print("   OK: Port 6543 engelleme kurali mevcut")
            else:
                print("   UYARI: Port 6543 engelleme kurali yok")
        else:
            print("   UYARI: Port 6543 ile ilgili firewall kurali yok")
    except Exception as e:
        print(f"   HATA: {e}")
    
    print("\n" + "=" * 60)
    print("KONTROL TAMAMLANDI")
    print("=" * 60)
    
except Exception as e:
    print(f"\nHATA: {e}")
    import traceback
    traceback.print_exc()

input("\nCikmak icin Enter'a basin...")
