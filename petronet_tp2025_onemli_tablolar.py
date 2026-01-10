"""
TP_2025 Veritabanı - Önemli Tabloları İnceleme
Satış, Tahsilat, Ödeme, Vardiya gibi önemli tabloları detaylı inceler
"""
import pyodbc
import sys

SERVER = '81.214.134.225,9012'
DATABASE = 'TP_2025'
USERNAME = 'sa'
PASSWORD = 'Petro1410+'

# İncelenecek önemli tablolar
ONEMLI_TABLOLAR = [
    'pomvardimas',      # Pompacı vardiya mas
    'pomvardikap',      # Pompacı vardiya kap
    'pomvardiozet',     # Pompacı vardiya özet
    'marsatmas',        # Market satış mas
    'marsathrk',        # Market satış hareket
    'kasahrk',          # Kasa hareket
    'kasakart',         # Kasa kart
    'carihrk',          # Cari hareket
    'carikart',         # Cari kart
    'faturamas',        # Fatura mas
    'faturahrk',        # Fatura hareket
    'tahsilat',         # Tahsilat (varsa)
    'odeme',            # Ödeme (varsa)
    'stkhrk',           # Stok hareket
    'stokfiyathistory', # Stok fiyat geçmişi
]

try:
    connection_string = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}'
    
    print("TP_2025 veritabanina baglaniyor...")
    conn = pyodbc.connect(connection_string)
    cursor = conn.cursor()
    
    print("Baglanti basarili!\n")
    
    # Tüm tabloları listele
    cursor.execute("""
        SELECT TABLE_NAME 
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_TYPE = 'BASE TABLE'
        ORDER BY TABLE_NAME
    """)
    all_tables = [row[0] for row in cursor.fetchall()]
    
    print("=" * 80)
    print("ONEMLI TABLOLARIN YAPILARI")
    print("=" * 80)
    
    for table_name in ONEMLI_TABLOLAR:
        if table_name not in all_tables:
            print(f"\nTABLO: {table_name} - BULUNAMADI")
            continue
            
        print(f"\n{'='*80}")
        print(f"TABLO: {table_name}")
        print('='*80)
        
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
        print(f"\nSutun sayisi: {len(columns)}\n")
        
        for col in columns:
            col_name = col[0]
            col_type = col[1]
            col_length = f"({col[2]})" if col[2] else ""
            nullable = "NULL" if col[3] == "YES" else "NOT NULL"
            default = f" DEFAULT {col[4]}" if col[4] else ""
            
            print(f"  {col_name:<35} {col_type}{col_length:<20} {nullable}{default}")
        
        # İlk 2 satırı göster
        try:
            cursor.execute(f"SELECT TOP 2 * FROM [{table_name}]")
            rows = cursor.fetchall()
            if rows:
                print(f"\n  Ornek veri (ilk 2 satir):")
                for idx, row in enumerate(rows, 1):
                    print(f"\n    Satir {idx}:")
                    for i, val in enumerate(row):
                        col_name = columns[i][0]
                        print(f"      {col_name}: {val}")
        except Exception as e:
            print(f"\n  UYARI: Veri okunamadi: {str(e)}")
    
    # Tahsilat ve Ödeme tablolarını ara
    print("\n" + "=" * 80)
    print("TAHSILAT VE ODEME TABLOLARINI ARIYORUM...")
    print("=" * 80)
    
    tahsilat_tables = [t for t in all_tables if 'tahsilat' in t.lower() or 'tahsil' in t.lower()]
    odeme_tables = [t for t in all_tables if 'odeme' in t.lower() or 'odeme' in t.lower()]
    
    if tahsilat_tables:
        print(f"\nTahsilat tablolari bulundu: {', '.join(tahsilat_tables)}")
    else:
        print("\nTahsilat tablosu bulunamadi.")
    
    if odeme_tables:
        print(f"\nOdeme tablolari bulundu: {', '.join(odeme_tables)}")
    else:
        print("\nOdeme tablosu bulunamadi.")
    
    conn.close()
    print("\n" + "=" * 80)
    print("Inceleme tamamlandi!")
    print("=" * 80)
    
except Exception as e:
    print(f"HATA: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
