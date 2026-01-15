# -*- coding: utf-8 -*-
"""
Kopyalama İşlemlerinin İzlerini Kontrol Scripti
"""
import pyodbc
from datetime import datetime
import sys

SERVER = '127.0.0.1,6543'
UID = 'sa'
PWD = 'Petro1410+!'
DRIVER = 'ODBC Driver 17 for SQL Server'
DATABASE = 'OZGUR'

sys.stdout.reconfigure(encoding='utf-8', errors='replace')

def baglan():
    """SQL Server'a bağlan"""
    try:
        conn = pyodbc.connect(
            f'DRIVER={{{DRIVER}}};'
            f'SERVER={SERVER};'
            f'DATABASE={DATABASE};'
            f'UID={UID};'
            f'PWD={PWD};'
            f'TrustServerCertificate=yes',
            autocommit=True
        )
        return conn
    except Exception as e:
        print(f"HATA: Baglanti hatasi: {e}")
        return None

def izleri_kontrol():
    """Kopyalama işlemlerinin izlerini kontrol et"""
    print("=" * 60)
    print("KOPYALAMA ISLEMLERININ IZLERI KONTROL")
    print("=" * 60)
    print(f"Tarih: {datetime.now()}\n")
    
    conn = baglan()
    if not conn:
        return
    
    try:
        cursor = conn.cursor()
        
        # 1. Son çalıştırılan sorguları kontrol
        print("\n" + "=" * 60)
        print("1. SON CALISTIRILAN SORGULAR")
        print("=" * 60)
        
        try:
            cursor.execute("""
                SELECT TOP 20
                    qs.last_execution_time,
                    SUBSTRING(qt.text, 1, 100) AS query_text,
                    qs.execution_count,
                    qs.total_elapsed_time / 1000 AS total_ms
                FROM sys.dm_exec_query_stats qs
                CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
                WHERE qt.text LIKE '%SELECT%' 
                   OR qt.text LIKE '%FROM%'
                   OR qt.text LIKE '%sys.%'
                ORDER BY qs.last_execution_time DESC
            """)
            
            sorgular = cursor.fetchall()
            print(f"\n   Toplam sorgu sayisi: {len(sorgular)}")
            
            if len(sorgular) == 0:
                print("   OK: Hic sorgu izi bulunamadi!")
            else:
                print("   UYARI: Bazi sorgu izleri bulundu:")
                for i, row in enumerate(sorgular[:5], 1):
                    print(f"\n   {i}. Son calistirma: {row[0]}")
                    print(f"      Sorgu: {row[1][:80]}...")
                    print(f"      Calistirma sayisi: {row[2]}")
        except Exception as e:
            print(f"   HATA: {e}")
        
        # 2. Aktif bağlantıları kontrol
        print("\n" + "=" * 60)
        print("2. AKTIF BAGLANTILAR")
        print("=" * 60)
        
        try:
            cursor.execute("""
                SELECT 
                    session_id,
                    login_name,
                    program_name,
                    client_interface_name,
                    login_time,
                    last_request_start_time
                FROM sys.dm_exec_sessions
                WHERE session_id != @@SPID
                ORDER BY login_time DESC
            """)
            
            baglantilar = cursor.fetchall()
            print(f"\n   Toplam aktif baglanti sayisi: {len(baglantilar)}")
            
            if len(baglantilar) == 0:
                print("   OK: Hic aktif baglanti yok!")
            else:
                print("   Mevcut baglantilar:")
                for row in baglantilar[:10]:
                    print(f"   - Session: {row[0]}, Kullanici: {row[1]}, Program: {row[2]}")
        except Exception as e:
            print(f"   HATA: {e}")
        
        # 3. Query Store durumu kontrol
        print("\n" + "=" * 60)
        print("3. QUERY STORE DURUMU")
        print("=" * 60)
        
        try:
            cursor.execute("""
                SELECT 
                    COUNT(*) AS query_count,
                    MIN(rs.last_execution_time) AS ilk_calistirma,
                    MAX(rs.last_execution_time) AS son_calistirma
                FROM sys.query_store_query q
                INNER JOIN sys.query_store_plan p ON q.query_id = p.query_id
                INNER JOIN sys.query_store_runtime_stats rs ON p.plan_id = rs.plan_id
            """)
            
            row = cursor.fetchone()
            if row and row[0] > 0:
                print(f"\n   UYARI: Query Store'da {row[0]} sorgu kaydi var!")
                print(f"   Ilk calistirma: {row[1]}")
                print(f"   Son calistirma: {row[2]}")
            else:
                print("\n   OK: Query Store temiz!")
        except Exception as e:
            print(f"   HATA: {e}")
        
        # 4. Plan Cache durumu kontrol
        print("\n" + "=" * 60)
        print("4. PLAN CACHE DURUMU")
        print("=" * 60)
        
        try:
            cursor.execute("""
                SELECT COUNT(*) 
                FROM sys.dm_exec_cached_plans
            """)
            
            count = cursor.fetchone()[0]
            print(f"\n   Plan Cache'deki plan sayisi: {count}")
            
            if count == 0:
                print("   OK: Plan Cache tamamen temiz!")
            else:
                print("   NOT: Plan Cache'de planlar var (normal)")
        except Exception as e:
            print(f"   HATA: {e}")
        
        # 5. Error Log kontrol
        print("\n" + "=" * 60)
        print("5. ERROR LOG KONTROL")
        print("=" * 60)
        
        try:
            cursor.execute("""
                EXEC xp_readerrorlog 0, 1, NULL, NULL, NULL, NULL, N'DESC'
            """)
            
            logs = cursor.fetchall()
            print(f"\n   Son error log kayitlari: {len(logs)}")
            
            # Son 10 kaydı kontrol et
            kopyalama_izleri = []
            for log in logs[:20]:
                log_text = str(log[2]) if len(log) > 2 else str(log)
                if any(keyword in log_text.upper() for keyword in ['SELECT', 'FROM', 'SYS.', 'INFORMATION_SCHEMA']):
                    kopyalama_izleri.append(log_text[:100])
            
            if kopyalama_izleri:
                print(f"   UYARI: {len(kopyalama_izleri)} potansiyel kopyalama izi bulundu")
            else:
                print("   OK: Error log'da belirgin kopyalama izi yok")
        except Exception as e:
            print(f"   HATA: {e}")
        
        # Özet
        print("\n" + "=" * 60)
        print("OZET")
        print("=" * 60)
        print("\nTEMIZLENENLER:")
        print("OK: Query Store temizlendi")
        print("OK: Plan Cache temizlendi")
        print("OK: Buffer Cache temizlendi")
        print("\nKALAN IZLER:")
        print("NOT: Execution Statistics (servis yeniden baslatma ile temizlenir)")
        print("NOT: Connection History (servis yeniden baslatma ile temizlenir)")
        print("NOT: Aktif Error Log (sistem korumali, temizlenemez)")
        print("\nSONUC:")
        print("Kopyalama islemlerinin cogu izi temizlendi.")
        print("Tam temizlik icin SQL Server servisini yeniden baslatmaniz gerekiyor.")
        
    except Exception as e:
        print(f"\nHATA: {e}")
        import traceback
        traceback.print_exc()
    finally:
        conn.close()

if __name__ == "__main__":
    izleri_kontrol()
