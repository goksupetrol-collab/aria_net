# -*- coding: utf-8 -*-
"""
SQL Server Tamamen Temizleme Scripti
Tüm veritabanları, kullanıcılar, izler - Server kullanılmayacak
"""
import pyodbc
from datetime import datetime
import sys
import subprocess

SERVER = '127.0.0.1,6543'
UID = 'sa'
PWD = 'Petro1410+!'
DRIVER = 'ODBC Driver 17 for SQL Server'

LOG_DOSYA = 'sql_tamamen_temizleme_sonuc.txt'

sys.stdout.reconfigure(encoding='utf-8', errors='replace')

def baglan():
    """SQL Server'a bağlan"""
    try:
        conn = pyodbc.connect(
            f'DRIVER={{{DRIVER}}};'
            f'SERVER={SERVER};'
            f'DATABASE=master;'
            f'UID={UID};'
            f'PWD={PWD};'
            f'TrustServerCertificate=yes',
            autocommit=True
        )
        return conn
    except Exception as e:
        print(f"HATA: Baglanti hatasi: {e}")
        return None

def yazdir(mesaj, dosya=None):
    """Ekrana ve dosyaya yaz"""
    print(mesaj, flush=True)
    if dosya:
        dosya.write(mesaj + '\n')
        dosya.flush()

