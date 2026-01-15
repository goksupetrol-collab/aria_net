# -*- coding: utf-8 -*-
"""
SQL Server Dış Erişimi Tamamen Kapatma Scripti - Otomatik Mod
"""
import subprocess
import winreg
import os
import sys
import time

def port_tespit():
    """SQL Server'ın dinlediği portu tespit et"""
    print("=" * 60)
    print("1. SQL SERVER PORT TESPITI")
    print("=" * 60)
    
    try:
        result = subprocess.run(
            ['netstat', '-ano'],
            capture_output=True,
            text=True,
            shell=True
        )
        
        # Port 6543 ve 1433 kontrolü
        sql_ports = []
        for satir in result.stdout.split('\n'):
            if 'LISTENING' in satir:
                for port in ['6543', '1433', '1434']:
                    if f':{port}' in satir:
                        if port not in sql_ports:
                            sql_ports.append(port)
                            print(f"   Bulunan port: {port}")
        
        return sql_ports if sql_ports else ['6543']
    except Exception as e:
        print(f"   HATA: {e}")
        return ['6543']

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
                if 'already exists' in result.stderr.lower() or 'zaten' in result.stderr.lower():
                    print(f"   OK: Port {port} için kural zaten mevcut")
                else:
                    print(f"   UYARI: {result.stderr}")
        except Exception as e:
            print(f"   HATA: {e}")

def firewall_program_kapat():
    """Windows Firewall'dan sqlservr.exe'yi engelle"""
    print("\n" + "=" * 60)
    print("3. WINDOWS FIREWALL - PROGRAM BAZLI ENGELLEME")
    print("=" * 60)
    
    sql_paths = []
    
    # wmic ile sqlservr.exe yolunu bul
    try:
        result = subprocess.run(
            ['wmic', 'process', 'where', 'name="sqlservr.exe"', 'get', 'executablepath', '/format:list'],
            capture_output=True,
            text=True,
            shell=True
        )
        for satir in result.stdout.split('\n'):
            if 'ExecutablePath=' in satir:
                path = satir.replace('ExecutablePath=', '').strip()
                if path and os.path.exists(path) and path not in sql_paths:
                    sql_paths.append(path)
                    print(f"   Bulunan SQL Server yolu: {path}")
    except Exception as e:
        print(f"   UYARI: {e}")
    
    if not sql_paths:
        print("   UYARI: sqlservr.exe yolu bulunamadi!")
        return
    
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
                if 'already exists' in result.stderr.lower():
                    print(f"   OK: Kural zaten mevcut")
                else:
                    print(f"   UYARI: {result.stderr}")
        except Exception as e:
            print(f"   HATA: {e}")

def registry_tcp_kapat():
    """Registry üzerinden TCP'yi kapat"""
    print("\n" + "=" * 60)
    print("4. REGISTRY - TCP PROTOKOLUNU KAPATMA")
    print("=" * 60)
    
    base_key = r'SOFTWARE\Microsoft\Microsoft SQL Server'
    
    try:
        with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, base_key) as key:
            i = 0
            sql_instances = []
            while True:
                try:
                    subkey_name = winreg.EnumKey(key, i)
                    if 'MSSQL' in subkey_name:
                        sql_instances.append(subkey_name)
                    i += 1
                except WindowsError:
                    break
            
            print(f"   Bulunan SQL Server instance'ları: {sql_instances}")
            
            for instance in sql_instances:
                tcp_path = f"{base_key}\\{instance}\\MSSQLServer\\SuperSocketNetLib\\Tcp"
                print(f"\n   {tcp_path} kontrol ediliyor...")
                
                try:
                    with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, tcp_path, 0, winreg.KEY_WRITE) as tcp_key:
                        winreg.SetValueEx(tcp_key, 'Enabled', 0, winreg.REG_DWORD, 0)
                        print(f"   OK: TCP protokolu kapatildi (Enabled = 0)")
                except FileNotFoundError:
                    try:
                        winreg.CreateKey(winreg.HKEY_LOCAL_MACHINE, tcp_path)
                        with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, tcp_path, 0, winreg.KEY_WRITE) as tcp_key:
                            winreg.SetValueEx(tcp_key, 'Enabled', 0, winreg.REG_DWORD, 0)
                            print(f"   OK: TCP protokolu kapatildi (yeni anahtar olusturuldu)")
                    except Exception as e:
                        print(f"   HATA: {e}")
                except Exception as e:
                    print(f"   HATA: {e}")
                    
    except Exception as e:
        print(f"   HATA: {e}")

def son_kontrol():
    """Son kontrol"""
    print("\n" + "=" * 60)
    print("5. SON KONTROL")
    print("=" * 60)
    
    print("\n   Port kontrolu...")
    try:
        result = subprocess.run(
            ['netstat', '-ano'],
            capture_output=True,
            text=True,
            shell=True
        )
        
        dis_acik_portlar = []
        localhost_portlar = []
        
        for satir in result.stdout.split('\n'):
            if 'LISTENING' in satir:
                for port in ['6543', '1433', '1434']:
                    if f':{port}' in satir:
                        if '0.0.0.0:' in satir or '[::]:' in satir:
                            dis_acik_portlar.append(f"Port {port}: {satir.strip()}")
                        elif '127.0.0.1:' in satir:
                            localhost_portlar.append(port)
        
        if dis_acik_portlar:
            print("   UYARI: Dis dunyaya acik portlar:")
            for p in dis_acik_portlar:
                print(f"      {p}")
        else:
            print("   OK: Dis dunyaya acik port bulunamadi")
        
        if localhost_portlar:
            print(f"   OK: Sadece localhost'tan dinlenen portlar: {localhost_portlar}")
        
    except Exception as e:
        print(f"   HATA: {e}")
    
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
    print("SQL SERVER DIS ERISIMI TAMAMEN KAPATMA (OTOMATIK MOD)")
    print("=" * 60)
    print("\nIslem baslatiliyor...\n")
    
    # Adımları uygula
    portlar = port_tespit()
    firewall_port_kapat(portlar)
    firewall_program_kapat()
    registry_tcp_kapat()
    
    son_kontrol()
    
    print("\n" + "=" * 60)
    print("ISLEM TAMAMLANDI")
    print("=" * 60)
    print("\nONEMLI:")
    print("1. SQL Server servisini mutlaka yeniden baslatin:")
    print("   services.msc -> SQL Server (MSSQLSERVER) -> Restart")
    print("2. Port kontrolu: netstat -ano | findstr LISTENING")
    print("3. Sadece 127.0.0.1:6543 gorunmeli, 0.0.0.0:6543 gorunmemeli")

if __name__ == "__main__":
    main()
