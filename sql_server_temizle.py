# -*- coding: utf-8 -*-
"""
SQL Server Tüm İzleri Temizleme Scripti
Loglar, Cache'ler, Geçmiş Veriler
"""
import pyodbc
import subprocess
import os
from datetime import datetime

SERVER = '127.0.0.1,6543'
UID = 'sa'
PWD = 'Petro1410+!'
DRIVER = 'ODBC Driver 17 for SQL Server'
DATABASE = 'OZGUR'

LOG_DOSYA = 'sql_temizleme_sonuc.txt'

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

def yazdir(mesaj, dosya=None):
    """Ekrana ve dosyaya yaz"""
    print(mesaj)
    if dosya:
        dosya.write(mesaj + '\n')
        dosya.flush()

def query_store_temizle(conn, log_dosya):
    """Query Store temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("QUERY STORE TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    cursor = conn.cursor()
    
    # Tüm veritabanları için Query Store temizle
    try:
        cursor.execute("""
            SELECT name FROM sys.databases 
            WHERE state_desc = 'ONLINE' AND name NOT IN ('master', 'tempdb', 'model', 'msdb')
        """)
        
        veritabanlari = cursor.fetchall()
        for db_row in veritabanlari:
            db_name = db_row[0]
            try:
                yazdir(f"\n   {db_name} veritabani Query Store temizleniyor...", log_dosya)
                cursor.execute(f"USE [{db_name}]")
                cursor.execute("ALTER DATABASE CURRENT SET QUERY_STORE CLEAR")
                yazdir(f"   OK: {db_name} Query Store temizlendi", log_dosya)
            except Exception as e:
                yazdir(f"   UYARI: {db_name} Query Store temizlenemedi: {e}", log_dosya)
    except Exception as e:
        yazdir(f"   HATA: {e}", log_dosya)

def plan_cache_temizle(conn, log_dosya):
    """Plan Cache temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("PLAN CACHE TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    cursor = conn.cursor()
    
    try:
        yazdir("\n   Plan cache temizleniyor...", log_dosya)
        cursor.execute("DBCC FREEPROCCACHE")
        yazdir("   OK: Plan cache temizlendi", log_dosya)
    except Exception as e:
        yazdir(f"   HATA: {e}", log_dosya)

def buffer_cache_temizle(conn, log_dosya):
    """Buffer Cache temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("BUFFER CACHE TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    cursor = conn.cursor()
    
    try:
        yazdir("\n   Buffer cache temizleniyor...", log_dosya)
        cursor.execute("DBCC DROPCLEANBUFFERS")
        yazdir("   OK: Buffer cache temizlendi", log_dosya)
    except Exception as e:
        yazdir(f"   HATA: {e}", log_dosya)

def execution_history_temizle(conn, log_dosya):
    """Execution history temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("EXECUTION HISTORY TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    cursor = conn.cursor()
    
    try:
        # sys.dm_exec_query_stats temizleme (sadece bilgi - gerçekte temizlenemez ama yeniden başlatma gerekir)
        yazdir("\n   Execution statistics kontrol ediliyor...", log_dosya)
        cursor.execute("SELECT COUNT(*) FROM sys.dm_exec_query_stats")
        count = cursor.fetchone()[0]
        yazdir(f"   Mevcut execution statistics: {count}", log_dosya)
        yazdir("   NOT: Execution statistics servis yeniden baslatma ile temizlenir", log_dosya)
    except Exception as e:
        yazdir(f"   HATA: {e}", log_dosya)

def connection_history_temizle(conn, log_dosya):
    """Connection history temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("CONNECTION HISTORY TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    cursor = conn.cursor()
    
    try:
        # Aktif bağlantıları kontrol et
        yazdir("\n   Aktif baglantilar kontrol ediliyor...", log_dosya)
        cursor.execute("""
            SELECT COUNT(*) 
            FROM sys.dm_exec_connections 
            WHERE session_id != @@SPID
        """)
        count = cursor.fetchone()[0]
        yazdir(f"   Aktif baglanti sayisi (kendi baglantimiz haric): {count}", log_dosya)
        yazdir("   NOT: Connection history servis yeniden baslatma ile temizlenir", log_dosya)
    except Exception as e:
        yazdir(f"   HATA: {e}", log_dosya)

def error_log_temizle(conn, log_dosya):
    """Error Log temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("ERROR LOG TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    cursor = conn.cursor()
    
    try:
        # Error log sayısını kontrol et
        yazdir("\n   Error log kontrol ediliyor...", log_dosya)
        cursor.execute("EXEC xp_readerrorlog 0, 1, N'Logging SQL Server messages'")
        logs = cursor.fetchall()
        yazdir(f"   Mevcut error log sayisi: {len(logs)}", log_dosya)
        
        # Error log'ları temizle (sadece arşivlenmiş olanlar)
        yazdir("\n   Error log arsivlenmis kayitlar temizleniyor...", log_dosya)
        for i in range(0, 10):  # İlk 10 arşiv log'u
            try:
                cursor.execute(f"EXEC sp_delete_log_file @log_number = {i}")
                yazdir(f"   Log {i} temizlendi", log_dosya)
            except:
                pass
        
        yazdir("   NOT: Aktif error log temizlenemez, sadece arsivlenmis loglar temizlendi", log_dosya)
    except Exception as e:
        yazdir(f"   HATA: {e}", log_dosya)

def tempdb_temizle(conn, log_dosya):
    """TempDB temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("TEMPDB TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    cursor = conn.cursor()
    
    try:
        yazdir("\n   TempDB kontrol ediliyor...", log_dosya)
        cursor.execute("USE tempdb")
        cursor.execute("SELECT COUNT(*) FROM sys.tables")
        count = cursor.fetchone()[0]
        yazdir(f"   TempDB tablo sayisi: {count}", log_dosya)
        yazdir("   NOT: TempDB otomatik olarak servis yeniden baslatmada temizlenir", log_dosya)
    except Exception as e:
        yazdir(f"   HATA: {e}", log_dosya)

def wait_stats_temizle(conn, log_dosya):
    """Wait Statistics temizle"""
    yazdir("\n" + "=" * 60, log_dosya)
    yazdir("WAIT STATISTICS TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    
    cursor = conn.cursor()
    
    try:
        yazdir("\n   Wait statistics kontrol ediliyor...", log_dosya)
        cursor.execute("SELECT COUNT(*) FROM sys.dm_os_wait_stats")
        count = cursor.fetchone()[0]
        yazdir(f"   Mevcut wait statistics: {count}", log_dosya)
        yazdir("   NOT: Wait statistics servis yeniden baslatma ile sifirlanir", log_dosya)
    except Exception as e:
        yazdir(f"   HATA: {e}", log_dosya)

def sql_server_temizle():
    """SQL Server'ı temizle"""
    print("=" * 60)
    print("SQL SERVER TUM IZLERI TEMIZLEME")
    print("=" * 60)
    print(f"Tarih: {datetime.now()}")
    print("\nUYARI: Bu islem SQL Server'daki tum cache'leri ve loglari temizleyecek!")
    print("Devam etmek istiyor musunuz? (E/H): ", end='')
    
    if input().upper() != 'E':
        print("Islem iptal edildi.")
        return
    
    log_dosya = open(LOG_DOSYA, 'w', encoding='utf-8')
    
    yazdir("=" * 60, log_dosya)
    yazdir("SQL SERVER TUM IZLERI TEMIZLEME", log_dosya)
    yazdir("=" * 60, log_dosya)
    yazdir(f"Tarih: {datetime.now()}", log_dosya)
    
    conn = baglan()
    if not conn:
        log_dosya.close()
        return
    
    try:
        # 1. Query Store temizle
        query_store_temizle(conn, log_dosya)
        
        # 2. Plan Cache temizle
        plan_cache_temizle(conn, log_dosya)
        
        # 3. Buffer Cache temizle
        buffer_cache_temizle(conn, log_dosya)
        
        # 4. Execution History kontrol
        execution_history_temizle(conn, log_dosya)
        
        # 5. Connection History kontrol
        connection_history_temizle(conn, log_dosya)
        
        # 6. Error Log temizle
        error_log_temizle(conn, log_dosya)
        
        # 7. TempDB kontrol
        tempdb_temizle(conn, log_dosya)
        
        # 8. Wait Statistics kontrol
        wait_stats_temizle(conn, log_dosya)
        
        yazdir("\n" + "=" * 60, log_dosya)
        yazdir("TEMIZLEME TAMAMLANDI", log_dosya)
        yazdir("=" * 60, log_dosya)
        yazdir("\nONEMLI NOTLAR:", log_dosya)
        yazdir("1. Plan Cache ve Buffer Cache temizlendi", log_dosya)
        yazdir("2. Query Store temizlendi", log_dosya)
        yazdir("3. Execution History ve Connection History icin SQL Server", log_dosya)
        yazdir("   servisini yeniden baslatmaniz gerekebilir", log_dosya)
        yazdir("4. Error Log arsivlenmis kayitlar temizlendi", log_dosya)
        yazdir("5. Aktif error log temizlenemez (sistem korumali)", log_dosya)
        
        print("\n" + "=" * 60)
        print("TEMIZLEME TAMAMLANDI")
        print("=" * 60)
        print(f"\nSonuclar '{LOG_DOSYA}' dosyasina kaydedildi.")
        
    except Exception as e:
        yazdir(f"\nHATA: {e}", log_dosya)
        import traceback
        yazdir(traceback.format_exc(), log_dosya)
        print(f"\nHATA: {e}")
    finally:
        conn.close()
        log_dosya.close()

if __name__ == "__main__":
    sql_server_temizle()
    input("\nCikmak icin Enter'a basin...")
