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

print("=== SQL SERVER LOG/BIlGI CIKISI KONTROLU ===\n")

# 1. SQL Server Error Log konumu ve durumu
cursor.execute("EXEC xp_readerrorlog 0, 1, N'Server', N'is listening on'")
print("1. SQL SERVER ERROR LOG:")
logs = cursor.fetchall()
if logs:
    for row in logs[:5]:  # İlk 5 satır
        print(f"   {row[2]}")
else:
    print("   Log bulunamadi")

# 2. SQL Agent Jobs - Otomatik görevler (log gönderme olabilir)
cursor.execute("""
    SELECT 
        name,
        enabled,
        date_created,
        description
    FROM msdb.dbo.sysjobs
    ORDER BY date_created DESC
""")
print("\n2. SQL AGENT JOBS (Otomatik görevler):")
jobs = cursor.fetchall()
if jobs:
    for row in jobs:
        durum = "AKTIF" if row[1] else "PASIF"
        print(f"   - {row[0]} ({durum})")
        if row[3]:
            print(f"     Aciklama: {row[3]}")
else:
    print("   Job bulunamadi")

# 3. Database Mail ayarları (Email gönderme)
try:
    cursor.execute("SELECT name FROM msdb.dbo.sysmail_profile")
    print("\n3. DATABASE MAIL (Email gönderme):")
    mails = cursor.fetchall()
    if mails:
        for row in mails:
            print(f"   - {row[0]}")
    else:
        print("   Database Mail bulunamadi")
except:
    print("\n3. DATABASE MAIL: Kontrol edilemedi")

# 4. Linked Server'lar (Başka SQL Server'lara bağlantı)
cursor.execute("""
    SELECT name, provider, data_source, is_remote_login_enabled
    FROM sys.servers
    WHERE is_linked = 1
""")
print("\n4. LINKED SERVERS (Başka SQL Server'lara bağlantı):")
linked = cursor.fetchall()
if linked:
    for row in linked:
        print(f"   - {row[0]} -> {row[2]}")
else:
    print("   Linked Server bulunamadi")

# 5. Aktif dış bağlantılar
cursor.execute("""
    SELECT 
        session_id,
        login_name,
        host_name,
        program_name,
        client_interface_name
    FROM sys.dm_exec_sessions 
    WHERE is_user_process = 1
    AND host_name != @@SERVERNAME
""")
print("\n5. DISARIDAN BAGLANTILAR:")
sessions = cursor.fetchall()
if sessions:
    for row in sessions:
        print(f"   - {row[1]} ({row[2]}) - Program: {row[3]}")
else:
    print("   Disaridan baglanti yok")

conn.close()
print("\n=== KONTROL TAMAMLANDI ===")
