# MANUEL ADIM ADIM DIŞ PORT KAPATMA (KOD YAZMADAN)

## YÖNTEM 1: SQL SERVER CONFIGURATION MANAGER İLE

### ADIM 1: SQL Server Configuration Manager'ı Açın

1. **Windows tuşu + R** tuşlarına basın
2. Açılan pencerede şunu yazın: `SQLServerManager10.msc` (SQL Server 2008 için)
   - Eğer çalışmazsa: `SQLServerManager11.msc` (SQL Server 2012)
   - Veya: `SQLServerManager12.msc` (SQL Server 2014)
   - Veya: `SQLServerManager13.msc` (SQL Server 2016)
3. **Enter** tuşuna basın

**VEYA:**

1. **Başlat menüsüne** tıklayın
2. **"SQL Server Configuration Manager"** yazın
3. Programı açın

---

### ADIM 2: SQL Server Network Configuration'a Gidin

1. Sol tarafta **"SQL Server Network Configuration"** klasörünü genişletin (tıklayın)
2. Altında **"Protocols for MSSQLSERVER"** (veya SQL Server instance adınız) seçeneğini görün
3. **"Protocols for MSSQLSERVER"** üzerine tıklayın

---

### ADIM 3: TCP/IP Protokolünü Bulun

1. Sağ tarafta protokol listesi görünecek:
   - Named Pipes
   - Shared Memory
   - TCP/IP
   - VIA (varsa)
2. **"TCP/IP"** satırını bulun
3. Durumuna bakın:
   - **Enabled** (Aktif) ise → Devam edin
   - **Disabled** (Pasif) ise → Sağ tıklayın → **"Enable"** seçin

---

### ADIM 4: TCP/IP Properties'i Açın

1. **"TCP/IP"** üzerine **sağ tıklayın**
2. Açılan menüden **"Properties"** seçeneğine tıklayın
3. Bir pencere açılacak

---

### ADIM 5: IP Addresses Sekmesine Gidin

1. Açılan pencerede üstte sekmeler var:
   - **Protocol**
   - **IP Addresses**
   - **IPAll**
2. **"IP Addresses"** sekmesine tıklayın

---

### ADIM 6: IP Adreslerini Kontrol Edin

1. Aşağı kaydırın ve şunları göreceksiniz:
   - **IP1**
   - **IP2**
   - **IP3**
   - ...
   - **IPAll** (en altta)

2. **Her bir IP için:**
   - **"Active"** → **"No"** yapın (dış bağlantılar için)
   - **"Enabled"** → **"No"** yapın

3. **ÖNEMLİ:** **"IPAll"** bölümüne gidin:
   - **"TCP Dynamic Ports"** → **Boş bırakın** veya **silin**
   - **"TCP Port"** → **6543** (iç kullanım için kalabilir)

---

### ADIM 7: Sadece Localhost (127.0.0.1) İçin Açık Bırakın

1. **"IPAll"** bölümünde:
   - **"TCP Port"** → **6543** yazın (iç kullanım için)
   - **"TCP Dynamic Ports"** → **Boş bırakın**

2. **"OK"** butonuna tıklayın

3. Bir uyarı mesajı çıkacak: **"SQL Server servisini yeniden başlatmanız gerekiyor"**
   - **"OK"** deyin

---

### ADIM 8: SQL Server Servisini Yeniden Başlatın

1. Sol tarafta **"SQL Server Services"** klasörüne gidin
2. **"SQL Server (MSSQLSERVER)"** (veya instance adınız) üzerine **sağ tıklayın**
3. **"Restart"** seçeneğine tıklayın
4. Servis yeniden başlayacak (birkaç saniye sürebilir)

---

## YÖNTEM 2: WINDOWS FIREWALL İLE (EK GÜVENLİK)

### ADIM 1: PowerShell'i Yönetici Olarak Açın

1. **Windows tuşu** → **"PowerShell"** yazın
2. **"Windows PowerShell"** üzerine **sağ tıklayın**
3. **"Yönetici olarak çalıştır"** seçeneğine tıklayın
4. **"Evet"** deyin (UAC uyarısı)

---

### ADIM 2: Port 6543'ü Engelle

1. PowerShell penceresine şu komutu yazın:
   ```
   netsh advfirewall firewall add rule name="SQL Server Port 6543 Block" dir=in action=block protocol=TCP localport=6543
   ```

2. **Enter** tuşuna basın

3. **"Ok."** mesajı görünmeli

---

### ADIM 3: Kontrol Edin

1. Şu komutu yazın:
   ```
   netsh advfirewall firewall show rule name="SQL Server Port 6543 Block"
   ```

2. Kuralın eklendiğini görmelisiniz

---

## KONTROL ADIMLARI

### 1. SQL Server Bağlantısını Test Edin

1. **SSMS'te** yeni bir bağlantı açmayı deneyin:
   - **127.0.0.1,6543** → **Bağlanmalı** ✅
   - **Bilgisayar IP'si,6543** → **Bağlanmamalı** ❌

### 2. Port Dinleme Durumunu Kontrol Edin

1. PowerShell'de şu komutu çalıştırın:
   ```
   netstat -an | findstr 6543
   ```

2. Sadece **127.0.0.1:6543** görünmeli (localhost)
3. **0.0.0.0:6543** görünmemeli (tüm IP'ler)

---

## ÖNEMLİ NOTLAR

✅ **İç Port Açık Kalacak:**
- **127.0.0.1** (localhost) üzerinden bağlantı çalışacak
- Petronet programı normal çalışacak

❌ **Dış Port Kapatılacak:**
- Uzak bilgisayarlardan bağlantı engellenecek
- Sadece kendi bilgisayarınızdan erişim mümkün olacak

⚠️ **SQL Server Yeniden Başlatma:**
- Configuration Manager değişiklikleri için **mutlaka** SQL Server servisini yeniden başlatmanız gerekir
- Yeniden başlatma sırasında aktif bağlantılar kesilebilir

---

## SORUN GİDERME

### Problem: Configuration Manager açılmıyor
**Çözüm:** 
- Windows tuşu + R → `mmc` yazın → Enter
- File → Add/Remove Snap-in → SQL Server Configuration Manager ekleyin

### Problem: TCP/IP görünmüyor
**Çözüm:**
- SQL Server Express kullanıyorsanız, bazı özellikler sınırlı olabilir
- Firewall yöntemini kullanın

### Problem: Servis yeniden başlamıyor
**Çözüm:**
- Services.msc'yi açın
- SQL Server (MSSQLSERVER) servisini bulun
- Sağ tıklayın → Restart
