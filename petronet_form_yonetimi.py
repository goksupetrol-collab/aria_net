"""
PetroNet Form Yönetimi - Tab/Form açma-kapama mantığı
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
    
    # userformlar tablosunu incele
    print("=" * 80)
    print("USERFORMLAR TABLOSU (Form tanımları)")
    print("=" * 80)
    
    cursor.execute("""
        SELECT 
            COLUMN_NAME,
            DATA_TYPE,
            CHARACTER_MAXIMUM_LENGTH,
            IS_NULLABLE
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'userformlar'
        ORDER BY ORDINAL_POSITION
    """)
    
    form_columns = cursor.fetchall()
    print("\nSutunlar:")
    for col in form_columns:
        print(f"  {col[0]:<25} {col[1]:<20} {col[2] if col[2] else '':<10} {col[3]}")
    
    cursor.execute("SELECT TOP 10 * FROM userformlar")
    form_data = cursor.fetchall()
    if form_data:
        print(f"\nOrnek veri (ilk 10 kayit):")
        for i, row in enumerate(form_data, 1):
            print(f"\n  Kayit {i}:")
            for j, val in enumerate(row):
                col_name = form_columns[j][0]
                val_str = str(val)[:50] if val else "NULL"
                print(f"    {col_name}: {val_str}")
    
    # userformhrk tablosunu incele
    print("\n" + "=" * 80)
    print("USERFORMHRK TABLOSU (Form hareket/kullanım)")
    print("=" * 80)
    
    cursor.execute("""
        SELECT 
            COLUMN_NAME,
            DATA_TYPE,
            CHARACTER_MAXIMUM_LENGTH,
            IS_NULLABLE
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'userformhrk'
        ORDER BY ORDINAL_POSITION
    """)
    
    formhrk_columns = cursor.fetchall()
    print("\nSutunlar:")
    for col in formhrk_columns:
        print(f"  {col[0]:<25} {col[1]:<20} {col[2] if col[2] else '':<10} {col[3]}")
    
    cursor.execute("SELECT TOP 10 * FROM userformhrk ORDER BY id DESC")
    formhrk_data = cursor.fetchall()
    if formhrk_data:
        print(f"\nOrnek veri (son 10 kayit):")
        for i, row in enumerate(formhrk_data, 1):
            print(f"\n  Kayit {i}:")
            for j, val in enumerate(row):
                col_name = formhrk_columns[j][0]
                val_str = str(val)[:50] if val else "NULL"
                print(f"    {col_name}: {val_str}")
    
    # userformhak tablosunu incele (yetki)
    print("\n" + "=" * 80)
    print("USERFORMHAK TABLOSU (Form yetkileri)")
    print("=" * 80)
    
    cursor.execute("""
        SELECT 
            COLUMN_NAME,
            DATA_TYPE,
            CHARACTER_MAXIMUM_LENGTH,
            IS_NULLABLE
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'userformhak'
        ORDER BY ORDINAL_POSITION
    """)
    
    formhak_columns = cursor.fetchall()
    print("\nSutunlar:")
    for col in formhak_columns:
        print(f"  {col[0]:<25} {col[1]:<20} {col[2] if col[2] else '':<10} {col[3]}")
    
    cursor.execute("SELECT TOP 5 * FROM userformhak")
    formhak_data = cursor.fetchall()
    if formhak_data:
        print(f"\nOrnek veri (ilk 5 kayit):")
        for i, row in enumerate(formhak_data, 1):
            print(f"\n  Kayit {i}:")
            for j, val in enumerate(row):
                col_name = formhak_columns[j][0]
                val_str = str(val)[:50] if val else "NULL"
                print(f"    {col_name}: {val_str}")
    
    # frm tablosunu incele
    print("\n" + "=" * 80)
    print("FRM TABLOSU (Form master)")
    print("=" * 80)
    
    cursor.execute("""
        SELECT 
            COLUMN_NAME,
            DATA_TYPE,
            CHARACTER_MAXIMUM_LENGTH,
            IS_NULLABLE
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'frm'
        ORDER BY ORDINAL_POSITION
    """)
    
    frm_columns = cursor.fetchall()
    print("\nSutunlar:")
    for col in frm_columns:
        print(f"  {col[0]:<25} {col[1]:<20} {col[2] if col[2] else '':<10} {col[3]}")
    
    cursor.execute("SELECT TOP 10 * FROM frm")
    frm_data = cursor.fetchall()
    if frm_data:
        print(f"\nOrnek veri (ilk 10 kayit):")
        for i, row in enumerate(frm_data, 1):
            print(f"\n  Kayit {i}:")
            for j, val in enumerate(row):
                col_name = frm_columns[j][0]
                val_str = str(val)[:50] if val else "NULL"
                print(f"    {col_name}: {val_str}")
    
    # Menü name ile form ilişkisi
    print("\n" + "=" * 80)
    print("MENU NAME -> FORM İLİŞKİSİ ANALİZİ")
    print("=" * 80)
    
    cursor.execute("""
        SELECT name, cap_tr
        FROM ana_menu_hrk
        WHERE user_kod = 'MEHMET'
        ORDER BY id
    """)
    
    menu_items = cursor.fetchall()
    print("\nMenü öğeleri ve muhtemel form isimleri:\n")
    for item in menu_items:
        menu_name = item[0]
        baslik = item[1]
        # mn_ -> frm_ dönüşümü
        form_name = menu_name.replace('mn_', 'frm_')
        print(f"  {menu_name:<25} -> {form_name:<25} | {baslik}")
    
    conn.close()
    print("\n" + "=" * 80)
    print("Inceleme tamamlandi!")
    print("=" * 80)
    print("\nÖNEMLİ BULGULAR:")
    print("=" * 80)
    print("1. Menü öğeleri (ana_menu_hrk) -> Form adları (mn_ -> frm_)")
    print("2. Desktop uygulaması olduğu için açık formlar bellekte tutuluyor")
    print("3. Tab sistemi muhtemelen desktop framework'ünde (DevExpress)")
    print("4. Her menü öğesi bir form açıyor, form adı name'den türetiliyor")
    print("=" * 80)
    
except Exception as e:
    print(f"HATA: {e}")
    import traceback
    traceback.print_exc()
