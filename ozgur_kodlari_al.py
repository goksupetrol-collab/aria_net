# -*- coding: utf-8 -*-
"""
OZGUR Veritabanı KODLARI Alma Scripti
Stored Procedures, Views, Functions - Tam Kodları
"""
import pyodbc
import json
import os
from datetime import datetime

SERVER = '127.0.0.1,6543'
UID = 'sa'
PWD = 'Petro1410+!'
DRIVER = 'ODBC Driver 17 for SQL Server'
DATABASE = 'OZGUR'

OUTPUT_DIR = r'D:\tayfun\ozgur_sistem_kopyasi'
os.makedirs(OUTPUT_DIR, exist_ok=True)
os.makedirs(os.path.join(OUTPUT_DIR, 'kodlar'), exist_ok=True)

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

def stored_procedure_kodlari_al(conn):
    """Stored procedure kodlarını al"""
    print("\n" + "=" * 60)
    print("STORED PROCEDURE KODLARI ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            OBJECT_SCHEMA_NAME(o.object_id) AS Schema_Name,
            o.name AS Procedure_Name,
            OBJECT_DEFINITION(o.object_id) AS Definition
        FROM sys.objects o
        WHERE o.type = 'P'
        ORDER BY Schema_Name, Procedure_Name
    """)
    
    sp_list = []
    for row in cursor.fetchall():
        schema = row[0]
        name = row[1]
        definition = row[2] if row[2] else '-- Kod bulunamadi'
        
        sp_list.append({
            'schema': schema,
            'name': name,
            'full_name': f"{schema}.{name}",
            'definition': definition
        })
        
        # Ayrı dosya olarak kaydet
        dosya_yolu = os.path.join(OUTPUT_DIR, 'kodlar', f"SP_{schema}_{name}.sql")
        with open(dosya_yolu, 'w', encoding='utf-8') as f:
            f.write(f"-- Stored Procedure: {schema}.{name}\n")
            f.write(f"-- Tarih: {datetime.now()}\n")
            f.write("=" * 80 + "\n\n")
            f.write(definition)
            f.write("\n\n" + "=" * 80 + "\n")
        
        print(f"   [{len(sp_list)}] {schema}.{name}")
    
    print(f"\n   Toplam {len(sp_list)} stored procedure kodu alindi")
    return sp_list

def view_kodlari_al(conn):
    """View kodlarını al"""
    print("\n" + "=" * 60)
    print("VIEW KODLARI ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            OBJECT_SCHEMA_NAME(o.object_id) AS Schema_Name,
            o.name AS View_Name,
            OBJECT_DEFINITION(o.object_id) AS Definition
        FROM sys.objects o
        WHERE o.type = 'V'
        ORDER BY Schema_Name, View_Name
    """)
    
    view_list = []
    for row in cursor.fetchall():
        schema = row[0]
        name = row[1]
        definition = row[2] if row[2] else '-- Kod bulunamadi'
        
        view_list.append({
            'schema': schema,
            'name': name,
            'full_name': f"{schema}.{name}",
            'definition': definition
        })
        
        # Ayrı dosya olarak kaydet
        dosya_yolu = os.path.join(OUTPUT_DIR, 'kodlar', f"VIEW_{schema}_{name}.sql")
        with open(dosya_yolu, 'w', encoding='utf-8') as f:
            f.write(f"-- View: {schema}.{name}\n")
            f.write(f"-- Tarih: {datetime.now()}\n")
            f.write("=" * 80 + "\n\n")
            f.write(f"CREATE VIEW [{schema}].[{name}] AS\n")
            f.write(definition)
            f.write("\n\n" + "=" * 80 + "\n")
        
        print(f"   [{len(view_list)}] {schema}.{name}")
    
    print(f"\n   Toplam {len(view_list)} view kodu alindi")
    return view_list

