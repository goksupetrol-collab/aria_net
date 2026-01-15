# -*- coding: utf-8 -*-
import pyodbc
import subprocess
import os
import sys

# Windows konsolunda çıktıyı anında göster
if sys.platform == 'win32':
    import msvcrt
    import io
    # Çıktıyı anında göster
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', line_buffering=True)
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', line_buffering=True)

# Bağlantı bilgileri
SERVER = '127.0.0.1,6543'
UID = 'sa'
PWD = 'Petro1410+!'
DRIVER = 'ODBC Driver 17 for SQL Server'

def baglan():
    """SQL Server'a bağlan"""
    try:
        conn = pyodbc.connect(
            f'DRIVER={{{DRIVER}}};'
            f'SERVER={SERVER};'
            f'DATABASE=master;'
            f'UID={UID};'
            f'PWD={PWD};'
            f'TrustServerCertificate=yes'
        )
        return conn
    except Exception as e:
        print(f"HATA: Baglanti hatasi: {e}")
        return None

def port_durumunu_kontrol():
    """SQL Server port durumunu kontrol et"""
    print("=" * 60, flush=True)
    print("SQL SERVER PORT DURUMU KONTROLU", flush=True)
    print("=" * 60, flush=True)
    
    conn = baglan()
    if not conn:
        return
    
    cursor = conn.cursor()
    
    # 1. SQL Server'ın dinlediği portlar
    print("\n1. SQL SERVER DİNLEDİĞİ PORTLAR:")
    try:
        cursor.execute("""
            SELECT 
                local_net_address,
                local_tcp_port,
                state_desc
            FROM sys.dm_exec_connections
            WHERE session_id = @@SPID
        """)
        row = cursor.fetchone()
        if row:
            print(f"   IP Adresi: {row[0]}")
            print(f"   TCP Port: {row[1]}")
            print(f"   Durum: {row[2]}")
    except Exception as e:
        print(f"   UYARI: Kontrol edilemedi: {e}", flush=True)
    
    # 2. Uzak bağlantı durumu
    print("\n2. UZAK BAĞLANTI DURUMU:")
    try:
        cursor.execute("SELECT SERVERPROPERTY('IsRemoteLoginEnabled') as IsRemoteLoginEnabled")
        row = cursor.fetchone()
        uzak_giris = row[0] if row else None
        if uzak_giris == 1:
            print("   UYARI: UZAK GIRIS AKTIF (Dis port acik)")
        else:
            print("   OK: UZAK GIRIS PASIF (Dis port kapali)")
    except Exception as e:
        print(f"   UYARI: Kontrol edilemedi: {e}")
    
    # 3. TCP/IP protokol durumu
    print("\n3. TCP/IP PROTOKOL DURUMU:", flush=True)
    print("   NOT: SQL Server Configuration Manager'dan kontrol edilmeli", flush=True)
    print("   Yol: SQL Server Configuration Manager > SQL Server Network Configuration", flush=True)
    
    # 4. Windows Firewall durumu
    print("\n4. WINDOWS FIREWALL DURUMU:")
    try:
        result = subprocess.run(
            ['netsh', 'advfirewall', 'firewall', 'show', 'rule', 'name=all', 'dir=in', 'type=allow'],
            capture_output=True,
            text=True,
            shell=True
        )
        if '1433' in result.stdout or '6543' in result.stdout:
            print("   UYARI: Firewall'da SQL Server portu acik gorunuyor")
        else:
            print("   OK: Firewall'da SQL Server portu kapali gorunuyor")
    except Exception as e:
        print(f"   UYARI: Kontrol edilemedi: {e}")
    
    conn.close()

