import pyodbc

conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=127.0.0.1,6543;'
    'DATABASE=master;'
    'UID=sa;'
    'PWD=Petro1410+!;'
    'TrustServerCertificate=yes'
)

cursor = conn.cursor()

print("=== GIZLI PROGRAM KONTROLU ===\n")

# 1. Stored Procedures (Gizli kodlar)
cursor.execute("""
    SELECT 
        SCHEMA_NAME(schema_id) as SchemaName,
        name as ProcedureName,
        create_date,
        modify_date
    FROM sys.procedures
    WHERE name NOT LIKE 'sp_%' 
    AND name NOT LIKE 'xp_%'
    ORDER BY create_date DESC
""")
print("1. STORED PROCEDURES (Gizli kodlar):")
procs = cursor.fetchall()
if procs:
    for row in procs:
        print(f"   - {row[0]}.{row[1]} (Olusturma: {row[2]})")
else:
    print("   - Gizli stored procedure bulunamadi")

# 2. Triggers (Otomatik calisan kodlar)
cursor.execute("""
    SELECT 
        OBJECT_SCHEMA_NAME(parent_id) as SchemaName,
        name as TriggerName,
        create_date,
        is_disabled
    FROM sys.triggers
    WHERE parent_class = 1
    ORDER BY create_date DESC
""")
print("\n2. TRIGGERS (Otomatik calisan kodlar):")
triggers = cursor.fetchall()
if triggers:
    for row in triggers:
        durum = "PASIF" if row[3] else "AKTIF"
        print(f"   - {row[0]}.{row[1]} ({durum}, Olusturma: {row[2]})")
else:
    print("   - Gizli trigger bulunamadi")

# 3. SQL Agent Jobs (Otomatik gorevler)
cursor.execute("""
    SELECT 
        name as JobName,
        enabled,
        date_created,
        date_modified
    FROM msdb.dbo.sysjobs
    ORDER BY date_created DESC
""")
print("\n3. SQL AGENT JOBS (Otomatik gorevler):")
jobs = cursor.fetchall()
if jobs:
    for row in jobs:
        durum = "AKTIF" if row[1] else "PASIF"
        print(f"   - {row[0]} ({durum}, Olusturma: {row[3]})")
else:
    print("   - Gizli job bulunamadi")

# 4. Aktif baglantilar
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
print("\n4. AKTIF BAGLANTILAR:")
sessions = cursor.fetchall()
if sessions:
    for row in sessions:
        print(f"   - {row[0]} ({row[1]}) - Program: {row[2]}")
        print(f"     Giris: {row[3]}, Son istek: {row[4]}")
else:
    print("   - Aktif baglanti yok")

# 5. Son calisan sorgular
cursor.execute("""
    SELECT TOP 10
        s.login_name,
        t.text as SQLText,
        r.start_time,
        r.status
    FROM sys.dm_exec_requests r
    CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
    LEFT JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
    ORDER BY r.start_time DESC
""")
print("\n5. SON CALISAN SORULAR:")
queries = cursor.fetchall()
if queries:
    for row in queries:
        print(f"   - {row[0]}: {row[1][:50]}... (Zaman: {row[2]})")
else:
    print("   - Son sorgu bulunamadi")

conn.close()
print("\n=== KONTROL TAMAMLANDI ===")
