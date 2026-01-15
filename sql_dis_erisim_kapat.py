# -*- coding: utf-8 -*-
"""
SQL Server Dış Erişimi Tamamen Kapatma Scripti
Configuration Manager olmadan çalışır
"""
import subprocess
import winreg
import os
import sys
import time

def yonetici_kontrol():
    """Yönetici yetkisi kontrolü"""
    try:
        return os.getuid() == 0
    except AttributeError:
        import ctypes
        return ctypes.windll.shell32.IsUserAnAdmin() != 0

def port_tespit():
    """SQL Server'ın dinlediği portu tespit et"""
    print("=" * 60)
    print("1. SQL SERVER PORT TESPITI")
    print("=" * 60)
    
    try:
        # netstat ile dinlenen portları listele
        result = subprocess.run(
            ['netstat', '-ano'],
            capture_output=True,
            text=True,
            shell=True
        )
        
        # sqlservr.exe'nin PID'sini bul
        tasklist_result = subprocess.run(
            ['tasklist', '/FI', 'IMAGENAME eq sqlservr.exe', '/FO', 'CSV'],
            capture_output=True,
            text=True,
            shell=True
        )
        
        sql_pids = []
        for satir in tasklist_result.stdout.split('\n'):
            if 'sqlservr.exe' in satir and 'PID' not in satir:
                try:
                    # CSV formatından PID çıkar
                    parts = satir.split(',')
                    if len(parts) > 1:
                        pid = parts[1].strip('"')
                        sql_pids.append(pid)
                except:
                    pass
        
        print(f"   Bulunan SQL Server PID'leri: {sql_pids}")
        
        # Portları bul
        sql_ports = []
        for satir in result.stdout.split('\n'):
            if 'LISTENING' in satir:
                for pid in sql_pids:
                    if pid in satir:
                        # Port numarasını çıkar
                        parts = satir.split()
                        if len(parts) >= 2:
                            try:
                                ip_port = parts[1]
                                if ':' in ip_port:
                                    port = ip_port.split(':')[-1]
                                    if port not in sql_ports:
                                        sql_ports.append(port)
                                        print(f"   Bulunan port: {port} (PID: {pid})")
                            except:
                                pass
        
        if not sql_ports:
            # Varsayılan portları kontrol et
            print("   SQL Server portu otomatik bulunamadı.")
            print("   Varsayılan portlar kontrol ediliyor...")
            for port in ['6543', '1433', '1434']:
                result_port = subprocess.run(
                    ['netstat', '-ano', '|', 'findstr', port],
                    capture_output=True,
                    text=True,
                    shell=True
                )
                if 'LISTENING' in result_port.stdout:
                    sql_ports.append(port)
                    print(f"   Bulunan port: {port}")
        
        return sql_ports if sql_ports else ['6543']  # Varsayılan port
        
    except Exception as e:
        print(f"   HATA: {e}")
        return ['6543']  # Varsayılan port

def firewall_port_kapat(portlar):
    """Windows Firewall'dan portları kapat"""
    print("\n" + "=" * 60)
    print("2. WINDOWS FIREWALL - PORT BAZLI ENGELLEME")
    print("=" * 60)
    
    for port in portlar:
        print(f"\n   Port {port} engelleniyor...")
        
        # Inbound Rule - Block
        try:
            result = subprocess.run(
                ['netsh', 'advfirewall', 'firewall', 'add', 'rule',
                 f'name=SQL_EXTERNAL_BLOCK_{port}',
                 'dir=in',
                 'action=block',
                 'protocol=TCP',
                 f'localport={port}',
                 'profile=domain,private,public'],
                capture_output=True,
                text=True,
                shell=True
            )
            if result.returncode == 0:
                print(f"   OK: Port {port} için inbound engelleme kurali eklendi")
            else:
                print(f"   UYARI: {result.stderr}")
        except Exception as e:
            print(f"   HATA: {e}")
        
        # Outbound Rule - Block (opsiyonel)
        try:
            result = subprocess.run(
                ['netsh', 'advfirewall', 'firewall', 'add', 'rule',
                 f'name=SQL_EXTERNAL_BLOCK_OUT_{port}',
                 'dir=out',
                 'action=block',
                 'protocol=TCP',
                 f'localport={port}',
                 'profile=domain,private,public'],
                capture_output=True,
                text=True,
                shell=True
            )
            if result.returncode == 0:
                print(f"   OK: Port {port} için outbound engelleme kurali eklendi")
        except Exception as e:
            print(f"   HATA: {e}")

