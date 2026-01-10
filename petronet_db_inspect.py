"""
PetroNet Veritabanı Tablo Yapılarını İnceleme Scripti
Bu script petromas_db veritabanındaki tabloları ve yapılarını listeler
"""
import pyodbc
import sys

# Bağlantı bilgileri
SERVER = '81.214.134.225,9012'
DATABASE = 'TP_2025'  # 2025 veritabanı
USERNAME = 'sa'
PASSWORD = 'Petro1410+'

try:
    # SQL Server bağlantısı
    connection_string = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}'
    
    print("PetroNet veritabanina baglaniyor...")
    conn = pyodbc.connect(connection_string)
    cursor = conn.cursor()
    
    print("Baglanti basarili!\n")
    
    # Tüm tabloları listele
    print("=" * 80)
    print("VERITABANINDAKI TUM TABLOLAR")
    print("=" * 80)
    cursor.execute("""
        SELECT TABLE_NAME 
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_TYPE = 'BASE TABLE'
        ORDER BY TABLE_NAME
    """)
    
    tables = cursor.fetchall()
    print(f"\nToplam {len(tables)} tablo bulundu:\n")
    
    for i, table in enumerate(tables, 1):
        print(f"{i}. {table[0]}")
    
    # Tüm tabloların yapılarını detaylı incele
    print("\n" + "=" * 80)
    print("TUM TABLOLARIN YAPILARI")
    print("=" * 80)
    
    # Tüm tabloları incele
    important_tables = [table[0] for table in tables]
    
    for table_name in important_tables:
        print(f"\nTABLO: {table_name}")
        print("-" * 80)
        
        # Sütun bilgilerini al
        cursor.execute(f"""
            SELECT 
                COLUMN_NAME,
                DATA_TYPE,
                CHARACTER_MAXIMUM_LENGTH,
                IS_NULLABLE,
                COLUMN_DEFAULT
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = '{table_name}'
            ORDER BY ORDINAL_POSITION
        """)
        
        columns = cursor.fetchall()
        print(f"Sütun sayısı: {len(columns)}\n")
        
        for col in columns:
            col_name = col[0]
            col_type = col[1]
            col_length = f"({col[2]})" if col[2] else ""
            nullable = "NULL" if col[3] == "YES" else "NOT NULL"
            default = f" DEFAULT {col[4]}" if col[4] else ""
            
            print(f"  • {col_name:<30} {col_type}{col_length:<15} {nullable}{default}")
        
        # İlk 3 satırı göster
        try:
            cursor.execute(f"SELECT TOP 3 * FROM [{table_name}]")
            rows = cursor.fetchall()
            if rows:
                print(f"\n  Örnek veri (ilk 3 satır):")
                for row in rows:
                    print(f"    {row}")
        except Exception as e:
            print(f"  UYARI: Veri okunamadi: {str(e)}")
    
    conn.close()
    print("\n" + "=" * 80)
    print("Inceleme tamamlandi!")
    print("=" * 80)
    
except pyodbc.Error as e:
    print(f"HATA: Veritabani baglanti hatasi: {e}")
    print("\nCozum onerileri:")
    print("1. pyodbc kurulu mu kontrol edin: pip install pyodbc")
    print("2. ODBC Driver 17 for SQL Server kurulu mu kontrol edin")
    print("3. Firewall ayarlarini kontrol edin")
    sys.exit(1)
except Exception as e:
    print(f"HATA: {e}")
    sys.exit(1)
