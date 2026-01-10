"""
PetroNet Menü Yapısı Detaylı İnceleme
ana_menu_hrk tablosundaki tüm menü öğelerini listeler
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
    print("ANA MENU OĞELERI (ana_menu_hrk)")
    print("=" * 80)
    
    # Tüm menü öğelerini listele
    cursor.execute("""
        SELECT id, user_kod, name, class, icon_index, cap_tr, Modul
        FROM ana_menu_hrk
        ORDER BY id
    """)
    
    rows = cursor.fetchall()
    print(f"\nToplam {len(rows)} menü öğesi bulundu:\n")
    
    for row in rows:
        print(f"ID: {row[0]}")
        print(f"  Kullanici: {row[1]}")
        print(f"  Name: {row[2]}")
        print(f"  Class: {row[3]}")
        print(f"  Icon Index: {row[4]}")
        print(f"  Baslik (TR): {row[5]}")
        print(f"  Modul: {row[6]}")
        print()
    
    print("=" * 80)
    print("MENU YAPISI ANALIZI")
    print("=" * 80)
    
    # Kullanıcı bazında grupla
    cursor.execute("""
        SELECT DISTINCT user_kod 
        FROM ana_menu_hrk
        ORDER BY user_kod
    """)
    users = [row[0] for row in cursor.fetchall()]
    
    print(f"\nKullanici sayisi: {len(users)}")
    for user in users:
        cursor.execute("""
            SELECT COUNT(*) 
            FROM ana_menu_hrk 
            WHERE user_kod = ?
        """, user)
        count = cursor.fetchone()[0]
        print(f"  {user}: {count} menü öğesi")
    
    # Class tiplerini analiz et
    print("\n" + "=" * 80)
    print("BUTON SINIFLARI")
    print("=" * 80)
    cursor.execute("""
        SELECT DISTINCT class, COUNT(*) as sayi
        FROM ana_menu_hrk
        GROUP BY class
        ORDER BY sayi DESC
    """)
    classes = cursor.fetchall()
    for cls in classes:
        print(f"  {cls[0]}: {cls[1]} adet")
    
    conn.close()
    print("\n" + "=" * 80)
    print("Inceleme tamamlandi!")
    print("=" * 80)
    
except Exception as e:
    print(f"HATA: {e}")
    import traceback
    traceback.print_exc()