def firewall_program_kapat():
    """Windows Firewall'dan sqlservr.exe'yi engelle"""
    print("\n" + "=" * 60)
    print("3. WINDOWS FIREWALL - PROGRAM BAZLI ENGELLEME")
    print("=" * 60)
    
    # sqlservr.exe yolunu bul
    sql_paths = []
    
    # Olası yollar
    olası_yollar = [
        r'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\Binn\sqlservr.exe',
        r'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn\sqlservr.exe',
        r'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Binn\sqlservr.exe',
        r'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Binn\sqlservr.exe',
        r'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Binn\sqlservr.exe',
        r'C:\Program Files (x86)\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\Binn\sqlservr.exe',
    ]
    
    # tasklist ile çalışan sqlservr.exe yolunu bul
    try:
        result = subprocess.run(
            ['wmic', 'process', 'where', 'name="sqlservr.exe"', 'get', 'executablepath'],
            capture_output=True,
            text=True,
            shell=True
        )
        for satir in result.stdout.split('\n'):
            if 'sqlservr.exe' in satir or 'ExecutablePath' in satir:
                if ':' in satir and 'ExecutablePath' not in satir:
                    path = satir.strip()
                    if path and os.path.exists(path):
                        sql_paths.append(path)
                        print(f"   Bulunan SQL Server yolu: {path}")
    except Exception as e:
        print(f"   UYARI: {e}")
    
    # Olası yollardan kontrol et
    for yol in olası_yollar:
        if os.path.exists(yol) and yol not in sql_paths:
            sql_paths.append(yol)
            print(f"   Bulunan SQL Server yolu: {yol}")
    
    if not sql_paths:
        print("   UYARI: sqlservr.exe yolu bulunamadi!")
        print("   Manuel olarak eklemeniz gerekecek.")
        return
    
    # Her yol için firewall kuralı ekle
    for sql_path in sql_paths:
        print(f"\n   {sql_path} engelleniyor...")
        try:
            result = subprocess.run(
                ['netsh', 'advfirewall', 'firewall', 'add', 'rule',
                 'name=SQL_EXE_BLOCK',
                 'dir=in',
                 'action=block',
                 f'program={sql_path}',
                 'profile=domain,private,public'],
                capture_output=True,
                text=True,
                shell=True
            )
            if result.returncode == 0:
                print(f"   OK: Program engelleme kurali eklendi")
            else:
                print(f"   UYARI: {result.stderr}")
        except Exception as e:
            print(f"   HATA: {e}")

