"""
PetroNet Veritabanı - Menü Yapısını İnceleme
Menü, navigation, toolbar gibi tabloları arar
"""
import pyodbc

SERVER = '81.214.134.225,9012'
DATABASE = 'TP_2025'
USERNAME = 'sa'
PASSWORD = 'Petro1410+'

try:
    connection_string = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}'
    
    print("PetroNet veritabanina baglaniyor...")
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
    print("MENU/Navigation/Toolbar TABLOLARINI ARIYORUM...")
    print("=" * 80)
    
    # Menü ile ilgili tabloları ara
    menu_keywords = ['menu', 'navigation', 'nav', 'toolbar', 'ribbon', 'button', 'ikon', 'icon', 'sayfa', 'page', 'modul', 'module']
    menu_tables = []
    
    for table in all_tables:
        table_lower = table.lower()
        for keyword in menu_keywords:
            if keyword in table_lower:
                menu_tables.append(table)
                break
    
    if menu_tables:
        print(f"\nMenü ile ilgili tablolar bulundu ({len(menu_tables)} adet):\n")
        for table in menu_tables:
            print(f"  - {table}")
    else:
        print("\nMenü tablosu bulunamadi. Tüm tabloları listeliyorum...")
        print(f"\nToplam {len(all_tables)} tablo var.\n")
        for i, table in enumerate(all_tables[:50], 1):  # İlk 50 tabloyu göster
            print(f"{i}. {table}")
        if len(all_tables) > 50:
            print(f"... ve {len(all_tables) - 50} tablo daha")
    
    # Eğer menü tablosu bulunduysa detaylı incele
    if menu_tables:
        print("\n" + "=" * 80)
        print("MENU TABLOLARININ YAPILARI")
        print("=" * 80)
        
        for table_name in menu_tables:
            print(f"\n{'='*80}")
            print(f"TABLO: {table_name}")
            print('='*80)
            
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
            print(f"\nSutunlar ({len(columns)} adet):\n")
            for col in columns:
                col_name = col[0]
                col_type = col[1]
                col_length = f"({col[2]})" if col[2] else ""
                nullable = "NULL" if col[3] == "YES" else "NOT NULL"
                print(f"  {col_name:<35} {col_type}{col_length:<20} {nullable}")
            
            # Veri örnekleri
            try:
                cursor.execute(f"SELECT TOP 5 * FROM [{table_name}]")
                rows = cursor.fetchall()
                if rows:
                    print(f"\n  Ornek veri (ilk 5 satir):")
                    for idx, row in enumerate(rows, 1):
                        print(f"\n    Satir {idx}:")
                        for i, val in enumerate(row):
                            col_name = columns[i][0]
                            val_str = str(val)[:50] if val else "NULL"
                            print(f"      {col_name}: {val_str}")
            except Exception as e:
                print(f"\n  UYARI: Veri okunamadi: {str(e)}")
    
    # Sistem tablolarını da kontrol et (config, settings gibi)
    print("\n" + "=" * 80)
    print("SISTEM/CONFIG TABLOLARINI ARIYORUM...")
    print("=" * 80)
    
    config_keywords = ['config', 'setting', 'system', 'sys', 'param', 'ayar']
    config_tables = []
    
    for table in all_tables:
        table_lower = table.lower()
        for keyword in config_keywords:
            if keyword in table_lower:
                config_tables.append(table)
                break
    
    if config_tables:
        print(f"\nSistem/Config tablolari bulundu ({len(config_tables)} adet):\n")
        for table in config_tables:
            print(f"  - {table}")
    
    conn.close()
    print("\n" + "=" * 80)
    print("Inceleme tamamlandi!")
    print("=" * 80)
    
except Exception as e:
    print(f"HATA: {e}")
    import traceback
    traceback.print_exc()
