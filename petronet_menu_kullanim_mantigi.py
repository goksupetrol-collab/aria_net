"""
PetroNet Menü Kullanım Mantığını İnceleme
Menü öğelerinin nasıl gruplandığı, hangi formlara bağlı olduğu
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
    
    print("=" * 80)
    print("MENU OĞELERI - DETAYLI INCELEME")
    print("=" * 80)
    
    # Tüm menü öğelerini sıra numarasına göre listele
    cursor.execute("""
        SELECT id, user_kod, name, class, icon_index, cap_tr, Modul
        FROM ana_menu_hrk
        WHERE user_kod = 'MEHMET'
        ORDER BY id
    """)
    
    rows = cursor.fetchall()
    print(f"\nMEHMET kullanicisi icin {len(rows)} menü öğesi:\n")
    
    for row in rows:
        print(f"ID: {row[0]:<5} | Name: {row[2]:<20} | Icon: {row[4]:<5} | Baslik: {row[5]}")
    
    print("\n" + "=" * 80)
    print("MENU MAS TABLOSU (ana_menu_mas)")
    print("=" * 80)
    
    # ana_menu_mas tablosunu incele
    cursor.execute("""
        SELECT id, user_kod, kisayol_cap, style, coklu_satir, Modul, Eski_Style
        FROM ana_menu_mas
        ORDER BY id
    """)
    
    mas_rows = cursor.fetchall()
    print(f"\nToplam {len(mas_rows)} kayıt:\n")
    
    for row in mas_rows:
        print(f"ID: {row[0]:<5} | User: {row[1]:<15} | Kisayol: {row[2]} | Style: {row[3]}")
    
    print("\n" + "=" * 80)
    print("MENU YAPISI ANALIZI")
    print("=" * 80)
    
    # Class tiplerini analiz et
    cursor.execute("""
        SELECT DISTINCT class, COUNT(*) as sayi
        FROM ana_menu_hrk
        GROUP BY class
        ORDER BY sayi DESC
    """)
    classes = cursor.fetchall()
    print("\nButon Siniflari:")
    for cls in classes:
        print(f"  {cls[0]}: {cls[1]} adet")
    
    # Icon index dağılımı
    cursor.execute("""
        SELECT icon_index, COUNT(*) as sayi
        FROM ana_menu_hrk
        WHERE icon_index IS NOT NULL
        GROUP BY icon_index
        ORDER BY sayi DESC
    """)
    icons = cursor.fetchall()
    print("\nIcon Index Dagilimi (en cok kullanilanlar):")
    for icon in icons[:10]:
        print(f"  Icon {icon[0]}: {icon[1]} adet")
    
    # Modul analizi
    cursor.execute("""
        SELECT Modul, COUNT(*) as sayi
        FROM ana_menu_hrk
        GROUP BY Modul
        ORDER BY sayi DESC
    """)
    modules = cursor.fetchall()
    print("\nModul Dagilimi:")
    for mod in modules:
        print(f"  {mod[0] if mod[0] else 'NULL'}: {mod[1]} adet")
    
    # Menü öğelerinin name'lerine göre grupla (hangi formlara bağlı)
    print("\n" + "=" * 80)
    print("MENU OĞELERI - NAME ANALIZI (Hangi formlara bagli)")
    print("=" * 80)
    
    cursor.execute("""
        SELECT name, cap_tr, COUNT(*) as kullanici_sayisi
        FROM ana_menu_hrk
        GROUP BY name, cap_tr
        ORDER BY kullanici_sayisi DESC, name
    """)
    
    name_groups = cursor.fetchall()
    print(f"\nToplam {len(name_groups)} farkli menu ogesi:\n")
    for ng in name_groups:
        print(f"  {ng[0]:<25} -> {ng[1]:<40} ({ng[2]} kullanici)")
    
    conn.close()
    print("\n" + "=" * 80)
    print("Inceleme tamamlandi!")
    print("=" * 80)
    
except Exception as e:
    print(f"HATA: {e}")
    import traceback
    traceback.print_exc()