def registry_tcp_kapat():
    """Registry üzerinden TCP'yi kapat"""
    print("\n" + "=" * 60)
    print("4. REGISTRY - TCP PROTOKOLUNU KAPATMA")
    print("=" * 60)
    
    # SQL Server registry anahtarlarını bul
    base_key = r'SOFTWARE\Microsoft\Microsoft SQL Server'
    
    try:
        # HKEY_LOCAL_MACHINE'i aç
        with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, base_key) as key:
            # Alt anahtarları listele
            i = 0
            sql_instances = []
            while True:
                try:
                    subkey_name = winreg.EnumKey(key, i)
                    if 'MSSQL' in subkey_name or 'MSSQLServer' in subkey_name:
                        sql_instances.append(subkey_name)
                    i += 1
                except WindowsError:
                    break
            
            print(f"   Bulunan SQL Server instance'ları: {sql_instances}")
            
            # Her instance için TCP'yi kapat
            for instance in sql_instances:
                tcp_path = f"{base_key}\\{instance}\\MSSQLServer\\SuperSocketNetLib\\Tcp"
                print(f"\n   {tcp_path} kontrol ediliyor...")
                
                try:
                    with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, tcp_path, 0, winreg.KEY_WRITE) as tcp_key:
                        # Enabled değerini 0 yap
                        winreg.SetValueEx(tcp_key, 'Enabled', 0, winreg.REG_DWORD, 0)
                        print(f"   OK: TCP protokolu kapatildi (Enabled = 0)")
                except FileNotFoundError:
                    # Anahtar yoksa oluştur
                    try:
                        # Üst dizinleri oluştur
                        parts = tcp_path.split('\\')
                        current_path = parts[0]
                        for part in parts[1:]:
                            try:
                                with winreg.CreateKey(winreg.HKEY_LOCAL_MACHINE, f"{current_path}\\{part}"):
                                    pass
                            except:
                                pass
                            current_path = f"{current_path}\\{part}"
                        
                        # Tcp anahtarını oluştur ve Enabled = 0 yap
                        with winreg.CreateKey(winreg.HKEY_LOCAL_MACHINE, tcp_path) as tcp_key:
                            winreg.SetValueEx(tcp_key, 'Enabled', 0, winreg.REG_DWORD, 0)
                            print(f"   OK: TCP protokolu kapatildi (yeni anahtar olusturuldu)")
                    except Exception as e:
                        print(f"   HATA: {e}")
                except Exception as e:
                    print(f"   HATA: {e}")
                    
    except Exception as e:
        print(f"   HATA: {e}")
        import traceback
        traceback.print_exc()

def sql_servis_restart():
    """SQL Server servisini yeniden başlat"""
    print("\n" + "=" * 60)
    print("5. SQL SERVER SERVISINI YENIDEN BASLATMA")
    print("=" * 60)
    
    # SQL Server servislerini bul
    try:
        result = subprocess.run(
            ['sc', 'query', 'type=', 'service', 'state=', 'all'],
            capture_output=True,
            text=True,
            shell=True
        )
        
        sql_services = []
        for satir in result.stdout.split('\n'):
            if 'SQL' in satir.upper() and 'SERVER' in satir.upper():
                # Servis adını çıkar
                parts = satir.split()
                if len(parts) > 0:
                    service_name = parts[0].strip()
                    if service_name not in sql_services:
                        sql_services.append(service_name)
        
        # Varsayılan servis adları
        if not sql_services:
            sql_services = ['MSSQLSERVER', 'MSSQL$SQLEXPRESS']
        
        print(f"   Bulunan SQL Server servisleri: {sql_services}")
        
        for service in sql_services:
            print(f"\n   {service} yeniden baslatiliyor...")
            try:
                # Servisi durdur
                subprocess.run(
                    ['net', 'stop', service],
                    capture_output=True,
                    text=True,
                    shell=True,
                    timeout=30
                )
                time.sleep(2)
                
                # Servisi başlat
                subprocess.run(
                    ['net', 'start', service],
                    capture_output=True,
                    text=True,
                    shell=True,
                    timeout=30
                )
                print(f"   OK: {service} yeniden baslatildi")
            except subprocess.TimeoutExpired:
                print(f"   UYARI: {service} zaman asimi (servis zaten calisiyor olabilir)")
            except Exception as e:
                print(f"   HATA: {e}")
                # Alternatif: sc komutu
                try:
                    subprocess.run(['sc', 'stop', service], shell=True, timeout=30)
                    time.sleep(2)
                    subprocess.run(['sc', 'start', service], shell=True, timeout=30)
                    print(f"   OK: {service} yeniden baslatildi (sc komutu ile)")
                except:
                    print(f"   UYARI: {service} manuel olarak yeniden baslatmaniz gerekebilir")
                    
    except Exception as e:
        print(f"   HATA: {e}")