def function_kodlari_al(conn):
    """Function kodlarını al"""
    print("\n" + "=" * 60)
    print("FUNCTION KODLARI ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            OBJECT_SCHEMA_NAME(o.object_id) AS Schema_Name,
            o.name AS Function_Name,
            o.type_desc AS Function_Type,
            OBJECT_DEFINITION(o.object_id) AS Definition
        FROM sys.objects o
        WHERE o.type IN ('FN', 'IF', 'TF', 'FS', 'FT')
        ORDER BY Schema_Name, Function_Name
    """)
    
    func_list = []
    for row in cursor.fetchall():
        schema = row[0]
        name = row[1]
        func_type = row[2]
        definition = row[3] if row[3] else '-- Kod bulunamadi'
        
        func_list.append({
            'schema': schema,
            'name': name,
            'type': func_type,
            'full_name': f"{schema}.{name}",
            'definition': definition
        })
        
        # Ayrı dosya olarak kaydet
        dosya_yolu = os.path.join(OUTPUT_DIR, 'kodlar', f"FUNC_{schema}_{name}.sql")
        with open(dosya_yolu, 'w', encoding='utf-8') as f:
            f.write(f"-- Function: {schema}.{name}\n")
            f.write(f"-- Tip: {func_type}\n")
            f.write(f"-- Tarih: {datetime.now()}\n")
            f.write("=" * 80 + "\n\n")
            f.write(definition)
            f.write("\n\n" + "=" * 80 + "\n")
        
        print(f"   [{len(func_list)}] {schema}.{name} ({func_type})")
    
    print(f"\n   Toplam {len(func_list)} function kodu alindi")
    return func_list

def trigger_kodlari_al(conn):
    """Trigger kodlarını al"""
    print("\n" + "=" * 60)
    print("TRIGGER KODLARI ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            OBJECT_SCHEMA_NAME(t.object_id) AS Schema_Name,
            OBJECT_NAME(t.object_id) AS Trigger_Name,
            OBJECT_NAME(t.parent_id) AS Table_Name,
            t.is_disabled,
            OBJECT_DEFINITION(t.object_id) AS Definition
        FROM sys.triggers t
        WHERE t.parent_id > 0
        ORDER BY Schema_Name, Table_Name, Trigger_Name
    """)
    
    trigger_list = []
    for row in cursor.fetchall():
        schema = row[0]
        trigger_name = row[1]
        table_name = row[2]
        is_disabled = row[3]
        definition = row[4] if row[4] else '-- Kod bulunamadi'
        
        trigger_list.append({
            'schema': schema,
            'trigger_name': trigger_name,
            'table_name': table_name,
            'is_disabled': is_disabled,
            'full_name': f"{schema}.{trigger_name}",
            'definition': definition
        })
        
        # Ayrı dosya olarak kaydet
        dosya_yolu = os.path.join(OUTPUT_DIR, 'kodlar', f"TRIGGER_{schema}_{table_name}_{trigger_name}.sql")
        with open(dosya_yolu, 'w', encoding='utf-8') as f:
            f.write(f"-- Trigger: {schema}.{trigger_name}\n")
            f.write(f"-- Tablo: {schema}.{table_name}\n")
            f.write(f"-- Disabled: {is_disabled}\n")
            f.write(f"-- Tarih: {datetime.now()}\n")
            f.write("=" * 80 + "\n\n")
            f.write(definition)
            f.write("\n\n" + "=" * 80 + "\n")
        
        print(f"   [{len(trigger_list)}] {schema}.{trigger_name} (Tablo: {table_name})")
    
    print(f"\n   Toplam {len(trigger_list)} trigger kodu alindi")
    return trigger_list

def tum_kodlari_al():
    """Tüm kodları al"""
    print("=" * 60)
    print("OZGUR VERITABANI KODLARI ALINIYOR")
    print("=" * 60)
    print(f"Tarih: {datetime.now()}\n")
    
    conn = baglan()
    if not conn:
        return
    
    try:
        # Stored Procedures
        sp_list = stored_procedure_kodlari_al(conn)
        with open(os.path.join(OUTPUT_DIR, 'kodlar', 'TUM_STORED_PROCEDURES.json'), 'w', encoding='utf-8') as f:
            json.dump(sp_list, f, ensure_ascii=False, indent=2)
        
        # Views
        view_list = view_kodlari_al(conn)
        with open(os.path.join(OUTPUT_DIR, 'kodlar', 'TUM_VIEWS.json'), 'w', encoding='utf-8') as f:
            json.dump(view_list, f, ensure_ascii=False, indent=2)
        
        # Functions
        func_list = function_kodlari_al(conn)
        if func_list:
            with open(os.path.join(OUTPUT_DIR, 'kodlar', 'TUM_FUNCTIONS.json'), 'w', encoding='utf-8') as f:
                json.dump(func_list, f, ensure_ascii=False, indent=2)
        
        # Triggers
        trigger_list = trigger_kodlari_al(conn)
        with open(os.path.join(OUTPUT_DIR, 'kodlar', 'TUM_TRIGGERS.json'), 'w', encoding='utf-8') as f:
            json.dump(trigger_list, f, ensure_ascii=False, indent=2)
        
        # Özet
        ozet = {
            'tarih': datetime.now().isoformat(),
            'stored_procedures': len(sp_list),
            'views': len(view_list),
            'functions': len(func_list),
            'triggers': len(trigger_list),
            'toplam_kod': len(sp_list) + len(view_list) + len(func_list) + len(trigger_list)
        }
        
        with open(os.path.join(OUTPUT_DIR, 'kodlar', 'KOD_OZET.json'), 'w', encoding='utf-8') as f:
            json.dump(ozet, f, ensure_ascii=False, indent=2)
        
        print("\n" + "=" * 60)
        print("KODLAR KOPYALANDI")
        print("=" * 60)
        print(f"\nDosyalar:")
        print(f"  - kodlar/ klasoru:")
        print(f"    - {len(sp_list)} Stored Procedure (.sql dosyalari)")
        print(f"    - {len(view_list)} View (.sql dosyalari)")
        print(f"    - {len(func_list)} Function (.sql dosyalari)")
        print(f"    - {len(trigger_list)} Trigger (.sql dosyalari)")
        print(f"    - TUM_STORED_PROCEDURES.json")
        print(f"    - TUM_VIEWS.json")
        print(f"    - TUM_FUNCTIONS.json")
        print(f"    - TUM_TRIGGERS.json")
        print(f"    - KOD_OZET.json")
        print(f"\nToplam {ozet['toplam_kod']} kod nesnesi kopyalandi")
        
    except Exception as e:
        print(f"\nHATA: {e}")
        import traceback
        traceback.print_exc()
    finally:
        conn.close()

if __name__ == "__main__":
    tum_kodlari_al()
    print("\nTAMAMLANDI!")
