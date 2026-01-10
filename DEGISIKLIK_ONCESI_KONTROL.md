# DEĞİŞİKLİK ÖNCESİ KONTROL LİSTESİ

## DEĞİŞİKLİK YAPMADAN ÖNCE

### 1. Hangi Tabloyu Değiştireceğiz?
- [ ] MOTORİN tablosu
- [ ] BENZİN tablosu
- [ ] TAHSİLAT tablosu
- [ ] ÖDEME tablosu
- [ ] ÖDEME (DBS) tablosu
- [ ] ENTRY tablosu
- [ ] ARAÇLAR

### 2. TABLO_YAPILARI.md Dosyasını Oku
- ✅ Mevcut yapıyı kontrol et
- ✅ Hangi satırlarda olduğunu bul
- ✅ CSS sınıflarını kontrol et
- ✅ JavaScript var mı kontrol et

### 3. Mevcut Durumu Kaydet
- ✅ Değişiklik öncesi Git commit var mı kontrol et
- ✅ `git status` ile değişiklik var mı bak

### 4. Değişiklik Yap
- ✅ Sadece gerekli kısmı değiştir
- ✅ CSS sınıflarına dikkat et
- ✅ JavaScript kodlarını bozmamaya dikkat et

### 5. Test Et
- ✅ Tarayıcıda kontrol et
- ✅ Başka bir şey bozuldu mu bak

### 6. Git Commit Yap
- ✅ `git add .`
- ✅ `git commit -m "Açıklama"`

---

## ÖRNEK: MOTORİN Tablosunda Değişiklik

### Adım 1: Kontrol
```
TABLO_YAPILARI.md → MOTORİN tablosu bölümünü oku
- Satır: 194-246
- JavaScript var: Evet (satır 313-565)
- API entegrasyonu var: Evet
```

### Adım 2: Dikkat Edilecekler
- ⚠️ JavaScript kodlarını bozmamaya dikkat!
- ⚠️ API entegrasyonunu bozmamaya dikkat!
- ⚠️ CSS sınıflarını değiştirirken dikkatli ol!

### Adım 3: Değişiklik Yap
- Sadece gerekli kısmı değiştir
- JavaScript kodlarını kontrol et

### Adım 4: Test
- Tarayıcıda aç
- Çalışıyor mu kontrol et

---

## ÖRNEK: TAHSİLAT Tablosunda Değişiklik

### Adım 1: Kontrol
```
TABLO_YAPILARI.md → TAHSİLAT tablosu bölümünü oku
- Satır: 277-289
- JavaScript var: Hayır
- Sadece HTML/CSS
```

### Adım 2: Dikkat Edilecekler
- ✅ Sadece HTML/CSS (kolay)
- ⚠️ CSS sınıflarına dikkat (.tahsilat-header, .tahsilat-row)

### Adım 3: Değişiklik Yap
- HTML yapısını değiştir
- CSS ekle/güncelle

### Adım 4: Test
- Tarayıcıda aç
- Görünüm doğru mu kontrol et

---

## HIZLI REFERANS

### Tablo Bulma Komutları
```bash
# MOTORİN tablosu
grep -n "MOTORİN" dashboard/templates/dashboard/dashboard.html

# TAHSİLAT tablosu
grep -n "TAHSİLAT" dashboard/templates/dashboard/dashboard.html

# ÖDEME tablosu
grep -n "ÖDEME" dashboard/templates/dashboard/dashboard.html
```

### Değişiklik Öncesi Kontrol
```bash
cd D:\tayfun
git status  # Değişiklik var mı?
git log --oneline -1  # Son commit nedir?
```

---

## ÖNEMLİ KURALLAR

1. **Her zaman TABLO_YAPILARI.md'yi oku**
2. **Değişiklik yapmadan önce mevcut durumu kontrol et**
3. **JavaScript varsa dikkatli ol**
4. **Değişiklikten sonra test et**
5. **Git commit yap**

---

## SORUN GİDERME

### Başka Bir Şey Bozuldu
1. `git status` ile ne değişti bak
2. `git diff` ile değişiklikleri gör
3. Gerekirse `git restore` ile geri al

### JavaScript Bozuldu
1. Tarayıcı konsolunu aç (F12)
2. Hata var mı bak
3. `git restore` ile geri al
4. Tekrar dene


