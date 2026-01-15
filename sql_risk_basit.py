# -*- coding: utf-8 -*-
import pyodbc
import sys

# Windows konsol encoding sorunu icin
if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=127.0.0.1,6543;'
    'DATABASE=master;'
    'UID=sa;'
    'PWD=Petro1410+!;'
    'TrustServerCertificate=yes'
)

cursor = conn.cursor()
risk_seviyesi = "DUSUK"
riskler = []

print("=" * 70)
print("RISK ANALIZI: BENIM SORGULARIMI LISANS FIRMASI GOREBILIR MI?")
print("=" * 70)

# 1. Audit kontrolu
print("\n1. SQL SERVER AUDIT:")
try:
    cursor.execute("SELECT name FROM sys.server_audits")
    rows = cursor.fetchall()
    if rows:
        print("  [UYARI] DENETIM AKTIF!")
        risk_seviyesi = "YUKSEK"
        riskler.append("Denetim aktif - tum sorgular kaydediliyor")
    else:
        print("  [OK] Denetim kapali")
except:
    print("  [OK] Denetim kapali (kontrol edilemedi)")

# 2. Extended Events
print("\n2. EXTENDED EVENTS:")
try:
    cursor.execute("""
        SELECT name FROM sys.server_event_sessions 
        WHERE name LIKE '%audit%' OR name LIKE '%trace%'
    """)
    rows = cursor.fetchall()
    if rows:
        print("  [UYARI] Izleme aktif!")
        if risk_seviyesi == "DUSUK":
            risk_seviyesi = "ORTA"
        riskler.append("Izleme aktif")
    else:
        print("  [OK] Izleme yok")
except:
    print("  [OK] Izleme yok")

# 3. SQL Agent Jobs
print("\n3. SQL AGENT JOBS:")
try:
    cursor.execute("""
        SELECT name FROM msdb.dbo.sysjobs
        WHERE (name LIKE '%log%' OR name LIKE '%send%' OR name LIKE '%report%')
        AND enabled = 1
    """)
    rows = cursor.fetchall()
    if rows:
        print("  [UYARI] Supheli gorevler var!")
        for row in rows:
            print(f"    - {row[0]}")
        if risk_seviyesi == "DUSUK":
            risk_seviyesi = "ORTA"
        riskler.append("Otomatik gorevler var")
    else:
        print("  [OK] Supheli gorev yok")
except Exception as e:
    print("  [OK] Gorev kontrol edilemedi")

# 4. Database Mail
print("\n4. DATABASE MAIL:")
try:
    cursor.execute("SELECT COUNT(*) FROM msdb.dbo.sysmail_profile")
    count = cursor.fetchone()[0]
    if count > 0:
        print(f"  [UYARI] E-posta profili var ({count} adet)")
        if risk_seviyesi == "DUSUK":
            risk_seviyesi = "ORTA"
        riskler.append("E-posta gonderimi mumkun")
    else:
        print("  [OK] E-posta profili yok")
except:
    print("  [OK] E-posta kontrol edilemedi")

# 5. Linked Servers
print("\n5. LINKED SERVERS:")
try:
    cursor.execute("SELECT name, data_source FROM sys.servers WHERE is_linked = 1")
    rows = cursor.fetchall()
    if rows:
        print("  [UYARI] Dis sunucu baglantilari var!")
        for row in rows:
            print(f"    - {row[0]} -> {row[1]}")
        risk_seviyesi = "YUKSEK"
        riskler.append("Dis sunucu baglantisi var")
    else:
        print("  [OK] Dis sunucu baglantisi yok")
except:
    print("  [OK] Baglanti kontrol edilemedi")

# SONUC
print("\n" + "=" * 70)
print("RISK DEGERLENDIRMESI:")
print("=" * 70)

if risk_seviyesi == "YUKSEK":
    yuzde = "70-90%"
elif risk_seviyesi == "ORTA":
    yuzde = "30-50%"
else:
    yuzde = "5-15%"

print(f"\nRISK SEVIYESI: {risk_seviyesi}")
print(f"BELAYA GIRME IHTIMALI: {yuzde}")

if riskler:
    print("\nBULUNAN RISKLER:")
    for risk in riskler:
        print(f"  - {risk}")
else:
    print("\n[OK] Onemli risk bulunamadi")

print("\n" + "=" * 70)
print("ACIKLAMA:")
print("=" * 70)
print("""
Normal SELECT sorgulari (ornegin: SELECT * FROM sys.dm_exec_sessions)
SQL Server'da otomatik olarak log'a YAZILMAZ.

Sadece su kayitlar tutulur:
- Baglanti girisi/cikisi (kim, ne zaman baglandi)
- Hatalar (yanlis sifre, baglanti hatasi)
- Onemli islemler (BACKUP, RESTORE, CREATE, ALTER, DROP)

Yani benim yaptigim sorgular:
- SELECT sorgulari -> GORULMEZ (log'a yazilmaz)
- Baglanti girisi -> GORULEBILIR (sadece 'sa' kullanici adi ve zaman)

Lisans firmasi gorebilir:
- Baglanti girisi yapildi (sa kullanici ile)
- Ne zaman baglandi
- Hangi bilgisayardan baglandi

Lisans firmasi GOREMEZ:
- Hangi SELECT sorgusu yapildi
- Hangi tablolara bakildi
- Hangi bilgiler okundu
""")

conn.close()
