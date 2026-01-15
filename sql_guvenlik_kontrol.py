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

# Aktif bağlantılar
cursor.execute("SELECT login_name, host_name, program_name FROM sys.dm_exec_sessions WHERE is_user_process = 1")
print("=== BAGLI KULLANICILAR ===")
for row in cursor:
    print(f"Kullanici: {row[0]}, Bilgisayar: {row[1]}, Program: {row[2]}")

# Uzak giriş durumu
cursor.execute("SELECT SERVERPROPERTY('IsRemoteLoginEnabled') as IsRemoteLoginEnabled")
row = cursor.fetchone()
print(f"\nUzak giris aktif mi: {row[0]}")

conn.close()
