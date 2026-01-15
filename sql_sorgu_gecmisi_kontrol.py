import pyodbc
from datetime import datetime

conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=127.0.0.1,6543;'
    'DATABASE=master;'
    'UID=sa;'
    'PWD=Petro1410+!;'
    'TrustServerCertificate=yes'
)

cursor = conn.cursor()

print("=" * 60)
print("BENIM YAPTIĞIM SORGULARIN KAYIT YERLERİ")
print("=" * 60)

# 1. Son çalıştırılan sorgular (eğer cache'de varsa)
print("\n1. SON ÇALIŞTIRILAN SORGULAR (Cache'den):")
try:
    cursor.execute("""
        SELECT TOP 20
            qs.last_execution_time,
            SUBSTRING(st.text, 1, 100) as sorgu_metni,
            qs.execution_count
        FROM sys.dm_exec_query_stats qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
        WHERE st.text NOT LIKE '%sys.dm_exec%'
        ORDER BY qs.last_execution_time DESC
    """)
    rows = cursor.fetchall()
    if rows:
        for row in rows:
            print(f"  Zaman: {row[0]}")
            print(f"  Sorgu: {row[1][:80]}...")
            print(f"  Çalıştırma Sayısı: {row[2]}")
            print("-" * 60)
    else:
        print("  Cache'de sorgu bulunamadı.")
except Exception as e:
    print(f"  Hata: {e}")

# 2. Bağlantı kayıtları (ERRORLOG'dan)
print("\n2. BAĞLANTI KAYITLARI (127.0.0.1'den):")
try:
    cursor.execute("""
        EXEC xp_readerrorlog 0, 1, N'127.0.0.1'
    """)
    rows = cursor.fetchall()
    if rows:
        for row in rows[-10:]:  # Son 10 kayıt
            print(f"  {row[0]} - {row[2]}")
    else:
        print("  Bağlantı kaydı bulunamadı.")
except Exception as e:
    print(f"  Hata: {e}")

# 3. Aktif oturumlar (şu an bağlı olanlar)
print("\n3. ŞU AN AKTİF OLAN BAĞLANTILAR:")
try:
    cursor.execute("""
        SELECT 
            login_name,
            host_name,
            program_name,
            login_time,
            last_request_start_time
        FROM sys.dm_exec_sessions
        WHERE is_user_process = 1
        ORDER BY login_time DESC
    """)
    rows = cursor.fetchall()
    if rows:
        for row in rows:
            print(f"  Kullanıcı: {row[0]}")
            print(f"  Bilgisayar: {row[1]}")
            print(f"  Program: {row[2]}")
            print(f"  Giriş Zamanı: {row[3]}")
            print("-" * 60)
    else:
        print("  Aktif bağlantı bulunamadı.")
except Exception as e:
    print(f"  Hata: {e}")

# 4. Query Store durumu (eğer açıksa)
print("\n4. QUERY STORE DURUMU:")
try:
    cursor.execute("""
        SELECT 
            name,
            actual_state_desc,
            readonly_reason
        FROM sys.database_query_store_options
    """)
    row = cursor.fetchone()
    if row:
        print(f"  Durum: {row[1]}")
        if row[2] is not None:
            print(f"  Salt Okunur Sebep: {row[2]}")
    else:
        print("  Query Store açık değil veya bu veritabanında yok.")
except Exception as e:
    print(f"  Query Store kontrol edilemedi: {e}")

print("\n" + "=" * 60)
print("ÖNEMLİ NOT:")
print("=" * 60)
print("""
SQL Server'da normal SELECT sorguları otomatik olarak log'a yazılmaz.
Sadece şunlar kaydedilir:
- Bağlantı girişleri/çıkışları
- Hatalar
- Önemli işlemler (BACKUP, RESTORE vb.)

Eğer tüm sorguları görmek istiyorsanız:
1. SQL Server Profiler kullanabilirsiniz
2. Extended Events açabilirsiniz
3. Query Store'u aktif edebilirsiniz

Şu anda sadece bağlantı kayıtları görünüyor.
""")

conn.close()
