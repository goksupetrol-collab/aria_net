# -*- coding: utf-8 -*-
"""
OZGUR Veritabanı Sistem Kopyalama Scripti
Tüm tablolar, menü yapısı, sayfa bilgileri ve sistem yapılandırması
"""
import pyodbc
import json
import csv
import os
from datetime import datetime

SERVER = '127.0.0.1,6543'
UID = 'sa'
PWD = 'Petro1410+!'
DRIVER = 'ODBC Driver 17 for SQL Server'
DATABASE = 'OZGUR'

# Çıktı klasörü
OUTPUT_DIR = r'D:\tayfun\ozgur_sistem_kopyasi'
os.makedirs(OUTPUT_DIR, exist_ok=True)

def baglan():
    """SQL Server'a bağlan"""
    try:
        conn = pyodbc.connect(
            f'DRIVER={{{DRIVER}}};'
            f'SERVER={SERVER};'
            f'DATABASE={DATABASE};'
            f'UID={UID};'
            f'PWD={PWD};'
            f'TrustServerCertificate=yes'
        )
        return conn
    except Exception as e:
        print(f"HATA: Baglanti hatasi: {e}")
        return None

def tablolari_listele(conn):
    """Tüm tabloları listele"""
    cursor = conn.cursor()
    cursor.execute("""
        SELECT TABLE_SCHEMA, TABLE_NAME
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_TYPE = 'BASE TABLE'
        ORDER BY TABLE_SCHEMA, TABLE_NAME
    """)
    return cursor.fetchall()

def tablo_yapisi_al(conn, schema, tablo):
    """Tablo yapısını al (kolonlar, tipler, vs.)"""
    cursor = conn.cursor()
    cursor.execute(f"""
        SELECT 
            COLUMN_NAME,
            DATA_TYPE,
            CHARACTER_MAXIMUM_LENGTH,
            IS_NULLABLE,
            COLUMN_DEFAULT,
            ORDINAL_POSITION
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ?
        ORDER BY ORDINAL_POSITION
    """, schema, tablo)
    return cursor.fetchall()

def tablo_verilerini_al(conn, schema, tablo):
    """Tablo verilerini al"""
    cursor = conn.cursor()
    try:
        cursor.execute(f"SELECT * FROM [{schema}].[{tablo}]")
        columns = [column[0] for column in cursor.description]
        rows = cursor.fetchall()
        
        # Dict listesine çevir
        veriler = []
        for row in rows:
            veri = {}
            for i, col in enumerate(columns):
                veri[col] = row[i]
            veriler.append(veri)
        
        return veriler, columns
    except Exception as e:
        print(f"   UYARI: {schema}.{tablo} verileri alinamadi: {e}")
        return [], []

def menu_yapisi_al(conn):
    """Menü yapısını al"""
    print("\n" + "=" * 60)
    print("MENU YAPISI ALINIYOR")
    print("=" * 60)
    
    menu_tablolari = []
    menu_verileri = {}
    
    # Olası menü tabloları
    olası_menu_tablolari = [
        'Menu', 'Menuler', 'MenuItems', 'Menu_Items',
        'Sayfa', 'Sayfalar', 'Pages', 'Page',
        'Form', 'Forms', 'Formlar',
        'Modul', 'Moduller', 'Modules'
    ]
    
    cursor = conn.cursor()
    tum_tablolar = tablolari_listele(conn)
    
    for schema, tablo in tum_tablolar:
        tablo_adi = tablo.lower()
        # Menü ile ilgili tabloları bul
        for menu_kelime in olası_menu_tablolari:
            if menu_kelime.lower() in tablo_adi:
                menu_tablolari.append((schema, tablo))
                print(f"   Bulunan menu tablosu: {schema}.{tablo}")
                veriler, kolonlar = tablo_verilerini_al(conn, schema, tablo)
                menu_verileri[f"{schema}.{tablo}"] = {
                    'kolonlar': kolonlar,
                    'veriler': veriler
                }
                break
    
    return menu_verileri

def sayfa_bilgileri_al(conn):
    """Sayfa bilgilerini al"""
    print("\n" + "=" * 60)
    print("SAYFA BILGILERI ALINIYOR")
    print("=" * 60)
    
    sayfa_tablolari = []
    sayfa_verileri = {}
    
    olası_sayfa_tablolari = [
        'Sayfa', 'Sayfalar', 'Pages', 'Page',
        'Form', 'Forms', 'Formlar',
        'Ekran', 'Ekranlar', 'Screens'
    ]
    
    cursor = conn.cursor()
    tum_tablolar = tablolari_listele(conn)
    
    for schema, tablo in tum_tablolar:
        tablo_adi = tablo.lower()
        for sayfa_kelime in olası_sayfa_tablolari:
            if sayfa_kelime.lower() in tablo_adi:
                sayfa_tablolari.append((schema, tablo))
                print(f"   Bulunan sayfa tablosu: {schema}.{tablo}")
                veriler, kolonlar = tablo_verilerini_al(conn, schema, tablo)
                sayfa_verileri[f"{schema}.{tablo}"] = {
                    'kolonlar': kolonlar,
                    'veriler': veriler
                }
                break
    
    return sayfa_verileri

