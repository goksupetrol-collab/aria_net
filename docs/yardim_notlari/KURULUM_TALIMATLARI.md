# SQL SERVER STANDARD KURULUM TALİMATLARI

## ADIM 1: SQL SERVER STANDARD İNDİRME VE KURULUM

### 1.1. İndirme
1. Tarayıcınızı açın
2. Şu adrese gidin: **https://www.microsoft.com/sql-server/sql-server-downloads**
3. **"SQL Server 2022"** bölümüne gidin
4. **"Download now"** veya **"İndir"** butonuna tıklayın
5. **"Standard"** versiyonunu seçin (Evaluation veya lisanslı versiyon)
6. İndirme başlayacak (yaklaşık 1-2 GB)

### 1.2. Kurulum
1. İndirilen dosyayı çalıştırın (örn: `SQLServer2022-SSEI-Dev.exe`)
2. Kurulum türünü seçin: **"Basic"** veya **"Custom"**
   - **Basic**: Hızlı kurulum (önerilen)
   - **Custom**: Özelleştirilebilir kurulum
3. Lisans sözleşmesini kabul edin
4. Kurulum konumunu seçin: **C:\Program Files\Microsoft SQL Server** (değiştirmeyin)
5. **ÖNEMLİ AYARLAR:**
   - **Authentication Mode**: **Mixed Mode (SQL Server authentication and Windows authentication)** seçin
   - **SA Password**: Güçlü bir şifre belirleyin (ÖRNEK: `Tayfun2024!SQL`)
   - **TCP/IP**: Etkinleştirildiğinden emin olun
6. Kurulumu tamamlayın (10-15 dakika sürebilir)
7. Bilgisayarı yeniden başlatın (gerekirse)

### 1.3. Kurulum Kontrolü
Kurulum tamamlandıktan sonra bana haber verin, kontrol edeceğim.

---

## ADIM 2: SQL SERVER MANAGEMENT STUDIO (SSMS) KURULUMU

### 2.1. İndirme
1. Tarayıcınızı açın
2. Şu adrese gidin: **https://aka.ms/ssmsfullsetup**
3. **"Download SQL Server Management Studio (SSMS)"** butonuna tıklayın
4. İndirme başlayacak (yaklaşık 500 MB)

### 2.2. Kurulum
1. İndirilen dosyayı çalıştırın (örn: `SSMS-Setup-ENU.exe`)
2. Kurulum sihirbazını takip edin
3. Kurulum konumunu seçin: **C:\Program Files (x86)\Microsoft SQL Server Management Studio** (değiştirmeyin)
4. Kurulumu tamamlayın (5-10 dakika)
5. SSMS'i başlatın ve test edin

### 2.3. SSMS İlk Bağlantı
1. SSMS'i açın
2. **Server name**: `localhost` veya `.` yazın
3. **Authentication**: **SQL Server Authentication** seçin
4. **Login**: `sa`
5. **Password**: Kurulumda belirlediğiniz şifreyi girin
6. **Connect** butonuna tıklayın
7. Bağlantı başarılı olursa hazırsınız!

---

## ÖNEMLİ NOTLAR

- SQL Server ve SSMS **C:** sürücüsüne kurulacak (sistem gereksinimleri)
- Veritabanı dosyaları **D:\tayfun\database\** klasörüne kaydedilecek
- SA şifresini unutmayın! Güvenli bir yere kaydedin
- Kurulum sırasında internet bağlantısı gerekebilir

---

## SONRAKI ADIMLAR

Kurulum tamamlandıktan sonra:
1. Bana haber verin
2. Ben Django bağlantısını yapılandıracağım
3. Veritabanı modellerini oluşturacağım
4. Dashboard entegrasyonunu yapacağım





