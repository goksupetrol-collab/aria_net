# -*- coding: utf-8 -*-
"""
SQL Server Tüm İzleri Temizleme Scripti - Final
"""
import pyodbc
from datetime import datetime
import sys

SERVER = '127.0.0.1,6543'
UID = 'sa'
PWD = 'Petro1410+!'
DRIVER = 'ODBC Driver 17 for SQL Server'

LOG_DOSYA = 'sql_temizleme_sonuc.txt'

# UTF-8 encoding için
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
            autocommit=True  # Autocommit modu
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

def sql_server_temizle():
    """SQL Server'ı temizle"""
    print("=" * 60)
    print("SQL SERVER TUM IZLERI TEMIZLEME")
    print("=" * 60)
    print(f"Tarih: {datetime.now()}\n")
    
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
        cursor = conn.cursor()
        
        # 1. Query Store temizle
        yazdir("\n" + "=" * 60, log_dosya)
        yazdir("1. QUERY STORE TEMIZLEME", log_dosya)
        yazdir("=" * 60, log_dosya)
        
        try:
            cursor.execute("""
                SELECT name FROM sys.databases 
                WHERE state_desc = 'ONLINE' AND name NOT IN ('master', 'tempdb', 'model', 'msdb')
            """)
            veritabanlari = cursor.fetchall()
            
            for db_row in veritabanlari:
                db_name = db_row[0]
                try:
                    yazdir(f"\n   {db_name} Query Store temizleniyor...", log_dosya)
                    # Her veritabanı için ayrı bağlantı kullan (autocommit modu ile)
                    conn_db = baglan()
                    if conn_db:
                        cursor_db = conn_db.cursor()
                        cursor_db.execute(f"USE [{db_name}]")
                        cursor_db.execute("ALTER DATABASE CURRENT SET QUERY_STORE CLEAR")
                        cursor_db.close()
                        conn_db.close()
                        yazdir(f"   OK: {db_name} Query Store temizlendi", log_dosya)
                    else:
                        yazdir(f"   HATA: {db_name} icin baglanti kurulamadi", log_dosya)
                except Exception as e:
                    yazdir(f"   UYARI: {db_name} Query Store temizlenemedi: {str(e)}", log_dosya)
        except Exception as e:
            yazdir(f"   HATA: {str(e)}", log_dosya)
        
        # 2. Plan Cache temizle
        yazdir("\n" + "=" * 60, log_dosya)
        yazdir("2. PLAN CACHE TEMIZLEME", log_dosya)
        yazdir("=" * 60, log_dosya)
        
        try:
            yazdir("\n   Plan cache temizleniyor...", log_dosya)
            cursor.execute("DBCC FREEPROCCACHE")
            yazdir("   OK: Plan cache temizlendi", log_dosya)
        except Exception as e:
            yazdir(f"   HATA: {str(e)}", log_dosya)
        
        # 3. Buffer Cache temizle
        yazdir("\n" + "=" * 60, log_dosya)
        yazdir("3. BUFFER CACHE TEMIZLEME", log_dosya)
        yazdir("=" * 60, log_dosya)
        
        try:
            yazdir("\n   Buffer cache temizleniyor...", log_dosya)
            cursor.execute("DBCC DROPCLEANBUFFERS")
            yazdir("   OK: Buffer cache temizlendi", log_dosya)
        except Exception as e:
            yazdir(f"   HATA: {str(e)}", log_dosya)
        
        # 4. Error Log arşivlenmiş kayıtları temizle
        yazdir("\n" + "=" * 60, log_dosya)
        yazdir("4. ERROR LOG TEMIZLEME", log_dosya)
        yazdir("=" * 60, log_dosya)
        
        try:
            yazdir("\n   Error log arsivlenmis kayitlar temizleniyor...", log_dosya)
            temizlenen = 0
            for i in range(0, 10):
                try:
                    cursor.execute(f"EXEC sp_delete_log_file @log_number = {i}")
                    temizlenen += 1
                except:
                    pass
            yazdir(f"   OK: {temizlenen} error log arsivlenmis kayit temizlendi", log_dosya)
            yazdir("   NOT: Aktif error log temizlenemez (sistem korumali)", log_dosya)
        except Exception as e:
            yazdir(f"   HATA: {str(e)}", log_dosya)
        
        # 5. Execution Statistics kontrol
        yazdir("\n" + "=" * 60, log_dosya)
        yazdir("5. EXECUTION STATISTICS KONTROL", log_dosya)
        yazdir("=" * 60, log_dosya)
        
        try:
            cursor.execute("SELECT COUNT(*) FROM sys.dm_exec_query_stats")
            count = cursor.fetchone()[0]
            yazdir(f"\n   Mevcut execution statistics: {count}", log_dosya)
            yazdir("   NOT: Execution statistics servis yeniden baslatma ile temizlenir", log_dosya)
        except Exception as e:
            yazdir(f"   HATA: {str(e)}", log_dosya)
        
        # 6. Connection History kontrol
        yazdir("\n" + "=" * 60, log_dosya)
        yazdir("6. CONNECTION HISTORY KONTROL", log_dosya)
        yazdir("=" * 60, log_dosya)
        
        try:
            cursor.execute("""
                SELECT COUNT(*) 
                FROM sys.dm_exec_connections 
                WHERE session_id != @@SPID
            """)
            count = cursor.fetchone()[0]
            yazdir(f"\n   Aktif baglanti sayisi (kendi baglantimiz haric): {count}", log_dosya)
            yazdir("   NOT: Connection history servis yeniden baslatma ile temizlenir", log_dosya)
        except Exception as e:
            yazdir(f"   HATA: {str(e)}", log_dosya)
        
        yazdir("\n" + "=" * 60, log_dosya)
        yazdir("TEMIZLEME TAMAMLANDI", log_dosya)
        yazdir("=" * 60, log_dosya)
        yazdir("\nTEMIZLENENLER:", log_dosya)
        yazdir("OK: Plan Cache", log_dosya)
        yazdir("OK: Buffer Cache", log_dosya)
        yazdir("OK: Error Log arsivlenmis kayitlar", log_dosya)
        yazdir("\nSERVIS YENIDEN BASLATMA GEREKTIRENLER:", log_dosya)
        yazdir("NOT: Execution Statistics", log_dosya)
        yazdir("NOT: Connection History", log_dosya)
        yazdir("NOT: Wait Statistics", log_dosya)
        yazdir("NOT: TempDB (otomatik temizlenir)", log_dosya)
        
        print("\n" + "=" * 60)
        print("TEMIZLEME TAMAMLANDI")
        print("=" * 60)
        print(f"\nSonuclar '{LOG_DOSYA}' dosyasina kaydedildi.")
        print("\nONEMLI:")
        print("Execution Statistics ve Connection History icin")
        print("SQL Server servisini yeniden baslatmaniz gerekebilir.")
        
    except Exception as e:
        yazdir(f"\nHATA: {str(e)}", log_dosya)
        import traceback
        yazdir(traceback.format_exc(), log_dosya)
        print(f"\nHATA: {e}")
    finally:
        conn.close()
        log_dosya.close()

if __name__ == "__main__":
    sql_server_temizle()
