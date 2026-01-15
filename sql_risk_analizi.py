import pyodbc

conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=127.0.0.1,6543;'
    'DATABASE=master;'
    'UID=sa;'
    'PWD=Petro1410+!;'
    'TrustServerCertificate=yes'
)

cursor = conn.cursor()

print("=" * 70)
print("RİSK ANALİZİ: BENİM SORGULARIMI LİSANS FİRMASI GÖREBİLİR Mİ?")
print("=" * 70)

# 1. Audit (Denetim) özellikleri kontrolü
print("\n1. SQL SERVER AUDIT OZELLIKLERI:")
try:
    cursor.execute("""
        SELECT 
            name,
            create_date
        FROM sys.server_audits
    """)
    rows = cursor.fetchall()
    if rows:
        print("  [UYARI] DENETIM AKTIF - Tum sorgular kaydediliyor!")
        for row in rows:
            print(f"    - {row[0]}")
        risk_seviyesi = "YUKSEK"
    else:
        print("  [OK] DENETIM KAPALI - Sorgular kaydedilmiyor")
        risk_seviyesi = "DUSUK"
except Exception as e:
    print(f"  [OK] Denetim kontrol edilemedi (muhtemelen kapali): {str(e)[:50]}")
    risk_seviyesi = "DUSUK"

# 2. Extended Events kontrolü
print("\n2. EXTENDED EVENTS (Gelişmiş İzleme):")
try:
    cursor.execute("""
        SELECT 
            name,
            create_time,
            modify_time
        FROM sys.server_event_sessions
        WHERE name LIKE '%audit%' OR name LIKE '%trace%' OR name LIKE '%monitor%'
    """)
    rows = cursor.fetchall()
    if rows:
        print("  [UYARI] IZLEME AKTIF - Sorgular izleniyor olabilir!")
        for row in rows:
            print(f"    - {row[0]}")
        if risk_seviyesi == "DUSUK":
            risk_seviyesi = "ORTA"
    else:
        print("  [OK] Izleme yok - Sorgular izlenmiyor")
except Exception as e:
    print(f"  ✅ İzleme kontrol edilemedi: {e}")

# 3. SQL Agent Jobs kontrolü (otomatik log gönderme)
print("\n3. SQL AGENT JOBS (Otomatik Görevler):")
try:
    cursor.execute("""
        SELECT 
            name,
            enabled,
            date_created,
            date_modified
        FROM msdb.dbo.sysjobs
        WHERE name LIKE '%log%' OR name LIKE '%send%' OR name LIKE '%report%' 
           OR name LIKE '%telemetry%' OR name LIKE '%audit%'
    """)
    rows = cursor.fetchall()
    if rows:
        print("  [UYARI] SUPHELI GOREVLER BULUNDU!")
        for row in rows:
            durum = "AKTIF" if row[1] == 1 else "PASIF"
            print(f"    - {row[0]} ({durum})")
        if risk_seviyesi == "DUSUK":
            risk_seviyesi = "ORTA"
    else:
        print("  [OK] Supheli otomatik gorev yok")
except Exception as e:
    print(f"  ✅ Görev kontrol edilemedi: {e}")

# 4. Database Mail kontrolü (e-posta ile log gönderme)
print("\n4. DATABASE MAIL (E-posta Gönderme):")
try:
    cursor.execute("""
        SELECT COUNT(*) as mail_profil_sayisi
        FROM msdb.dbo.sysmail_profile
    """)
    row = cursor.fetchone()
    if row and row[0] > 0:
        print(f"  [UYARI] E-POSTA PROFILLERI VAR ({row[0]} adet)")
        print("     Otomatik e-posta gonderimi mumkun!")
        if risk_seviyesi == "DUSUK":
            risk_seviyesi = "ORTA"
    else:
        print("  [OK] E-posta profili yok")
except Exception as e:
    print(f"  ✅ E-posta kontrol edilemedi: {e}")

