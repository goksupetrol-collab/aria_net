import pyodbc

SERVER = '81.214.134.225,9012'
DATABASE = 'TP_2025'
USERNAME = 'sa'
PASSWORD = 'Petro1410+'

conn = pyodbc.connect(f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}')
cursor = conn.cursor()

cursor.execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' ORDER BY TABLE_NAME")
tables = [row[0] for row in cursor.fetchall()]

tahsilat = [t for t in tables if 'tahsilat' in t.lower() or 'tahsil' in t.lower()]
odeme = [t for t in tables if 'odeme' in t.lower()]
gelir = [t for t in tables if 'gelir' in t.lower()]
gider = [t for t in tables if 'gider' in t.lower()]

print('TAHSILAT TABLOLARI:', tahsilat)
print('ODEME TABLOLARI:', odeme)
print('GELIR TABLOLARI:', gelir)
print('GIDER TABLOLARI:', gider)

conn.close()
