"""
PetroNet Tab/Form Açma-Kapama Mantığını İnceleme
Hangi formlar açılıyor, nasıl yönetiliyor
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
    
    # Form/ekran ile ilgili tabloları ara
    print("=" * 80)
    print("FORM/EKRAN TABLOLARINI ARIYORUM...")
    print("=" * 80)
    
    cursor.execute("""
        SELECT TABLE_NAME 
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_TYPE = 'BASE TABLE'
        ORDER BY TABLE_NAME
    """)
    all_tables = [row[0] for row in cursor.fetchall()]
    
    form_keywords = ['form', 'ekran', 'sayfa', 'page', 'window', 'pencere', 'frm', 'ekr', 'tab']
    form_tables = []
    
    for table in all_tables:
        table_lower = table.lower()
        for keyword in form_keywords:
            if keyword in table_lower:
                form_tables.append(table)
                break
    
    if form_tables:
        print(f"\nForm/Ekran tablolari bulundu ({len(form_tables)} adet):\n")
        for table in form_tables:
            print(f"  - {table}")
    else:
        print("\nForm tablosu bulunamadi.")
    
    # Menü öğelerinin name'lerini incele (hangi formlara bağlı)
    print("\n" + "=" * 80)
    print("MENU OĞELERI - NAME VE FORM İLİŞKİSİ")
    print("=" * 80)
    
    cursor.execute("""
        SELECT name, cap_tr, icon_index
        FROM ana_menu_hrk
        WHERE user_kod = 'MEHMET'
        ORDER BY id
    """)
    
    menu_items = cursor.fetchall()
    print(f"\nMEHMET kullanicisi icin menü öğeleri ve muhtemel form isimleri:\n")
    
    for item in menu_items:
        name = item[0]
        cap_tr = item[1]
        icon = item[2]
        # Name'den form adını tahmin et
        form_name = name.replace('mn_', 'frm_')  # mn_ -> frm_ (form prefix)
        print(f"  Menu: {name:<25} -> Form: {form_name:<25} | Baslik: {cap_tr:<40} | Icon: {icon}")
    
    # Açık formlar/tab'lar için tablo var mı?
    print("\n" + "=" * 80)
    print("ACIK FORM/TAB YÖNETİMİ TABLOLARINI ARIYORUM...")
    print("=" * 80)
    
    open_keywords = ['acik', 'open', 'aktif', 'active', 'tab', 'sekme', 'pencere', 'window']
    open_tables = []
    
    for table in all_tables:
        table_lower = table.lower()
        for keyword in open_keywords:
            if keyword in table_lower:
                open_tables.append(table)
                break
    
    if open_tables:
        print(f"\nAçık form/tab tablolari bulundu ({len(open_tables)} adet):\n")
        for table in open_tables:
            print(f"  - {table}")
            # Tablo yapısını göster
            cursor.execute(f"""
                SELECT COLUMN_NAME, DATA_TYPE
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_NAME = '{table}'
                ORDER BY ORDINAL_POSITION
            """)
            cols = cursor.fetchall()
            print(f"    Sutunlar: {', '.join([c[0] for c in cols])}")
    else:
        print("\nAçık form/tab tablosu bulunamadi.")
        print("NOT: Desktop uygulamasında açık formlar muhtemelen bellekte tutuluyor, veritabanında saklanmıyor.")
    
    # Menü mas tablosunu detaylı incele
    print("\n" + "=" * 80)
    print("ANA_MENU_MAS TABLOSU DETAYLI İNCELEME")
    print("=" * 80)
    
    cursor.execute("""
        SELECT 
            COLUMN_NAME,
            DATA_TYPE,
            CHARACTER_MAXIMUM_LENGTH,
            IS_NULLABLE
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'ana_menu_mas'
        ORDER BY ORDINAL_POSITION
    """)
    
    mas_columns = cursor.fetchall()
    print("\nSutunlar:")
    for col in mas_columns:
        print(f"  {col[0]:<20} {col[1]:<20} {col[2] if col[2] else '':<10} {col[3]}")
    
    # Menü mas verilerini göster
    cursor.execute("""
        SELECT *
        FROM ana_menu_mas
    """)
    mas_data = cursor.fetchall()
    print(f"\nVeri ({len(mas_data)} kayıt):")
    for row in mas_data:
        print(f"  {row}")
    
    # Menü hrk ve mas ilişkisi
    print("\n" + "=" * 80)
    print("MENU HRK VE MAS İLİŞKİSİ")
    print("=" * 80)
    
    cursor.execute("""
        SELECT 
            hrk.id,
            hrk.user_kod,
            hrk.name,
            hrk.cap_tr,
            mas.kisayol_cap,
            mas.style
        FROM ana_menu_hrk hrk
        LEFT JOIN ana_menu_mas mas ON hrk.user_kod = mas.user_kod
        WHERE hrk.user_kod = 'MEHMET'
        ORDER BY hrk.id
    """)
    
    relations = cursor.fetchall()
    print(f"\nMenü öğeleri ve kullanıcı ayarları ({len(relations)} kayıt):\n")
    for rel in relations:
        print(f"  ID: {rel[0]:<5} | User: {rel[1]:<10} | Name: {rel[2]:<20} | Baslik: {rel[3]:<35} | Kisayol: {rel[4]} | Style: {rel[5]}")
    
    conn.close()
    print("\n" + "=" * 80)
    print("Inceleme tamamlandi!")
    print("=" * 80)
    
except Exception as e:
    print(f"HATA: {e}")
    import traceback
    traceback.print_exc()
