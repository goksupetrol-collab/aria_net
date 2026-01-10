"""
PetroNet TP_2025 - Şirket/Firma Tanımlarını İnceleme
Yağcılar, Tepekum, Namdar vb. şirket bilgilerini listeler
"""
import pyodbc

SERVER = '81.214.134.225,9012'
DATABASE = 'TP_2025'
USERNAME = 'sa'
PASSWORD = 'Petro1410+'

try:
    conn = pyodbc.connect(f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}')
    cursor = conn.cursor()
    
    print("=" * 80)
    print("FIRMA/SIRKET TANIMLARI")
    print("=" * 80)
    
    # Firma tablosunu incele
    cursor.execute("""
        SELECT TABLE_NAME 
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_NAME LIKE '%firma%' OR TABLE_NAME LIKE '%sirket%' OR TABLE_NAME LIKE '%Firma%'
        ORDER BY TABLE_NAME
    """)
    firma_tables = [row[0] for row in cursor.fetchall()]
    
    print(f"\nFirma/Sirket tablolari: {firma_tables}\n")
    
    # Firma tablosunu detaylı incele
    if 'Firma' in firma_tables or len(firma_tables) > 0:
        table_name = 'Firma' if 'Firma' in firma_tables else firma_tables[0]
        
        print(f"TABLO: {table_name}")
        print("-" * 80)
        
        # Sütun bilgilerini al
        cursor.execute(f"""
            SELECT 
                COLUMN_NAME,
                DATA_TYPE,
                CHARACTER_MAXIMUM_LENGTH,
                IS_NULLABLE
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = '{table_name}'
            ORDER BY ORDINAL_POSITION
        """)
        
        columns = cursor.fetchall()
        print(f"\nSutun sayisi: {len(columns)}\n")
        
        for col in columns:
            col_name = col[0]
            col_type = col[1]
            col_length = f"({col[2]})" if col[2] else ""
            nullable = "NULL" if col[3] == "YES" else "NOT NULL"
            print(f"  {col_name:<35} {col_type}{col_length:<20} {nullable}")
        
        # Tüm firmaları listele
        print("\n" + "=" * 80)
        print("TUM FIRMALAR")
        print("=" * 80)
        
        cursor.execute(f"SELECT * FROM [{table_name}] ORDER BY kod")
        firms = cursor.fetchall()
        
        print(f"\nToplam {len(firms)} firma bulundu:\n")
        
        # Sütun isimlerini al
        col_names = [col[0] for col in columns]
        
        for firm in firms:
            print(f"\nFirma Bilgileri:")
            for i, val in enumerate(firm):
                if i < len(col_names):
                    print(f"  {col_names[i]}: {val}")
            print("-" * 80)
    
    conn.close()
    print("\nInceleme tamamlandi!")
    
except Exception as e:
    print(f"HATA: {e}")
    import traceback
    traceback.print_exc()