def son_kontrol():
    """Son kontrol"""
    print("\n" + "=" * 60)
    print("6. SON KONTROL")
    print("=" * 60)
    
    # Port kontrolü
    print("\n   Port kontrolu...")
    try:
        result = subprocess.run(
            ['netstat', '-ano'],
            capture_output=True,
            text=True,
            shell=True
        )
        
        # SQL Server portlarını kontrol et
        sql_ports_found = []
        for satir in result.stdout.split('\n'):
            if 'LISTENING' in satir:
                # 0.0.0.0 veya tüm IP'lerden dinleniyor mu kontrol et
                if '0.0.0.0:' in satir or '[::]:' in satir:
                    # SQL Server portu mu kontrol et
                    for port in ['6543', '1433', '1434']:
                        if f':{port}' in satir:
                            sql_ports_found.append(satir.strip())
                            print(f"   UYARI: Port {port} hala dis dunyaya acik: {satir.strip()}")
        
        if not sql_ports_found:
            print("   OK: Dis dunyaya acik port bulunamadi")
        else:
            print("   UYARI: Bazi portlar hala acik olabilir!")
        
        # Sadece 127.0.0.1 kontrolü
        localhost_ports = []
        for satir in result.stdout.split('\n'):
            if '127.0.0.1:' in satir and 'LISTENING' in satir:
                for port in ['6543', '1433', '1434']:
                    if f':{port}' in satir:
                        localhost_ports.append(port)
                        print(f"   OK: Port {port} sadece localhost'tan dinleniyor")
        
    except Exception as e:
        print(f"   HATA: {e}")
    
    # Firewall kuralı kontrolü
    print("\n   Firewall kurali kontrolu...")
    try:
        result = subprocess.run(
            ['netsh', 'advfirewall', 'firewall', 'show', 'rule', 'name=all', 'dir=in'],
            capture_output=True,
            text=True,
            shell=True
        )
        
        if 'SQL_EXTERNAL_BLOCK' in result.stdout:
            print("   OK: Firewall engelleme kurallari mevcut")
        else:
            print("   UYARI: Firewall kurallari bulunamadi")
    except Exception as e:
        print(f"   HATA: {e}")

def main():
    print("=" * 60)
    print("SQL SERVER DIS ERISIMI TAMAMEN KAPATMA")
    print("=" * 60)
    print("\nUYARI: Bu islem SQL Server'in dis erisimini tamamen kapatacak!")
    print("Sadece localhost (127.0.0.1) uzerinden erisim mumkun olacak.")
    print("\nDevam etmek istiyor musunuz? (E/H): ", end='')
    
    if input().upper() != 'E':
        print("Islem iptal edildi.")
        return
    
    # Yönetici kontrolü
    if not yonetici_kontrol():
        print("\nUYARI: Bu script yonetici yetkisi gerektirir!")
        print("PowerShell'i yonetici olarak acip tekrar deneyin.")
        input("\nCikmak icin Enter'a basin...")
        return
    
    # Adımları uygula
    portlar = port_tespit()
    firewall_port_kapat(portlar)
    firewall_program_kapat()
    registry_tcp_kapat()
    
    print("\n" + "=" * 60)
    print("SQL SERVER SERVISINI YENIDEN BASLATMAK ISTIYOR MUSUNUZ?")
    print("=" * 60)
    print("NOT: Degisikliklerin aktif olmasi icin servis yeniden baslatilmali.")
    print("Devam etmek istiyor musunuz? (E/H): ", end='')
    
    if input().upper() == 'E':
        sql_servis_restart()
    
    son_kontrol()
    
    print("\n" + "=" * 60)
    print("ISLEM TAMAMLANDI")
    print("=" * 60)
    print("\nONEMLI:")
    print("1. SQL Server servisini mutlaka yeniden baslatin")
    print("2. Port kontrolu yapin: netstat -ano | findstr LISTENING")
    print("3. Sadece 127.0.0.1:6543 gorunmeli, 0.0.0.0:6543 gorunmemeli")
    
    input("\nCikmak icin Enter'a basin...")

if __name__ == "__main__":
    main()
