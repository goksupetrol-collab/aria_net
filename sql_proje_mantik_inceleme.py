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

print("=" * 70)
print("SQL SERVER PROJE MANTIGI INCELEME")
print("=" * 70)

# 1. Tüm veritabanlarını listele
print("\n1. VERITABANLARI:")
cursor.execute("SELECT name FROM sys.databases WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')")
databases = cursor.fetchall()
for db in databases:
    print(f"  - {db[0]}")

# 2. En büyük/aktif veritabanını bul ve incele
if databases:
    db_name = databases[0][0]
    print(f"\n2. VERITABANI SECIMI: {db_name}")
    
    # Bu veritabanına geç
    cursor.execute(f"USE [{db_name}]")
    
    # Tabloları listele
    print(f"\n3. TABLOLAR ({db_name}):")
    cursor.execute("""
        SELECT TABLE_NAME, TABLE_TYPE
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_TYPE = 'BASE TABLE'
        ORDER BY TABLE_NAME
    """)
    tables = cursor.fetchall()
    print(f"  Toplam {len(tables)} tablo bulundu:")
    for table in tables[:20]:  # İlk 20 tablo
        print(f"    - {table[0]}")
    if len(tables) > 20:
        print(f"    ... ve {len(tables) - 20} tablo daha")
    
    # Örnek tablo yapısını incele (ilk tablo)
    if tables:
        sample_table = tables[0][0]
        print(f"\n4. ORNEK TABLO YAPISI: {sample_table}")
        cursor.execute(f"""
            SELECT 
                COLUMN_NAME,
                DATA_TYPE,
                IS_NULLABLE,
                COLUMN_DEFAULT
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = '{sample_table}'
            ORDER BY ORDINAL_POSITION
        """)
        columns = cursor.fetchall()
        for col in columns:
            nullable = "NULL" if col[2] == "YES" else "NOT NULL"
            default = f" DEFAULT {col[3]}" if col[3] else ""
            print(f"    - {col[0]} ({col[1]}) {nullable}{default}")
    
    # Foreign key ilişkilerini incele
    print(f"\n5. TABLO ILISKILERI (Foreign Keys):")
    cursor.execute("""
        SELECT 
            fk.name AS FK_Name,
            OBJECT_NAME(fk.parent_object_id) AS Parent_Table,
            cp.name AS Parent_Column,
            OBJECT_NAME(fk.referenced_object_id) AS Referenced_Table,
            cr.name AS Referenced_Column
        FROM sys.foreign_keys AS fk
        INNER JOIN sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
        INNER JOIN sys.columns AS cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
        INNER JOIN sys.columns AS cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
        ORDER BY Parent_Table
    """)
    fks = cursor.fetchall()
    if fks:
        print(f"  Toplam {len(fks)} ilişki bulundu:")
        for fk in fks[:10]:  # İlk 10 ilişki
            print(f"    {fk[1]}.{fk[2]} -> {fk[3]}.{fk[4]}")
        if len(fks) > 10:
            print(f"    ... ve {len(fks) - 10} ilişki daha")
    else:
        print("  İlişki bulunamadı")
    
    # Stored procedure'leri kontrol et
    print(f"\n6. STORED PROCEDURES:")
    cursor.execute("""
        SELECT name, create_date, modify_date
        FROM sys.procedures
        WHERE is_ms_shipped = 0
        ORDER BY name
    """)
    procs = cursor.fetchall()
    if procs:
        print(f"  Toplam {len(procs)} stored procedure bulundu:")
        for proc in procs[:10]:
            print(f"    - {proc[0]} (Oluşturulma: {proc[1]})")
        if len(procs) > 10:
            print(f"    ... ve {len(procs) - 10} procedure daha")
    else:
        print("  Stored procedure bulunamadı")
    
    # View'leri kontrol et
    print(f"\n7. VIEWS (Gorunumler):")
    cursor.execute("""
        SELECT name, create_date
        FROM sys.views
        WHERE is_ms_shipped = 0
        ORDER BY name
    """)
    views = cursor.fetchall()
    if views:
        print(f"  Toplam {len(views)} view bulundu:")
        for view in views[:10]:
            print(f"    - {view[0]}")
        if len(views) > 10:
            print(f"    ... ve {len(views) - 10} view daha")
    else:
        print("  View bulunamadı")

print("\n" + "=" * 70)
print("OZET:")
print("=" * 70)
print("""
Bu inceleme sadece VERITABANI YAPISINI goruntuler.
- Tablo isimleri
- Kolon yapilari
- Iliskiler (Foreign Keys)
- Stored Procedures
- Views

Bu bilgiler LISANS IHLALI DEGILDIR cunku:
1. Veritabani yapisi genel bilgidir
2. Tablo/kolon isimleri telif hakki kapsaminda degildir
3. Sadece YAPISAL bilgi, VERI degil

RISKLI OLAN:
- Gercek verileri kopyalamak
- Ticari kodlari kopyalamak
- Lisansli yazilimin kendisini kopyalamak

GUVENLI OLAN:
- Veritabani yapisini anlamak
- Kendi projenizde benzer yapi kurmak
- Farkli teknoloji ile ayni mantigi uygulamak
""")

conn.close()