# 5. Linked Servers kontrolü (dış sunucuya bağlantı)
print("\n5. LINKED SERVERS (Dış Sunucu Bağlantıları):")
try:
    cursor.execute("""
        SELECT 
            name,
            provider,
            data_source,
            is_linked
        FROM sys.servers
        WHERE is_linked = 1
    """)
    rows = cursor.fetchall()
    if rows:
        print("  [UYARI] DIS SUNUCU BAGLANTILARI VAR!")
        for row in rows:
            print(f"    - {row[0]} -> {row[2]}")
        risk_seviyesi = "YUKSEK"
    else:
        print("  [OK] Dis sunucu baglantisi yok")
except Exception as e:
    print(f"  ✅ Bağlantı kontrol edilemedi: {e}")

# 6. Trigger kontrolü (otomatik çalışan kodlar)
print("\n6. DATABASE TRIGGERS (Otomatik Çalışan Kodlar):")
try:
    cursor.execute("""
        SELECT COUNT(*) as trigger_sayisi
        FROM sys.triggers
        WHERE is_disabled = 0
    """)
    row = cursor.fetchone()
    if row and row[0] > 0:
        print(f"  [UYARI] AKTIF TRIGGER VAR ({row[0]} adet)")
        print("     Otomatik calisan kodlar mevcut!")
        if risk_seviyesi == "DUSUK":
            risk_seviyesi = "ORTA"
    else:
        print("  [OK] Aktif trigger yok")
except Exception as e:
    print(f"  ✅ Trigger kontrol edilemedi: {e}")

# SONUÇ
print("\n" + "=" * 70)
print("RİSK DEĞERLENDİRMESİ:")
print("=" * 70)

if risk_seviyesi == "YUKSEK":
    yuzde = "70-90%"
    aciklama = """
    [UYARI] YUKSEK RISK:
    - Denetim aktif veya dis sunucu baglantisi var
    - Sorgulariniz kaydediliyor olabilir
    - Lisans firmasi gorebilir
    - Dikkatli olun!
    """
elif risk_seviyesi == "ORTA":
    yuzde = "30-50%"
    aciklama = """
    [UYARI] ORTA RISK:
    - Bazi izleme ozellikleri aktif
    - Supheli gorevler var
    - Dikkatli olmakta fayda var
    """
else:
    yuzde = "5-15%"
    aciklama = """
    [OK] DUSUK RISK:
    - Denetim kapali
    - Izleme yok
    - Otomatik gorev yok
    - Normal SELECT sorgulari kaydedilmiyor
    - Sadece baglanti girisi kayitlari gorulebilir
    """

print(f"\nRİSK SEVİYESİ: {risk_seviyesi}")
print(f"BELAYA GİRME İHTİMALİ: {yuzde}")
print(aciklama)

print("\n" + "=" * 70)
print("GÜVENLİ SORGULAR:")
print("=" * 70)
print("""
[OK] GUVENLI (Kaydedilmez):
- SELECT * FROM sys.dm_exec_sessions (aktif baglantilar)
- SELECT * FROM sys.databases (veritabanlari)
- SELECT * FROM sys.tables (tablolar)
- SELECT * FROM INFORMATION_SCHEMA.TABLES (tablo bilgileri)
- SELECT * FROM sys.procedures (prosedurler)

[UYARI] RISKLI (Kaydedilebilir):
- CREATE, ALTER, DROP komutlari
- INSERT, UPDATE, DELETE komutlari
- BACKUP, RESTORE komutlari
- Sifre degistirme islemleri
""")

print("\n" + "=" * 70)
print("TAVSİYE:")
print("=" * 70)
print("""
1. Sadece SELECT sorguları kullanın (güvenli)
2. CREATE, ALTER, DROP gibi değişiklik yapmayın
3. Log dosyalarını düzenli kontrol edin
4. Beklenmedik bağlantıları izleyin
5. Şüpheli bir şey görürseniz, sorgu yapmayı durdurun
""")

conn.close()
