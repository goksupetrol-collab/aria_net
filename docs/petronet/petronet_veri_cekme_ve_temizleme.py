import pyodbc
import json
import csv
import os
from datetime import datetime
import time

# Bağlantı bilgileri
SERVER = '127.0.0.1,6543'
DATABASE = 'master'  # Önce master'a bağlanıp veritabanlarını listeleyeceğiz
UID = 'sa'
PWD = 'Petro1410+!'
DRIVER = 'ODBC Driver 17 for SQL Server'

# Kayıt klasörü (PC'nizde)
KAYIT_KLASORU = r'D:\tayfun\petronet_veriler'
os.makedirs(KAYIT_KLASORU, exist_ok=True)

def baglan(veritabani='master'):
    """SQL Server'a bağlan"""
    try:
        conn = pyodbc.connect(
            f'DRIVER={{{DRIVER}}};'
            f'SERVER={SERVER};'
            f'DATABASE={veritabani};'
            f'UID={UID};'
            f'PWD={PWD};'
            f'TrustServerCertificate=yes'
        )
        return conn
    except Exception as e:
        print(f"❌ Bağlantı hatası ({veritabani}): {e}")
        return None

def veritabanlarini_listele():
    """Tüm veritabanlarını listele"""
    conn = baglan('master')
    if not conn:
        return []
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT name 
        FROM sys.databases 
        WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')
        AND state_desc = 'ONLINE'
        ORDER BY name
    """)
    
    veritabanlari = [row[0] for row in cursor.fetchall()]
    conn.close()
    return veritabanlari

def tablolari_listele(conn):
    """Veritabanındaki tüm tabloları listele"""
    cursor = conn.cursor()
    cursor.execute("""
        SELECT TABLE_SCHEMA, TABLE_NAME
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_TYPE = 'BASE TABLE'
        ORDER BY TABLE_SCHEMA, TABLE_NAME
    """)
    return cursor.fetchall()

def tablo_verilerini_al(conn, schema, tablo):
    """Bir tablonun tüm verilerini al"""
    try:
        cursor = conn.cursor()
        sorgu = f"SELECT * FROM [{schema}].[{tablo}]"
        cursor.execute(sorgu)
        
        # Sütun isimlerini al
        columns = [column[0] for column in cursor.description]
        
        # Tüm satırları al
        rows = cursor.fetchall()
        
        # Dictionary listesine çevir
        veriler = []
        for row in rows:
            veri_dict = {}
            for i, col in enumerate(columns):
                # None değerleri ve datetime objelerini JSON'a uygun hale getir
                if row[i] is None:
                    veri_dict[col] = None
                elif isinstance(row[i], datetime):
                    veri_dict[col] = row[i].isoformat()
                else:
                    veri_dict[col] = row[i]
            veriler.append(veri_dict)
        
        return veriler, columns
    except Exception as e:
        print(f"  ⚠️  Hata ({schema}.{tablo}): {e}")
        return [], []

def verileri_kaydet(veritabani, schema, tablo, veriler, columns):
    """Verileri JSON ve CSV olarak kaydet"""
    klasor = os.path.join(KAYIT_KLASORU, veritabani, schema)
    os.makedirs(klasor, exist_ok=True)
    
    # JSON olarak kaydet
    json_dosya = os.path.join(klasor, f"{tablo}.json")
    with open(json_dosya, 'w', encoding='utf-8') as f:
        json.dump(veriler, f, ensure_ascii=False, indent=2, default=str)
    
    # CSV olarak kaydet
    if veriler:
        csv_dosya = os.path.join(klasor, f"{tablo}.csv")
        with open(csv_dosya, 'w', encoding='utf-8-sig', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=columns)
            writer.writeheader()
            writer.writerows(veriler)
    
    return json_dosya, csv_dosya if veriler else None

def tum_verileri_cek():
    """Tüm veritabanlarından tüm verileri çek"""
    print("=" * 60)
    print("PETRONET VERİ ÇEKME İŞLEMİ BAŞLIYOR")
    print("=" * 60)
    print(f"Kayıt klasörü: {KAYIT_KLASORU}\n")
    
    # Veritabanlarını listele
    print("📋 Veritabanları listeleniyor...")
    veritabanlari = veritabanlarini_listele()
    print(f"✅ {len(veritabanlari)} veritabanı bulundu: {', '.join(veritabanlari)}\n")
    
    toplam_tablo = 0
    toplam_satir = 0
    baslangic_zamani = time.time()
    
    for veritabani in veritabanlari:
        print(f"\n{'='*60}")
        print(f"📦 VERİTABANI: {veritabani}")
        print(f"{'='*60}")
        
        conn = baglan(veritabani)
        if not conn:
            continue
        
        # Tabloları listele
        tablolar = tablolari_listele(conn)
        print(f"📊 {len(tablolar)} tablo bulundu\n")
        
        for schema, tablo in tablolar:
            print(f"  📄 {schema}.{tablo}...", end=' ', flush=True)
            
            # Verileri al
            veriler, columns = tablo_verilerini_al(conn, schema, tablo)
            
            if veriler:
                # Kaydet
                json_dosya, csv_dosya = verileri_kaydet(veritabani, schema, tablo, veriler, columns)
                print(f"✅ {len(veriler)} satır kaydedildi")
                toplam_satir += len(veriler)
            else:
                print("⚠️  Boş tablo")
            
            toplam_tablo += 1
        
        conn.close()
    
    gecen_sure = time.time() - baslangic_zamani
    print(f"\n{'='*60}")
    print("✅ VERİ ÇEKME İŞLEMİ TAMAMLANDI")
    print(f"{'='*60}")
    print(f"📊 Toplam veritabanı: {len(veritabanlari)}")
    print(f"📊 Toplam tablo: {toplam_tablo}")
    print(f"📊 Toplam satır: {toplam_satir:,}")
    print(f"⏱️  Geçen süre: {gecen_sure/60:.2f} dakika")
    print(f"💾 Kayıt klasörü: {KAYIT_KLASORU}")
    
    return True

def log_temizle():
    """SQL Server log kayıtlarını temizle"""
    print("\n" + "=" * 60)
    print("🧹 LOG TEMİZLEME İŞLEMİ BAŞLIYOR")
    print("=" * 60)
    
    conn = baglan('master')
    if not conn:
        print("❌ Master veritabanına bağlanılamadı!")
        return False
    
    cursor = conn.cursor()
    
    try:
        # 1. Query Store temizle (eğer aktifse)
        print("\n1. Query Store temizleniyor...")
        try:
            cursor.execute("ALTER DATABASE [master] SET QUERY_STORE CLEAR")
            print("   ✅ Query Store temizlendi")
        except:
            print("   ⚠️  Query Store aktif değil veya temizlenemedi")
        
        # 2. Plan cache temizle
        print("\n2. Plan cache temizleniyor...")
        cursor.execute("DBCC FREEPROCCACHE")
        print("   ✅ Plan cache temizlendi")
        
        # 3. Buffer cache temizle
        print("\n3. Buffer cache temizleniyor...")
        cursor.execute("DBCC DROPCLEANBUFFERS")
        print("   ✅ Buffer cache temizlendi")
        
        # 4. Son sorgu geçmişini kontrol et (silinemez ama bilgi ver)
        print("\n4. Son sorgu geçmişi kontrol ediliyor...")
        cursor.execute("""
            SELECT COUNT(*) 
            FROM sys.dm_exec_query_stats
        """)
        count = cursor.fetchone()[0]
        print(f"   ℹ️  Cache'de {count} sorgu planı var (otomatik temizlenecek)")
        
        # 5. Bağlantı geçmişi (ERRORLOG'dan silinemez ama bilgi ver)
        print("\n5. Log dosyaları kontrol ediliyor...")
        print("   ℹ️  ERRORLOG dosyaları sistem tarafından yönetilir")
        print("   ℹ️  Manuel silme önerilmez")
        
        conn.commit()
        conn.close()
        
        print("\n✅ LOG TEMİZLEME İŞLEMİ TAMAMLANDI")
        print("⚠️  NOT: Bazı loglar sistem tarafından korunur ve silinemez")
        print("⚠️  NOT: ERRORLOG dosyaları manuel silinmemelidir")
        
        return True
        
    except Exception as e:
        print(f"\n❌ Hata: {e}")
        conn.rollback()
        conn.close()
        return False

if __name__ == "__main__":
    print("""
    ⚠️  UYARI: Bu script şunları yapacak:
    1. Tüm veritabanlarından tüm verileri çekecek
    2. PC'nize kaydedecek (D:\\tayfun\\petronet_veriler)
    3. SQL Server log kayıtlarını temizleyecek
    
    Devam etmek istiyor musunuz? (E/H)
    """)
    
    cevap = input(">>> ").strip().upper()
    
    if cevap == 'E':
        # Verileri çek
        if tum_verileri_cek():
            # Log temizle
            print("\n" + "=" * 60)
            onay = input("Log temizleme işlemini başlatmak istiyor musunuz? (E/H): ").strip().upper()
            if onay == 'E':
                log_temizle()
            else:
                print("Log temizleme atlandı.")
    else:
        print("İşlem iptal edildi.")
