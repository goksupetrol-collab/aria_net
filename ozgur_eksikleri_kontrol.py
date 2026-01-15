# -*- coding: utf-8 -*-
"""
OZGUR Veritabanı EKSİKLERİ Kontrol ve Alma Scripti
User Types, Sequences, Synonyms, Rules, Defaults, Permissions, Extended Properties
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

def user_types_al(conn):
    """User-defined types al"""
    print("\n" + "=" * 60)
    print("USER-DEFINED TYPES ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            SCHEMA_NAME(schema_id) AS Schema_Name,
            name AS Type_Name,
            type_name(user_type_id) AS System_Type,
            max_length,
            precision,
            scale,
            is_nullable
        FROM sys.types
        WHERE is_user_defined = 1
        ORDER BY Schema_Name, Type_Name
    """)
    
    type_list = []
    for row in cursor.fetchall():
        type_list.append({
            'schema': row[0],
            'name': row[1],
            'system_type': row[2],
            'max_length': row[3],
            'precision': row[4],
            'scale': row[5],
            'is_nullable': row[6]
        })
    
    print(f"   Toplam {len(type_list)} user-defined type bulundu")
    return type_list

def sequences_al(conn):
    """Sequences al"""
    print("\n" + "=" * 60)
    print("SEQUENCES ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    try:
        cursor.execute("""
            SELECT 
                SCHEMA_NAME(schema_id) AS Schema_Name,
                name AS Sequence_Name,
                start_value,
                increment,
                minimum_value,
                maximum_value,
                current_value,
                is_cycling
            FROM sys.sequences
            ORDER BY Schema_Name, Sequence_Name
        """)
        
        seq_list = []
        for row in cursor.fetchall():
            seq_list.append({
                'schema': row[0],
                'name': row[1],
                'start_value': row[2],
                'increment': row[3],
                'minimum_value': row[4],
                'maximum_value': row[5],
                'current_value': row[6],
                'is_cycling': row[7]
            })
        
        print(f"   Toplam {len(seq_list)} sequence bulundu")
        return seq_list
    except Exception as e:
        print(f"   UYARI: Sequences kontrol edilemedi: {e}")
        return []

def synonyms_al(conn):
    """Synonyms al"""
    print("\n" + "=" * 60)
    print("SYNONYMS ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            SCHEMA_NAME(schema_id) AS Schema_Name,
            name AS Synonym_Name,
            base_object_name
        FROM sys.synonyms
        ORDER BY Schema_Name, Synonym_Name
    """)
    
    syn_list = []
    for row in cursor.fetchall():
        syn_list.append({
            'schema': row[0],
            'name': row[1],
            'base_object_name': row[2]
        })
    
    print(f"   Toplam {len(syn_list)} synonym bulundu")
    return syn_list

def permissions_al(conn):
    """Permissions (izinler) al"""
    print("\n" + "=" * 60)
    print("PERMISSIONS ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            pr.name AS Principal_Name,
            pr.type_desc AS Principal_Type,
            pe.permission_name,
            pe.state_desc AS Permission_State,
            OBJECT_SCHEMA_NAME(pe.major_id) AS Object_Schema,
            OBJECT_NAME(pe.major_id) AS Object_Name,
            pe.minor_id
        FROM sys.database_permissions pe
        INNER JOIN sys.database_principals pr ON pe.grantee_principal_id = pr.principal_id
        WHERE pe.major_id > 0
        ORDER BY Object_Schema, Object_Name, Principal_Name
    """)
    
    perm_list = []
    for row in cursor.fetchall():
        perm_list.append({
            'principal_name': row[0],
            'principal_type': row[1],
            'permission_name': row[2],
            'permission_state': row[3],
            'object_schema': row[4],
            'object_name': row[5],
            'minor_id': row[6]
        })
    
    print(f"   Toplam {len(perm_list)} permission bulundu")
    return perm_list

def extended_properties_al(conn):
    """Extended properties (açıklamalar) al"""
    print("\n" + "=" * 60)
    print("EXTENDED PROPERTIES ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            ep.name AS Property_Name,
            ep.value AS Property_Value,
            SCHEMA_NAME(o.schema_id) AS Schema_Name,
            o.name AS Object_Name,
            o.type_desc AS Object_Type,
            ep.minor_id,
            CASE 
                WHEN ep.minor_id = 0 THEN NULL
                ELSE COL_NAME(ep.major_id, ep.minor_id)
            END AS Column_Name
        FROM sys.extended_properties ep
        LEFT JOIN sys.objects o ON ep.major_id = o.object_id
        WHERE ep.class = 1
        ORDER BY Schema_Name, Object_Name, Property_Name
    """)
    
    prop_list = []
    for row in cursor.fetchall():
        prop_list.append({
            'property_name': row[0],
            'property_value': row[1],
            'schema_name': row[2],
            'object_name': row[3],
            'object_type': row[4],
            'minor_id': row[5],
            'column_name': row[6]
        })
    
    print(f"   Toplam {len(prop_list)} extended property bulundu")
    return prop_list

def database_settings_al(conn):
    """Database ayarları al"""
    print("\n" + "=" * 60)
    print("DATABASE AYARLARI ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    settings = {}
    
    # Database properties
    properties = [
        'Collation', 'IsAutoClose', 'IsAutoShrink', 'IsFullTextEnabled',
        'IsReadOnly', 'Recovery', 'UserAccess', 'Version'
    ]
    
    for prop in properties:
        try:
            cursor.execute(f"SELECT SERVERPROPERTY('{prop}')")
            row = cursor.fetchone()
            if row:
                settings[prop] = row[0]
        except:
            pass
    
    # Database options
    try:
        cursor.execute("""
            SELECT 
                name,
                value,
                value_in_use
            FROM sys.database_scoped_configurations
        """)
        db_options = []
        for row in cursor.fetchall():
            db_options.append({
                'name': row[0],
                'value': row[1],
                'value_in_use': row[2]
            })
        settings['database_scoped_configurations'] = db_options
    except:
        pass
    
    print(f"   Database ayarlari alindi")
    return settings

def tum_eksikleri_al():
    """Tüm eksikleri al"""
    print("=" * 60)
    print("OZGUR VERITABANI EKSIKLERI KONTROL VE ALMA")
    print("=" * 60)
    print(f"Tarih: {datetime.now()}\n")
    
    conn = baglan()
    if not conn:
        return
    
    try:
        # User Types
        type_list = user_types_al(conn)
        if type_list:
            with open(os.path.join(OUTPUT_DIR, 'user_types.json'), 'w', encoding='utf-8') as f:
                json.dump(type_list, f, ensure_ascii=False, indent=2)
        
        # Sequences
        seq_list = sequences_al(conn)
        if seq_list:
            with open(os.path.join(OUTPUT_DIR, 'sequences.json'), 'w', encoding='utf-8') as f:
                json.dump(seq_list, f, ensure_ascii=False, indent=2)
        
        # Synonyms
        syn_list = synonyms_al(conn)
        if syn_list:
            with open(os.path.join(OUTPUT_DIR, 'synonyms.json'), 'w', encoding='utf-8') as f:
                json.dump(syn_list, f, ensure_ascii=False, indent=2)
        
        # Permissions
        perm_list = permissions_al(conn)
        if perm_list:
            with open(os.path.join(OUTPUT_DIR, 'permissions.json'), 'w', encoding='utf-8') as f:
                json.dump(perm_list, f, ensure_ascii=False, indent=2)
        
        # Extended Properties
        prop_list = extended_properties_al(conn)
        if prop_list:
            with open(os.path.join(OUTPUT_DIR, 'extended_properties.json'), 'w', encoding='utf-8') as f:
                json.dump(prop_list, f, ensure_ascii=False, indent=2)
        
        # Database Settings
        db_settings = database_settings_al(conn)
        if db_settings:
            with open(os.path.join(OUTPUT_DIR, 'database_settings.json'), 'w', encoding='utf-8') as f:
                json.dump(db_settings, f, ensure_ascii=False, indent=2)
        
        # Özet
        ozet = {
            'tarih': datetime.now().isoformat(),
            'user_types': len(type_list),
            'sequences': len(seq_list),
            'synonyms': len(syn_list),
            'permissions': len(perm_list),
            'extended_properties': len(prop_list),
            'database_settings': len(db_settings) if db_settings else 0
        }
        
        with open(os.path.join(OUTPUT_DIR, 'EKSIKLER_OZET.json'), 'w', encoding='utf-8') as f:
            json.dump(ozet, f, ensure_ascii=False, indent=2)
        
        print("\n" + "=" * 60)
        print("EKSIKLER KOPYALANDI")
        print("=" * 60)
        print(f"\nDosyalar:")
        if type_list:
            print(f"  - user_types.json ({len(type_list)} type)")
        if seq_list:
            print(f"  - sequences.json ({len(seq_list)} sequence)")
        if syn_list:
            print(f"  - synonyms.json ({len(syn_list)} synonym)")
        if perm_list:
            print(f"  - permissions.json ({len(perm_list)} permission)")
        if prop_list:
            print(f"  - extended_properties.json ({len(prop_list)} property)")
        if db_settings:
            print(f"  - database_settings.json")
        print(f"  - EKSIKLER_OZET.json")
        
    except Exception as e:
        print(f"\nHATA: {e}")
        import traceback
        traceback.print_exc()
    finally:
        conn.close()

if __name__ == "__main__":
    tum_eksikleri_al()
    print("\nTAMAMLANDI!")
