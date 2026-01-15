# -*- coding: utf-8 -*-
"""
OZGUR Veritabanı TAM Kopyalama Scripti
Tablolar, Foreign Key'ler, Stored Procedures, Views, Triggers, Indexes
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

def foreign_key_iliskileri_al(conn):
    """Foreign key ilişkilerini al"""
    print("\n" + "=" * 60)
    print("FOREIGN KEY ILISKILERI ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            fk.name AS FK_Name,
            OBJECT_NAME(fk.parent_object_id) AS Parent_Table,
            COL_NAME(fc.parent_object_id, fc.parent_column_id) AS Parent_Column,
            OBJECT_NAME(fk.referenced_object_id) AS Referenced_Table,
            COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS Referenced_Column,
            fk.delete_referential_action_desc AS Delete_Action,
            fk.update_referential_action_desc AS Update_Action
        FROM sys.foreign_keys AS fk
        INNER JOIN sys.foreign_key_columns AS fc
            ON fk.object_id = fc.constraint_object_id
        ORDER BY Parent_Table, FK_Name
    """)
    
    fk_list = []
    for row in cursor.fetchall():
        fk_list.append({
            'fk_name': row[0],
            'parent_table': row[1],
            'parent_column': row[2],
            'referenced_table': row[3],
            'referenced_column': row[4],
            'delete_action': row[5],
            'update_action': row[6]
        })
    
    print(f"   Toplam {len(fk_list)} foreign key iliskisi bulundu")
    return fk_list