def tum_sistemi_kopyala():
    """Tüm sistemi kopyala"""
    print("=" * 60)
    print("OZGUR VERITABANI SISTEM KOPYALAMA")
    print("=" * 60)
    print(f"Tarih: {datetime.now()}")
    print(f"Hedef: {OUTPUT_DIR}\n")
    
    conn = baglan()
    if not conn:
        return
    
    try:
        # 1. Tüm tabloları listele
        print("1. TABLOLAR LISTELENIYOR...")
        tum_tablolar = tablolari_listele(conn)
        print(f"   Toplam {len(tum_tablolar)} tablo bulundu\n")
        
        # Tablo listesini kaydet
        tablo_listesi = []
        for schema, tablo in tum_tablolar:
            tablo_listesi.append({'schema': schema, 'tablo': tablo})
        
        with open(os.path.join(OUTPUT_DIR, 'tablo_listesi.json'), 'w', encoding='utf-8') as f:
            json.dump(tablo_listesi, f, ensure_ascii=False, indent=2)
        
        # 2. Her tablo için yapı ve verileri al
        print("2. TABLO YAPILARI VE VERILERI ALINIYOR...")
        tablo_yapilari = {}
        tablo_verileri_dosya = {}
        
        for i, (schema, tablo) in enumerate(tum_tablolar, 1):
            print(f"   [{i}/{len(tum_tablolar)}] {schema}.{tablo}...")
            
            # Tablo yapısı
            yapi = tablo_yapisi_al(conn, schema, tablo)
            tablo_yapilari[f"{schema}.{tablo}"] = [
                {
                    'column_name': row[0],
                    'data_type': row[1],
                    'max_length': row[2],
                    'is_nullable': row[3],
                    'default_value': row[4],
                    'ordinal_position': row[5]
                }
                for row in yapi
            ]
            
            # Tablo verileri
            veriler, kolonlar = tablo_verilerini_al(conn, schema, tablo)
            
            # JSON olarak kaydet
            json_dosya = os.path.join(OUTPUT_DIR, 'veriler', f"{schema}_{tablo}.json")
            os.makedirs(os.path.dirname(json_dosya), exist_ok=True)
            with open(json_dosya, 'w', encoding='utf-8') as f:
                json.dump(veriler, f, ensure_ascii=False, indent=2, default=str)
            
            # CSV olarak kaydet
            if veriler:
                csv_dosya = os.path.join(OUTPUT_DIR, 'veriler', f"{schema}_{tablo}.csv")
                with open(csv_dosya, 'w', encoding='utf-8-sig', newline='') as f:
                    writer = csv.DictWriter(f, fieldnames=kolonlar)
                    writer.writeheader()
                    writer.writerows(veriler)
            
            tablo_verileri_dosya[f"{schema}.{tablo}"] = {
                'kayit_sayisi': len(veriler),
                'json_dosya': f"veriler/{schema}_{tablo}.json",
                'csv_dosya': f"veriler/{schema}_{tablo}.csv"
            }
        
        # Tablo yapılarını kaydet
        with open(os.path.join(OUTPUT_DIR, 'tablo_yapilari.json'), 'w', encoding='utf-8') as f:
            json.dump(tablo_yapilari, f, ensure_ascii=False, indent=2)
        
        # 3. Menü yapısını al
        menu_verileri = menu_yapisi_al(conn)
        if menu_verileri:
            with open(os.path.join(OUTPUT_DIR, 'menu_yapisi.json'), 'w', encoding='utf-8') as f:
                json.dump(menu_verileri, f, ensure_ascii=False, indent=2, default=str)
        
        # 4. Sayfa bilgilerini al
        sayfa_verileri = sayfa_bilgileri_al(conn)
        if sayfa_verileri:
            with open(os.path.join(OUTPUT_DIR, 'sayfa_bilgileri.json'), 'w', encoding='utf-8') as f:
                json.dump(sayfa_verileri, f, ensure_ascii=False, indent=2, default=str)
        
        # 5. Özet rapor oluştur
        ozet = {
            'tarih': datetime.now().isoformat(),
            'veritabani': DATABASE,
            'toplam_tablo': len(tum_tablolar),
            'tablo_listesi': tablo_listesi,
            'menu_tablolari': list(menu_verileri.keys()),
            'sayfa_tablolari': list(sayfa_verileri.keys()),
            'kayit_sayilari': tablo_verileri_dosya
        }
        
        with open(os.path.join(OUTPUT_DIR, 'OZET_RAPOR.json'), 'w', encoding='utf-8') as f:
            json.dump(ozet, f, ensure_ascii=False, indent=2)
        
        print("\n" + "=" * 60)
        print("KOPYALAMA TAMAMLANDI")
        print("=" * 60)
        print(f"\nToplam {len(tum_tablolar)} tablo kopyalandi")
        print(f"Klasor: {OUTPUT_DIR}")
        print(f"\nDosyalar:")
        print(f"  - tablo_listesi.json")
        print(f"  - tablo_yapilari.json")
        print(f"  - menu_yapisi.json")
        print(f"  - sayfa_bilgileri.json")
        print(f"  - OZET_RAPOR.json")
        print(f"  - veriler/ klasoru (tum tablo verileri)")
        
    except Exception as e:
        print(f"\nHATA: {e}")
        import traceback
        traceback.print_exc()
    finally:
        conn.close()

if __name__ == "__main__":
    tum_sistemi_kopyala()
    input("\nCikmak icin Enter'a basin...")
