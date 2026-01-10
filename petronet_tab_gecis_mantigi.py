"""
PetroNet Tab/İkon Geçiş Mantığı - Odaklanmış İnceleme
Sadece tab'lar arası geçiş, ikonlar arası geçiş, kapatma/açma mantığı
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
    
    # 1. MENÜ -> FORM İLİŞKİSİ (Tab açma mantığı)
    print("=" * 80)
    print("1. MENU -> FORM İLİŞKİSİ (Tab açma mantığı)")
    print("=" * 80)
    
    cursor.execute("""
        SELECT 
            hrk.name as menu_name,
            hrk.cap_tr as menu_baslik,
            hrk.icon_index,
            frm.frm as form_adi,
            frm.frmtr as form_baslik,
            frm.anaformnesne
        FROM ana_menu_hrk hrk
        LEFT JOIN frm ON hrk.name = frm.anaformnesne
        WHERE hrk.user_kod = 'MEHMET'
        ORDER BY hrk.id
    """)
    
    menu_form_relations = cursor.fetchall()
    print(f"\nMenü öğesi -> Form ilişkisi ({len(menu_form_relations)} kayıt):\n")
    for rel in menu_form_relations:
        menu_name = rel[0]
        menu_baslik = rel[1]
        icon = rel[2]
        form_adi = rel[3] if rel[3] else "BULUNAMADI"
        form_baslik = rel[4] if rel[4] else "BULUNAMADI"
        anaform = rel[5] if rel[5] else "NULL"
        print(f"  Menu: {menu_name:<20} -> Form: {form_adi:<30} | Tab Baslik: {form_baslik:<35} | Icon: {icon}")
    
    # 2. FORM SIRALAMA (Tab'ların görünme sırası)
    print("\n" + "=" * 80)
    print("2. FORM SIRALAMA (Tab'ların görünme sırası)")
    print("=" * 80)
    
    cursor.execute("""
        SELECT 
            frm.id,
            frm.frm,
            frm.frmtr,
            frm.anaformnesne,
            frm.bolumid
        FROM frm
        WHERE anaformnesne IN (SELECT name FROM ana_menu_hrk WHERE user_kod = 'MEHMET')
        ORDER BY frm.id
    """)
    
    form_order = cursor.fetchall()
    print(f"\nForm sıralaması ({len(form_order)} kayıt):\n")
    for form in form_order:
        print(f"  ID: {form[0]:<5} | Form: {form[1]:<30} | Baslik: {form[2]:<35} | Menu: {form[3]}")
    
    # 3. MENÜ SIRALAMA (İkonların görünme sırası)
    print("\n" + "=" * 80)
    print("3. MENU SIRALAMA (İkonların görünme sırası - Ribbon butonları)")
    print("=" * 80)
    
    cursor.execute("""
        SELECT 
            id,
            name,
            cap_tr,
            icon_index,
            class
        FROM ana_menu_hrk
        WHERE user_kod = 'MEHMET'
        ORDER BY id
    """)
    
    menu_order = cursor.fetchall()
    print(f"\nMenü öğeleri sırası ({len(menu_order)} kayıt):\n")
    for menu in menu_order:
        print(f"  ID: {menu[0]:<5} | Name: {menu[1]:<20} | Baslik: {menu[2]:<35} | Icon: {menu[3]}")
    
    # 4. TAB/FORM AÇMA MANTIĞI (name -> form mapping)
    print("\n" + "=" * 80)
    print("4. TAB/FORM AÇMA MANTIĞI (name -> form mapping)")
    print("=" * 80)
    
    print("\nMantık:")
    print("  - Menü öğesine tıklayınca -> name alanı kullanılıyor")
    print("  - name (örn: mn_pomvardiya) -> frm.anaformnesne ile eşleşiyor")
    print("  - frm.frmtr -> Tab'da görünen başlık oluyor")
    print("  - frm.frm -> Açılacak form adı")
    
    # Örnek mapping
    print("\nÖrnek Mapping:")
    cursor.execute("""
        SELECT 
            hrk.name,
            hrk.cap_tr as menu_baslik,
            frm.frm,
            frm.frmtr as tab_baslik
        FROM ana_menu_hrk hrk
        LEFT JOIN frm ON hrk.name = frm.anaformnesne
        WHERE hrk.user_kod = 'MEHMET' AND hrk.id IN (90, 91)
    """)
    
    examples = cursor.fetchall()
    for ex in examples:
        print(f"  Tıklama: {ex[1]:<30} (menu)")
        print(f"    -> name: {ex[0]}")
        print(f"    -> form: {ex[2] if ex[2] else 'BULUNAMADI'}")
        print(f"    -> Tab başlık: {ex[3] if ex[3] else 'BULUNAMADI'}")
        print()
    
    # 5. TAB KAPATMA MANTIĞI (Desktop uygulaması - bellekte)
    print("=" * 80)
    print("5. TAB KAPATMA MANTIĞI")
    print("=" * 80)
    print("\nNOT: Desktop uygulaması olduğu için:")
    print("  - Açık tab'lar bellekte tutuluyor (veritabanında değil)")
    print("  - X butonuna tıklayınca form.Close() çağrılıyor")
    print("  - Tüm formlar kapanınca ana form (lobi) görünüyor")
    print("  - Tab'lar arası geçiş: form.BringToFront() veya benzeri")
    
    conn.close()
    print("\n" + "=" * 80)
    print("Inceleme tamamlandi!")
    print("=" * 80)
    
    print("\n" + "=" * 80)
    print("ÖNEMLİ BULGULAR - TAB/İKON GEÇİŞ MANTIĞI:")
    print("=" * 80)
    print("1. Menü öğesi (ana_menu_hrk.name) -> Form (frm.anaformnesne) eşleşmesi")
    print("2. Tab başlığı: frm.frmtr (Türkçe form adı)")
    print("3. İkonlar: ana_menu_hrk.icon_index")
    print("4. Sıralama: ana_menu_hrk.id (ribbon butonları sırası)")
    print("5. Tab'lar dinamik açılıyor, her sayfada aynı mantık")
    print("6. Desktop uygulaması: Tab'lar bellekte, X ile kapanıyor")
    print("=" * 80)
    
except Exception as e:
    print(f"HATA: {e}")
    import traceback
    traceback.print_exc()
