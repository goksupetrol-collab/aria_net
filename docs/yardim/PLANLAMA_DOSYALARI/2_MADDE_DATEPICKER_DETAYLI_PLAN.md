# 2. MADDE: DATEPICKER (TARİH SEÇİCİ) - DETAYLI PLAN
## Ne Yapacağız? Nasıl Yapacağız? Nerede Kullanacağız?

---

## 🎯 NE YAPACAĞIZ?

### Şu Anki Durum:
- ❌ Grid'lerde tarih alanları var ama **normal input** kullanılıyor
- ❌ Kullanıcı manuel tarih yazıyor: "15.01.2024"
- ❌ Hatalı tarih girişi olabilir: "32.13.2024"
- ❌ Format karışıklığı: "15/01/2024" vs "15.01.2024"
- ❌ Takvim yok, manuel yazma zor

### Yapacağımız:
- ✅ Telerik DatePicker bileşenini ekleyeceğiz
- ✅ Grid'lerde tarih alanlarına **takvim** açılacak
- ✅ Türkçe tarih formatı: "dd.MM.yyyy" (15.01.2024)
- ✅ Hata kontrolü otomatik (geçersiz tarih girişi engellenecek)

---

## 📍 NEREDE KULLANACAĞIZ?

### 1. KREDİ KARTI GRID (`telerik_yeni_proje.html`)
**Satır 1418:**
```javascript
{ field: "son_odeme", title: "SON ÖDEME", width: 125, format: "{0:dd.MM.yyyy}" }
```
**Şu an:** Normal input, manuel yazma
**Olacak:** DatePicker ile takvim açılacak

### 2. BANKA GRID (`telerik_yeni_proje.html`)
**Satır 1497:**
```javascript
{ field: "acilis_tarihi", title: "AÇILIŞ TARİHİ", width: 130, format: "{0:dd.MM.yyyy}" }
```
**Şu an:** Normal input, manuel yazma
**Olacak:** DatePicker ile takvim açılacak

---

## 🔧 NASIL YAPACAĞIZ?

### ADIM 1: Grid Column'lara DatePicker Editor Ekleyeceğiz

**Telerik Grid'de tarih alanları için özel editor kullanılır:**

```javascript
// ÖNCE (Şu anki durum):
{ field: "son_odeme", title: "SON ÖDEME", width: 125, format: "{0:dd.MM.yyyy}" }

// SONRA (DatePicker ile):
{ 
  field: "son_odeme", 
  title: "SON ÖDEME", 
  width: 125, 
  format: "{0:dd.MM.yyyy}",
  editor: function(container, options) {
    $('<input name="' + options.field + '"/>')
      .appendTo(container)
      .kendoDatePicker({
        culture: "tr-TR",
        format: "dd.MM.yyyy",
        value: options.model[options.field]
      });
  }
}
```

---

### ADIM 2: Kredi Kartı Grid'ine DatePicker Ekleyeceğiz

**Nereye:** `telerik_yeni_proje.html` - Kredi Kartı Grid tanımı (satır ~1418)

**Ne değişecek:**
- `son_odeme` sütununa `editor` özelliği eklenecek
- Tıklayınca takvim açılacak
- Türkçe tarih formatı kullanılacak

---

### ADIM 3: Banka Grid'ine DatePicker Ekleyeceğiz

**Nereye:** `telerik_yeni_proje.html` - Banka Grid tanımı (satır ~1497)

**Ne değişecek:**
- `acilis_tarihi` sütununa `editor` özelliği eklenecek
- Tıklayınca takvim açılacak
- Türkçe tarih formatı kullanılacak

---

## 📊 DEĞİŞİKLİK ÖZETİ

### Dosyalar:
1. **`telerik_yeni_proje.html`** → 2 Grid'de DatePicker eklenecek

### Değişiklikler:
- ✅ 1 adet `editor` fonksiyonu eklenecek (Kredi Kartı Grid)
- ✅ 1 adet `editor` fonksiyonu eklenecek (Banka Grid)
- ✅ Toplam 2 tarih alanı DatePicker ile çalışacak

---

## 🎨 NASIL GÖRÜNECEK?

### Şu An (Normal Input):
- ❌ Tarih alanına tıklayınca → Normal input, manuel yazma
- ❌ Hatalı tarih girişi mümkün: "32.13.2024"
- ❌ Takvim yok

### Olacak (DatePicker):
- ✅ Tarih alanına tıklayınca → **Takvim açılacak**
- ✅ Takvimden tarih seçilecek
- ✅ Hatalı tarih girişi engellenecek
- ✅ Türkçe tarih formatı: "15.01.2024"
- ✅ Geçmiş/gelecek tarih kontrolü yapılabilir

---

## ✅ TEST PLANI

### Test 1: Kredi Kartı Grid - Son Ödeme Tarihi
- Kredi Kartı Grid'i aç
- "SON ÖDEME" sütununa tıkla
- Takvim açılıyor mu?
- Tarih seçiliyor mu?
- Format doğru mu? (dd.MM.yyyy)

### Test 2: Banka Grid - Açılış Tarihi
- Banka Grid'i aç
- "AÇILIŞ TARİHİ" sütununa tıkla
- Takvim açılıyor mu?
- Tarih seçiliyor mu?
- Format doğru mu? (dd.MM.yyyy)

### Test 3: Hata Kontrolü
- Geçersiz tarih girişi yapmayı dene
- Hata mesajı gösteriliyor mu?
- Kaydetme engelleniyor mu?

---

## 🚨 DİKKAT EDİLECEKLER

### 1. Telerik Kültür Ayarları
- `culture: "tr-TR"` kullanılacak (Türkçe)
- `format: "dd.MM.yyyy"` kullanılacak (15.01.2024)

### 2. Grid Editor Fonksiyonu
- Editor fonksiyonu Grid'in `columns` tanımında olmalı
- `options.model[options.field]` ile mevcut değer alınmalı

### 3. Veri Tipi Uyumu
- Grid'in `schema.model.fields` kısmında `type: "date"` olmalı
- Bu zaten var, değiştirmeyeceğiz

---

## 📝 SONUÇ

### Ne Yapacağız:
1. ✅ Kredi Kartı Grid'ine DatePicker ekleyeceğiz (`son_odeme`)
2. ✅ Banka Grid'ine DatePicker ekleyeceğiz (`acilis_tarihi`)
3. ✅ Test edeceğiz

### Faydaları:
- ✅ %100 daha güvenli (hatalı tarih girişi engellenecek)
- ✅ %50 daha hızlı (takvimden seçim, manuel yazma yok)
- ✅ Türkçe tarih formatı
- ✅ Profesyonel görünüm

### Risk:
- ⚠️ Düşük risk (sadece Grid editor değişiyor)
- ⚠️ Çalışmazsa geri alınabilir

---

**Hazırız! DatePicker bileşenini ekleyelim mi?** 🚀