def stored_procedures_al(conn):
    """Stored procedure'ları al"""
    print("\n" + "=" * 60)
    print("STORED PROCEDURES ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            ROUTINE_SCHEMA,
            ROUTINE_NAME,
            ROUTINE_DEFINITION
        FROM INFORMATION_SCHEMA.ROUTINES
        WHERE ROUTINE_TYPE = 'PROCEDURE'
        ORDER BY ROUTINE_SCHEMA, ROUTINE_NAME
    """)
    
    sp_list = []
    for row in cursor.fetchall():
        sp_list.append({
            'schema': row[0],
            'name': row[1],
            'definition': row[2] if row[2] else 'NULL'
        })
    
    print(f"   Toplam {len(sp_list)} stored procedure bulundu")
    return sp_list

def views_al(conn):
    """View'ları al"""
    print("\n" + "=" * 60)
    print("VIEWS ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            TABLE_SCHEMA,
            TABLE_NAME,
            VIEW_DEFINITION
        FROM INFORMATION_SCHEMA.VIEWS
        ORDER BY TABLE_SCHEMA, TABLE_NAME
    """)
    
    view_list = []
    for row in cursor.fetchall():
        view_list.append({
            'schema': row[0],
            'name': row[1],
            'definition': row[2] if row[2] else 'NULL'
        })
    
    print(f"   Toplam {len(view_list)} view bulundu")
    return view_list

def triggers_al(conn):
    """Trigger'ları al"""
    print("\n" + "=" * 60)
    print("TRIGGERS ALINIYOR")
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
        trigger_list.append({
            'schema': row[0],
            'trigger_name': row[1],
            'table_name': row[2],
            'is_disabled': row[3],
            'definition': row[4] if row[4] else 'NULL'
        })
    
    print(f"   Toplam {len(trigger_list)} trigger bulundu")
    return trigger_list

def indexes_al(conn):
    """Index'leri al"""
    print("\n" + "=" * 60)
    print("INDEXES ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            OBJECT_SCHEMA_NAME(i.object_id) AS Schema_Name,
            OBJECT_NAME(i.object_id) AS Table_Name,
            i.name AS Index_Name,
            i.type_desc AS Index_Type,
            i.is_unique,
            i.is_primary_key,
            COL_NAME(ic.object_id, ic.column_id) AS Column_Name,
            ic.key_ordinal AS Key_Ordinal
        FROM sys.indexes i
        INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
        WHERE i.object_id > 0
        ORDER BY Schema_Name, Table_Name, Index_Name, Key_Ordinal
    """)
    
    index_dict = {}
    for row in cursor.fetchall():
        key = f"{row[0]}.{row[1]}.{row[2]}"
        if key not in index_dict:
            index_dict[key] = {
                'schema': row[0],
                'table_name': row[1],
                'index_name': row[2],
                'index_type': row[3],
                'is_unique': row[4],
                'is_primary_key': row[5],
                'columns': []
            }
        index_dict[key]['columns'].append({
            'column_name': row[6],
            'key_ordinal': row[7]
        })
    
    index_list = list(index_dict.values())
    print(f"   Toplam {len(index_list)} index bulundu")
    return index_list

def constraints_al(conn):
    """Constraint'leri al"""
    print("\n" + "=" * 60)
    print("CONSTRAINTS ALINIYOR")
    print("=" * 60)
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            CONSTRAINT_SCHEMA,
            CONSTRAINT_NAME,
            TABLE_NAME,
            CONSTRAINT_TYPE
        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        WHERE CONSTRAINT_TYPE IN ('PRIMARY KEY', 'UNIQUE', 'CHECK')
        ORDER BY TABLE_NAME, CONSTRAINT_TYPE
    """)
    
    constraint_list = []
    for row in cursor.fetchall():
        constraint_list.append({
            'schema': row[0],
            'constraint_name': row[1],
            'table_name': row[2],
            'constraint_type': row[3]
        })
    
    print(f"   Toplam {len(constraint_list)} constraint bulundu")
    return constraint_list

def tum_baglantilari_al():
    """Tüm bağlantıları ve ilişkileri al"""
    print("=" * 60)
    print("OZGUR VERITABANI TAM KOPYALAMA - BAGLANTILAR")
    print("=" * 60)
    print(f"Tarih: {datetime.now()}\n")
    
    conn = baglan()
    if not conn:
        return
    
    try:
        # Foreign Key'ler
        fk_list = foreign_key_iliskileri_al(conn)
        with open(os.path.join(OUTPUT_DIR, 'foreign_keys.json'), 'w', encoding='utf-8') as f:
            json.dump(fk_list, f, ensure_ascii=False, indent=2)
        
        # Stored Procedures
        sp_list = stored_procedures_al(conn)
        with open(os.path.join(OUTPUT_DIR, 'stored_procedures.json'), 'w', encoding='utf-8') as f:
            json.dump(sp_list, f, ensure_ascii=False, indent=2)
        
        # Views
        view_list = views_al(conn)
        with open(os.path.join(OUTPUT_DIR, 'views.json'), 'w', encoding='utf-8') as f:
            json.dump(view_list, f, ensure_ascii=False, indent=2)
        
        # Triggers
        trigger_list = triggers_al(conn)
        with open(os.path.join(OUTPUT_DIR, 'triggers.json'), 'w', encoding='utf-8') as f:
            json.dump(trigger_list, f, ensure_ascii=False, indent=2)
        
        # Indexes
        index_list = indexes_al(conn)
        with open(os.path.join(OUTPUT_DIR, 'indexes.json'), 'w', encoding='utf-8') as f:
            json.dump(index_list, f, ensure_ascii=False, indent=2)
        
        # Constraints
        constraint_list = constraints_al(conn)
        with open(os.path.join(OUTPUT_DIR, 'constraints.json'), 'w', encoding='utf-8') as f:
            json.dump(constraint_list, f, ensure_ascii=False, indent=2)
        
        print("\n" + "=" * 60)
        print("BAGLANTILAR KOPYALANDI")
        print("=" * 60)
        print(f"\nDosyalar:")
        print(f"  - foreign_keys.json ({len(fk_list)} FK)")
        print(f"  - stored_procedures.json ({len(sp_list)} SP)")
        print(f"  - views.json ({len(view_list)} View)")
        print(f"  - triggers.json ({len(trigger_list)} Trigger)")
        print(f"  - indexes.json ({len(index_list)} Index)")
        print(f"  - constraints.json ({len(constraint_list)} Constraint)")
        
    except Exception as e:
        print(f"\nHATA: {e}")
        import traceback
        traceback.print_exc()
    finally:
        conn.close()

if __name__ == "__main__":
    tum_baglantilari_al()
    print("\nTAMAMLANDI!")
