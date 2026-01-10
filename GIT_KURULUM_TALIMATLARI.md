# GİT KURULUM TALİMATLARI - ADIM ADIM

## ADIM 1: GİT İNDİRME

### 1.1. İndirme Adresi
**Resmi Site:** https://git-scm.com/download/win

**Direkt İndirme Linki:**
- Windows için: https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe
- (En güncel versiyon için yukarıdaki resmi siteye gidin)

### 1.2. İndirme Adımları
1. Tarayıcınızı açın (Chrome, Edge, Firefox)
2. Şu adrese gidin: **https://git-scm.com/download/win**
3. Sayfa otomatik olarak Windows için indirme başlatır
4. İndirme başlar (yaklaşık 50-60 MB)
5. İndirme tamamlanınca bana haber verin

---

## ADIM 2: GİT KURULUMU

### 2.1. Kurulum Dosyasını Çalıştırma
1. İndirilen dosyayı bulun (genellikle **İndirilenler** klasöründe)
2. Dosya adı: `Git-2.43.0-64-bit.exe` (veya benzer)
3. Dosyaya **çift tıklayın**

### 2.2. Kurulum Sihirbazı - ÖNEMLİ AYARLAR

#### Ekran 1: Lisans Sözleşmesi
- **"Next"** butonuna tıklayın

#### Ekran 2: Kurulum Konumu
- **Varsayılan:** `C:\Program Files\Git`
- **Değiştirmeyin!** → **"Next"**

#### Ekran 3: Bileşenler (Components)
- ✅ **"Git Bash Here"** işaretli olsun
- ✅ **"Git GUI Here"** işaretli olsun
- ✅ **"Associate .git* files with the default editor"** işaretli olsun
- **"Next"**

#### Ekran 4: Varsayılan Düzenleyici (Default Editor)
- **"Use Visual Studio Code as Git's default editor"** seçin
- VEYA **"Nano editor"** seçin (daha basit)
- **"Next"**

#### Ekran 5: PATH Ortam Değişkeni (ÇOK ÖNEMLİ!)
- ✅ **"Git from the command line and also from 3rd-party software"** seçin
- Bu seçenek Git'i her yerden kullanmanızı sağlar
- **"Next"**

#### Ekran 6: HTTPS Aktarımı
- **"Use the OpenSSL library"** seçin (varsayılan)
- **"Next"**

#### Ekran 7: Satır Sonu Dönüşümleri
- ✅ **"Checkout Windows-style, commit Unix-style line endings"** seçin
- **"Next"**

#### Ekran 8: Terminal Emülatörü
- ✅ **"Use Windows' default console window"** seçin
- **"Next"**

#### Ekran 9: Varsayılan Davranış
- ✅ **"Default (fast-forward or merge)"** seçin
- **"Next"**

#### Ekran 10: Ekstra Seçenekler
- ✅ **"Enable file system caching"** işaretli olsun
- ✅ **"Enable Git Credential Manager"** işaretli olsun
- **"Next"**

#### Ekran 11: Deneysel Özellikler
- ❌ Hiçbirini işaretlemeyin (şimdilik)
- **"Install"** butonuna tıklayın

### 2.3. Kurulum Tamamlanıyor
- Kurulum başlar (1-2 dakika)
- İlerleme çubuğu görünür
- **"Finish"** butonuna tıklayın

---

## ADIM 3: KURULUM KONTROLÜ

### 3.1. Git Çalışıyor mu?
1. Yeni bir PowerShell penceresi açın
2. Şu komutu yazın:
   ```
   git --version
   ```
3. Eğer versiyon numarası görünüyorsa → ✅ Kurulum başarılı!

### 3.2. Bana Haber Verin
- Kurulum tamamlandı mı?
- `git --version` komutu çalıştı mı?
- Sonucu bana söyleyin, ben devam edeceğim

---

## ÖNEMLİ NOTLAR

- ✅ Kurulum sırasında **PATH** ayarını doğru seçin (Ekran 5)
- ✅ Varsayılan ayarları değiştirmeyin (gerekmedikçe)
- ✅ Kurulum sonrası bilgisayarı yeniden başlatmanıza gerek yok

---

## SONRAKI ADIMLAR

Kurulum tamamlandıktan sonra:
1. Ben Git'i projenize bağlayacağım
2. İlk kaydı (commit) yapacağım
3. Kullanım talimatlarını vereceğim

