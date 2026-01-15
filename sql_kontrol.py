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

# Aktif bağlantılar ve programlar
cursor.execute("""
    SELECT 
        login_name,
        host_name,
        program_name,
        client_interface_name,
        login_time
    FROM sys.dm_exec_sessions 
    WHERE is_user_process = 1
""")

print("=== BAGLI PROGRAMLAR ===")
for row in cursor:
    print(f"Kullanici: {row[0]}")
    print(f"Bilgisayar: {row[1]}")
    print(f"Program: {row[2]}")
    print(f"Arayuz: {row[3]}")
    print(f"Giris Zamani: {row[4]}")
    print("-" * 40)

# Veritabanları listesi
cursor.execute("SELECT name FROM sys.databases WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')")
print("\n=== VERITABANLARI ===")
for row in cursor:
    print(f"- {row[0]}")

conn.close()
