# MANUEL DIŞ PORT KAPATMA REHBERİ

## 1. SQL SERVER MANAGEMENT STUDIO (SSMS) İLE

### Adım 1: SSMS'te Yeni Sorgu Açın
- Bağlı olduğunuz sunucuya sağ tıklayın
- "New Query" seçeneğine tıklayın

### Adım 2: Mevcut Durumu Kontrol Edin
```sql
-- Remote access durumunu kontrol et
EXEC sp_configure 'remote access'
GO

-- Remote login timeout durumunu kontrol et
EXEC sp_configure 'remote login timeout'
GO

-- Server property kontrolü
SELECT SERVERPROPERTY('IsRemoteLoginEnabled') as IsRemoteLoginEnabled
GO
```

### Adım 3: Uzak Girişi Kapatın
```sql
-- Uzak girişi kapat
EXEC sp_configure 'remote access', 0
GO
RECONFIGURE
GO

-- Remote login timeout'u kapat
EXEC sp_configure 'remote login timeout', 0
GO
RECONFIGURE
GO
```

### Adım 4: Değişiklikleri Kontrol Edin
```sql
-- Tekrar kontrol et
SELECT SERVERPROPERTY('IsRemoteLoginEnabled') as IsRemoteLoginEnabled
-- Sonuç: 0 olmalı (kapalı)
GO
```

---

## 2. WINDOWS FIREWALL İLE PORT ENGELLEME

### PowerShell'i Yönetici Olarak Açın
- Windows tuşu → "PowerShell" yazın
- Sağ tıklayın → "Yönetici olarak çalıştır"

### Port 6543'ü Engelle
```powershell
netsh advfirewall firewall add rule name="SQL Server Port 6543 Block" dir=in action=block protocol=TCP localport=6543
```

### Kontrol Et
```powershell
netsh advfirewall firewall show rule name="SQL Server Port 6543 Block"
```

---

## 3. SQL SERVER CONFIGURATION MANAGER İLE (OPSİYONEL)

### Adım 1: Configuration Manager'ı Açın
- Windows tuşu + R → `SQLServerManagerXX.msc` yazın
- (XX = SQL Server versiyonunuz, örn: 17, 18, 19)

### Adım 2: TCP/IP Ayarlarını Kontrol Edin
- SQL Server Network Configuration → Protocols → TCP/IP
- TCP/IP'ye sağ tıklayın → Properties

### Adım 3: IP Addresses Sekmesi
- IPAll bölümüne gidin
- TCP Dynamic Ports: Boş bırakın veya silin
- TCP Port: 6543 (iç kullanım için kalabilir)

### Adım 4: SQL Server Servisini Yeniden Başlatın
- SQL Server Services → SQL Server (MSSQLSERVER)
- Sağ tıklayın → Restart

---

## ÖNEMLİ NOTLAR

✅ **İç Port Açık Kalacak:**
- 127.0.0.1 (localhost) üzerinden bağlantı çalışmaya devam edecek
- Petronet programı normal çalışacak

❌ **Dış Port Kapatılacak:**
- Uzak bilgisayarlardan bağlantı engellenecek
- Sadece kendi bilgisayarınızdan erişim mümkün olacak

⚠️ **SQL Server Yeniden Başlatma:**
- sp_configure değişiklikleri için SQL Server'ı yeniden başlatmanız gerekebilir
- Configuration Manager değişiklikleri için mutlaka yeniden başlatma gerekir

---

## KONTROL KOMUTLARI

### SQL Server Durumu
```sql
-- Remote access kontrolü
EXEC sp_configure 'remote access'
GO

-- IsRemoteLoginEnabled kontrolü
SELECT SERVERPROPERTY('IsRemoteLoginEnabled') as IsRemoteLoginEnabled
GO
```

### Firewall Durumu
```powershell
netsh advfirewall firewall show rule name="SQL Server Port 6543 Block"
```

### Port Dinleme Durumu
```powershell
netstat -an | findstr 6543
```
