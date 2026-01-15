# DIŞ PORT KAPATMA - SON ADIMLAR

## DURUM ANALİZİ

✅ **İç Bağlantı:** Çalışıyor (127.0.0.1:6543)
❌ **Dış Port:** Hala açık (0.0.0.0:6543 - Tüm IP'lerden dinleniyor)
❌ **Firewall:** Engelleme kuralı yok

---

## ÇÖZÜM: SQL SERVER CONFIGURATION MANAGER

### ADIM 1: Configuration Manager'ı Açın

1. **Windows tuşu + R**
2. Şunu yazın: `SQLServerManager10.msc` (veya versiyonunuza göre)
3. **Enter**

---

### ADIM 2: TCP/IP Properties'i Açın

1. Sol tarafta: **SQL Server Network Configuration** → **Protocols for MSSQLSERVER**
2. Sağ tarafta: **TCP/IP** üzerine **sağ tıklayın**
3. **Properties** seçin

---

### ADIM 3: IP Addresses Sekmesi

1. **IP Addresses** sekmesine gidin
2. **Aşağı kaydırın** ve şunları bulun:
   - **IP1** (genelde 127.0.0.1)
   - **IP2, IP3, IP4...** (diğer IP'ler)
   - **IPAll** (en altta - ÖNEMLİ!)

---

### ADIM 4: IPAll Bölümünü Düzenleyin

**IPAll** bölümünde:

1. **TCP Dynamic Ports** → **SİLİN** veya **BOŞ BIRAKIN**
2. **TCP Port** → **6543** yazın (iç kullanım için)

**ÖNEMLİ:** IPAll'da sadece TCP Port olmalı, TCP Dynamic Ports boş olmalı!

---

### ADIM 5: Diğer IP'leri Kapatın (Opsiyonel ama Önerilen)

**IP1, IP2, IP3...** için (127.0.0.1 hariç):

1. Her IP için:
   - **Active** → **No**
   - **Enabled** → **No**

**NOT:** IP1 (127.0.0.1) için **Active: Yes** ve **Enabled: Yes** kalmalı!

---

### ADIM 6: OK ve SQL Server'ı Yeniden Başlatın

1. **OK** butonuna tıklayın
2. Uyarı mesajı çıkacak → **OK** deyin
3. Sol tarafta: **SQL Server Services** → **SQL Server (MSSQLSERVER)**
4. **Sağ tıklayın** → **Restart**

---

## FIREWALL ENGELLEME (EK GÜVENLİK)

### PowerShell'i Yönetici Olarak Açın

1. **Windows tuşu** → **PowerShell** yazın
2. **Sağ tıklayın** → **Yönetici olarak çalıştır**

### Port 6543'ü Engelle

```powershell
netsh advfirewall firewall add rule name="SQL Server Port 6543 Block" dir=in action=block protocol=TCP localport=6543
```

---

## KONTROL

### 1. Port Dinleme Kontrolü

PowerShell'de:
```powershell
netstat -an | findstr 6543
```

**İstenen Sonuç:**
- ✅ `TCP    127.0.0.1:6543` görünmeli
- ❌ `TCP    0.0.0.0:6543` görünmemeli

### 2. Firewall Kontrolü

```powershell
netsh advfirewall firewall show rule name="SQL Server Port 6543 Block"
```

**İstenen Sonuç:** Kural görünmeli

---

## ÖNEMLİ NOTLAR

⚠️ **SQL Server Yeniden Başlatma Zorunlu:**
- Configuration Manager değişiklikleri için SQL Server'ı **mutlaka** yeniden başlatın
- Yeniden başlatma sırasında aktif bağlantılar kesilebilir

✅ **İç Port Açık Kalacak:**
- 127.0.0.1 üzerinden bağlantı çalışmaya devam edecek
- Petronet programı normal çalışacak

❌ **Dış Port Kapatılacak:**
- Uzak bilgisayarlardan bağlantı engellenecek
- Sadece kendi bilgisayarınızdan erişim mümkün olacak
