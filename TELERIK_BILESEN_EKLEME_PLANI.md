# TELERİK BİLEŞEN EKLEME PLANI
## Güvenli Adım Adım Yaklaşım

---

## 🎯 PLAN

### 1. GÜVENLİ BAŞLANGIÇ NOKTASI ✅
- ✅ Mevcut durum Git'e commit edildi
- ✅ Geri dönüş noktası hazır

---

### 2. BİLEŞENLERİN EKLENME SIRASI

#### ADIM 1: NOTIFICATION (Bildirimler) 🔔
**Neden ilk:**
- En kolay
- En az riskli
- Hemen görünür sonuç

**Ne yapılacak:**
- `base.html`'e Notification bileşeni eklenecek
- `alert()` yerine Notification kullanılacak
- Test edilecek

**Geri dönüş:**
- Sorun olursa: `git checkout -- dashboard/templates/dashboard/base.html`

---

#### ADIM 2: DATEPICKER (Tarih Seçici) 📅
**Neden ikinci:**
- Çok kullanışlı
- Grid'lerde tarih alanları var

**Ne yapılacak:**
- Kredi kartı `son_odeme` alanına DatePicker eklenecek
- Banka `acilis_tarihi` alanına DatePicker eklenecek
- Test edilecek

**Geri dönüş:**
- Sorun olursa: `git checkout -- dashboard/templates/dashboard/telerik_yeni_proje.html`

---

#### ADIM 3: COMBOBOX (Dropdown Liste) 📋
**Neden üçüncü:**
- Çok kullanışlı
- Banka, şube seçimleri için

**Ne yapılacak:**
- Banka adı alanına ComboBox eklenecek
- Şube seçimi için ComboBox eklenecek
- Test edilecek

**Geri dönüş:**
- Sorun olursa: `git checkout -- dashboard/templates/dashboard/telerik_yeni_proje.html`

---

#### ADIM 4: NUMERICTEXTBOX (Sayı Girişi) 🔢
**Neden dördüncü:**
- Güvenlik için önemli
- Miktar, fiyat alanları için

**Ne yapılacak:**
- Miktar (litre) alanlarına NumericTextBox eklenecek
- Fiyat (TL) alanlarına NumericTextBox eklenecek
- Test edilecek

**Geri dönüş:**
- Sorun olursa: `git checkout -- dashboard/templates/dashboard/telerik_yeni_proje.html`

---

#### ADIM 5: CHART (Grafikler) 📊
**Neden beşinci:**
- Görsel, ama zorunlu değil
- İstatistik sayfası için

**Ne yapılacak:**
- Satış grafikleri eklenecek
- Test edilecek

**Geri dönüş:**
- Sorun olursa: `git checkout -- dashboard/templates/dashboard/telerik_yeni_proje.html`

---

#### ADIM 6: UPLOAD (Dosya Yükleme) 📤
**Neden altıncı:**
- Backend API gerektirir
- En karmaşık

**Ne yapılacak:**
- Excel yükleme özelliği eklenecek
- Backend API eklenecek
- Test edilecek

**Geri dönüş:**
- Sorun olursa: `git checkout -- dashboard/templates/dashboard/telerik_yeni_proje.html` ve `git checkout -- dashboard/views.py`

---

## 🔄 GERİ DÖNÜŞ PLANI

### Senaryo 1: Tek Bileşen Sorunlu
```bash
# Sadece o dosyayı geri al
git checkout -- dashboard/templates/dashboard/telerik_yeni_proje.html
```

### Senaryo 2: Tüm Değişiklikler Sorunlu
```bash
# Tüm değişiklikleri geri al
git reset --hard HEAD
```

### Senaryo 3: Belirli Bir Commit'e Dön
```bash
# Commit hash'ini bul
git log --oneline

# O commit'e dön
git reset --hard [COMMIT_HASH]
```

---

## ✅ HER ADIMDA YAPILACAKLAR

1. **Bileşeni ekle** → Kod yaz
2. **Test et** → Tarayıcıda kontrol et
3. **Çalışıyorsa** → Git'e commit et
4. **Çalışmıyorsa** → Geri al, düzelt, tekrar dene

---

## 📝 COMMIT MESAJLARI

Her başarılı adımda:
```bash
git add dashboard/templates/dashboard/telerik_yeni_proje.html
git commit -m "Notification bileşeni eklendi - alert() yerine kendoNotification kullanılıyor"
```

---

## 🎯 SONUÇ

- ✅ Güvenli başlangıç noktası hazır
- ✅ Her adım test edilecek
- ✅ Sorun olursa geri dönülebilir
- ✅ Adım adım ilerleyeceğiz

**Hazırız! İlk bileşenle başlayalım mı?** 🚀