def tum_veritabanlarini_sil(conn, log_dosya):
    """Tüm kullanıcı veritabanlarını sil"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("TUM VERITABANLARI SILME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    cursor = conn.cursor()
    
    try:
        # Sistem veritabanlarını hariç tut
        cursor.execute("""
            SELECT name FROM sys.databases 
            WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')
            AND state_desc = 'ONLINE'
        """)
        
        veritabanlari = cursor.fetchall()
        yazdir(f"\n   Bulunan kullanici veritabanlari: {len(veritabanlari)}", log_dosya)
        
        for db_row in veritabanlari:
            db_name = db_row[0]
            try:
                yazdir(f"\n   {db_name} veritabani siliniyor...", log_dosya)
                
                # Önce bağlantıları kes
                cursor.execute(f"""
                    ALTER DATABASE [{db_name}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
                """)
                
                # Veritabanını sil
                cursor.execute(f"DROP DATABASE [{db_name}]")
                yazdir(f"   OK: {db_name} veritabani silindi", log_dosya)
            except Exception as e:
                yazdir(f"   HATA: {db_name} silinemedi: {str(e)}", log_dosya)
    except Exception as e:
        yazdir(f"   HATA: {str(e)}", log_dosya)

def tum_kullanicilari_sil(conn, log_dosya):
    """Tüm kullanıcıları sil (sa hariç)"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("TUM KULLANICILARI SILME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    cursor = conn.cursor()
    
    try:
        cursor.execute("""
            SELECT name FROM sys.server_principals
            WHERE type IN ('S', 'U', 'G')
            AND name NOT IN ('sa', 'public', 'BUILTIN\\Administrators', 'NT AUTHORITY\\SYSTEM')
            AND name NOT LIKE '##%'
        """)
        
        kullanicilar = cursor.fetchall()
        yazdir(f"\n   Bulunan kullanici sayisi: {len(kullanicilar)}", log_dosya)
        
        for user_row in kullanicilar:
            user_name = user_row[0]
            try:
                yazdir(f"\n   {user_name} kullanici siliniyor...", log_dosya)
                cursor.execute(f"DROP LOGIN [{user_name}]")
                yazdir(f"   OK: {user_name} kullanici silindi", log_dosya)
            except Exception as e:
                yazdir(f"   HATA: {user_name} silinemedi: {str(e)}", log_dosya)
    except Exception as e:
        yazdir(f"   HATA: {str(e)}", log_dosya)

def tum_cache_temizle(conn, log_dosya):
    """Tüm cache'leri temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("TUM CACHE TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    cursor = conn.cursor()
    
    try:
        yazdir("\n   Plan cache temizleniyor...", log_dosya)
        cursor.execute("DBCC FREEPROCCACHE")
        yazdir("   OK: Plan cache temizlendi", log_dosya)
        
        yazdir("\n   Buffer cache temizleniyor...", log_dosya)
        cursor.execute("DBCC DROPCLEANBUFFERS")
        yazdir("   OK: Buffer cache temizlendi", log_dosya)
        
        yazdir("\n   Procedure cache temizleniyor...", log_dosya)
        cursor.execute("DBCC FREESYSTEMCACHE('ALL')")
        yazdir("   OK: Procedure cache temizlendi", log_dosya)
    except Exception as e:
        yazdir(f"   HATA: {str(e)}", log_dosya)

def error_log_temizle(conn, log_dosya):
    """Error log'ları temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("ERROR LOG TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    cursor = conn.cursor()
    
    try:
        yazdir("\n   Error log arsivlenmis kayitlar temizleniyor...", log_dosya)
        temizlenen = 0
        for i in range(0, 20):
            try:
                cursor.execute(f"EXEC sp_delete_log_file @log_number = {i}")
                temizlenen += 1
            except:
                pass
        yazdir(f"   OK: {temizlenen} error log temizlendi", log_dosya)
    except Exception as e:
        yazdir(f"   HATA: {str(e)}", log_dosya)

def sql_servis_durdur(log_dosya):
    """SQL Server servisini durdur"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("SQL SERVER SERVIS DURDURMA", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    try:
        yazdir("\n   SQL Server servisi durduruluyor...", log_dosya)
        result = subprocess.run(
            ['net', 'stop', 'MSSQLSERVER'],
            capture_output=True,
            text=True,
            timeout=60
        )
        if result.returncode == 0:
            yazdir("   OK: SQL Server servisi durduruldu", log_dosya)
        else:
            yazdir(f"   UYARI: Servis durdurulamadi: {result.stderr}", log_dosya)
    except Exception as e:
        yazdir(f"   HATA: {str(e)}", log_dosya)
        yazdir("   NOT: Servisi manuel olarak durdurun: net stop MSSQLSERVER", log_dosya)

def sql_server_tamamen_temizle():
    """SQL Server'ı tamamen temizle"""
    print("=" * 60)
    print("SQL SERVER TAMAMEN TEMIZLEME")
    print("=" * 60)
    print(f"Tarih: {datetime.now()}")
    print("\nUYARI: Bu islem tum veritabanlarini, kullanicilari ve izleri silecek!")
    print("Server kullanilmayacak ve servis durdurulacak!")
    print("Devam etmek istiyor musunuz? (EVET yazin): ", end='')
    
    onay = input().strip().upper()
    if onay != 'EVET':
        print("Islem iptal edildi.")
        return
    
    log_dosya = open(LOG_DOSYA, 'w', encoding='utf-8')
    
    yazdir("=" * 60, log_dosya)
    yazdir("SQL SERVER TAMAMEN TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    yazdir(f"Tarih: {datetime.now()}", log_dosya)
    
    conn = baglan()
    if not conn:
        log_dosya.close()
        return
    
    try:
        # 1. Tüm cache'leri temizle
        tum_cache_temizle(conn, log_dosya)
        
        # 2. Tüm veritabanlarını sil
        tum_veritabanlarini_sil(conn, log_dosya)
        
        # 3. Tüm kullanıcıları sil
        tum_kullanicilari_sil(conn, log_dosya)
        
        # 4. Error log temizle
        error_log_temizle(conn, log_dosya)
        
        yazdir("\n" + "=" * 60, log_dosya)
        yazdir("TEMIZLEME TAMAMLANDI", log_dosya)
        yazdir("=" * 60, log_dosya)
        
    except Exception as e:
        yazdir(f"\nHATA: {str(e)}", log_dosya)
        import traceback
        yazdir(traceback.format_exc(), log_dosya)
    finally:
        conn.close()
        log_dosya.close()
    
    # 5. SQL Server servisini durdur
    sql_servis_durdur(log_dosya)
    
    print("\n" + "=" * 60)
    print("TEMIZLEME TAMAMLANDI")
    print("=" * 60)
    print(f"\nSonuclar '{LOG_DOSYA}' dosyasina kaydedildi.")
    print("\nSQL Server servisi durduruldu.")
    print("Server artik kullanilmiyor ve izler temizlendi.")

if __name__ == "__main__":
    sql_server_tamamen_temizle()