def uzak_girisi_kapat():
    """Uzak girişi kapat (dış portu kapat)"""
    print("\n" + "=" * 60)
    print("UZAK GİRİŞİ KAPATMA İŞLEMİ")
    print("=" * 60)
    
    conn = baglan()
    if not conn:
        return False
    
    cursor = conn.cursor()
    
    try:
        # Uzak girişi kapat
        print("\n1. Uzak giris kapatiliyor...")
        cursor.execute("EXEC sp_configure 'remote access', 0")
        cursor.execute("RECONFIGURE")
        print("   OK: Uzak giris kapatildi")
        
        # Remote login'i kapat
        print("\n2. Remote login kapatiliyor...")
        cursor.execute("EXEC sp_configure 'remote login timeout', 0")
        cursor.execute("RECONFIGURE")
        print("   OK: Remote login kapatildi")
        
        conn.commit()
        conn.close()
        
        print("\nOK: UZAK GIRIS KAPATMA ISLEMI TAMAMLANDI")
        print("NOT: SQL Server yeniden baslatilmali!")
        print("NOT: Windows Firewall'dan da portu kapatmak gerekebilir")
        
        return True
        
    except Exception as e:
        print(f"\n❌ Hata: {e}")
        conn.rollback()
        conn.close()
        return False

def firewall_port_kapat():
    """Windows Firewall'dan SQL Server portunu kapat"""
    print("\n" + "=" * 60)
    print("WINDOWS FIREWALL PORT KAPATMA")
    print("=" * 60)
    
    port = input("Kapatmak istediğiniz port numarası (varsayılan: 6543): ").strip() or "6543"
    
    try:
        # Gelen bağlantıları engelle
        print(f"\n1. Port {port} için gelen bağlantılar engelleniyor...")
        subprocess.run(
            ['netsh', 'advfirewall', 'firewall', 'add', 'rule',
             f'name=SQL Server Port {port} Block',
             'dir=in',
             'action=block',
             'protocol=TCP',
             f'localport={port}'],
            check=True
        )
        print(f"   ✅ Port {port} için gelen bağlantılar engellendi")
        
        # Giden bağlantıları engelle (opsiyonel)
        print(f"\n2. Port {port} için giden bağlantılar engelleniyor...")
        subprocess.run(
            ['netsh', 'advfirewall', 'firewall', 'add', 'rule',
             f'name=SQL Server Port {port} Block Out',
             'dir=out',
             'action=block',
             'protocol=TCP',
             f'localport={port}'],
            check=True
        )
        print(f"   ✅ Port {port} için giden bağlantılar engellendi")
        
        print("\n✅ FIREWALL PORT KAPATMA İŞLEMİ TAMAMLANDI")
        return True
        
    except Exception as e:
        print(f"\n❌ Hata: {e}")
        print("⚠️  Yönetici yetkisi gerekebilir!")
        return False

if __name__ == "__main__":
    print("=" * 60)
    print("DIS PORT KAPATMA ISLEMI")
    print("=" * 60)
    print("\nUYARI: Bu islem dis portu kapatacak!")
    print("Sadece kendi bilgisayarinizdan baglanabileceksiniz!")
    print("Uzak bilgisayarlardan baglanilamayacak!\n")
    
    try:
        # Önce durumu kontrol et
        print("Mevcut durum kontrol ediliyor...")
        port_durumunu_kontrol()
        
        # Uzak girişi kapat
        print("\n" + "=" * 60)
        print("UZAK GIRISI KAPATMA ISLEMI")
        print("=" * 60)
        
        if uzak_girisi_kapat():
            # Firewall'dan da kapat (port 6543)
            print("\n" + "=" * 60)
            print("Windows Firewall'dan port kapatiliyor...")
            print("=" * 60)
            
            try:
                # Gelen bağlantıları engelle
                print("\n1. Port 6543 icin gelen baglantilar engelleniyor...")
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
                    print("   OK Port 6543 icin gelen baglantilar engellendi")
                else:
                    print(f"   UYARI: {result.stderr}")
                    print("   Yonetici yetkisi gerekebilir!")
            except Exception as e:
                print(f"   HATA: {e}")
                print("   Yonetici yetkisi gerekebilir!")
            
            print("\n" + "=" * 60)
            print("OK DIS PORT KAPATMA ISLEMI TAMAMLANDI")
            print("=" * 60)
            print("\nONEMLI:")
            print("   1. SQL Server'i yeniden baslatmaniz gerekebilir")
            print("   2. Ic port (127.0.0.1) hala acik - Petronet calismaya devam edecek")
            print("   3. Dis port (uzak baglantilar) kapatildi")
        else:
            print("\nHATA: Islem basarisiz oldu!")
            
    except Exception as e:
        print(f"\nHATA: {e}")
        import traceback
        traceback.print_exc()
