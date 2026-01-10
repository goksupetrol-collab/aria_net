# DOSYA GERİ YÜKLEME SORUNU ÇÖZÜMÜ

## ADIM 1: WINDOWS FILE HISTORY KONTROLÜ

### 1.1. Windows Ayarlarını Açma
1. **Windows tuşu** (klavyede Windows logosu olan tuş) + **I** tuşuna birlikte basın
   - VEYA
   - Başlat menüsüne tıklayın → "Ayarlar" yazın → Enter

### 1.2. File History'yi Bulma
1. Arama kutusuna **"File History"** yazın
2. **"File History ile dosyalarınızı geri yükleme"** seçeneğine tıklayın

### 1.3. File History Kontrolü
1. Eğer **"Açık"** yazıyorsa → **KAPATIN**
2. Eğer **"Kapalı"** yazıyorsa → Sorun bu değil, devam edin

---

## ADIM 2: CURSOR AYARLARI KONTROLÜ

### 2.1. Cursor Ayarlarını Açma
1. Cursor programını açın
2. Sol üst köşede **"File"** menüsüne tıklayın
3. **"Preferences"** → **"Settings"** seçeneğine tıklayın
   - VEYA
   - Klavyede **Ctrl + ,** (virgül) tuşlarına birlikte basın

### 2.2. Auto Save Ayarını Kontrol Etme
1. Arama kutusuna **"auto save"** yazın
2. **"Files: Auto Save"** ayarını bulun
3. **"afterDelay"** veya **"onFocusChange"** seçili olmalı
4. **"off"** seçiliyse → **"afterDelay"** yapın

### 2.3. Restore/Recover Ayarını Kontrol Etme
1. Arama kutusuna **"restore"** yazın
2. **"Files: Restore"** veya benzeri bir ayar varsa
3. Bu ayarı **KAPALI** yapın veya **SİLİN**

---

## ADIM 3: YEDEK DOSYA KONTROLÜ

### 3.1. Yedek Dosyanın Taşındığını Kontrol Etme
1. Windows Gezgini'ni açın (Windows tuşu + E)
2. Şu klasöre gidin: **D:\tayfun\dashboard\templates\dashboard\**
3. **"dashboard.YEDEK-20260107-032454.html.TASINDI"** dosyasını görmelisiniz
4. Eğer görüyorsanız → ✅ Yedek dosya taşındı, sorun çözüldü

---

## ADIM 4: TEST ETME

### 4.1. Basit Bir Değişiklik Yapma
1. Cursor'da **dashboard.html** dosyasını açın
2. Herhangi bir yere bir yorum ekleyin (örnek: `<!-- TEST -->`)
3. **Ctrl + S** ile kaydedin
4. Dosyayı kapatın ve tekrar açın
5. Değişikliğin hala orada olup olmadığını kontrol edin

### 4.2. Bekleme Testi
1. Bir değişiklik yapın ve kaydedin
2. **5 dakika bekleyin**
3. Dosyayı tekrar açın
4. Değişiklik hala varsa → ✅ Sorun çözüldü!

---

## SORUN DEVAM EDERSE

Eğer hala dosya geri dönüyorsa:
1. Cursor'u tamamen kapatın
2. Bilgisayarı yeniden başlatın
3. Tekrar test edin

---

## NOTLAR

- Yedek dosya artık **.TASINDI** uzantılı, geri yüklenemez
- Windows File History kapalı olmalı
- Cursor ayarlarında "restore" özelliği kapalı olmalı

