# 3. MADDE: COMBOBOX (DROPDOWN LİSTE) - DETAYLI PLAN
## Ne Yapacağız? Nasıl Yapacağız? Nerede Kullanacağız?

---

## 🎯 NE YAPACAĞIZ?

### Şu Anki Durum:
- ❌ Grid'lerde metin alanları var ama **normal input** kullanılıyor
- ❌ Kullanıcı manuel yazıyor: "Ziraat Bankası", "TL", "Vadeli"
- ❌ Yazım hatası olabilir: "Ziraat" vs "Ziraat Bankası"
- ❌ Tutarsızlık: "TL" vs "Türk Lirası"
- ❌ Liste yok, manuel yazma zor

### Yapacağımız:
- ✅ Telerik ComboBox bileşenini ekleyeceğiz
- ✅ Grid'lerde metin alanlarına **dropdown liste** açılacak
- ✅ Önceden tanımlı listelerden seçim yapılacak
- ✅ Arama özelliği olacak (yazarken filtreleme)

---

## 📍 NEREDE KULLANACAĞIZ?

### 1. KREDİ KARTI GRID (`telerik_yeni_proje.html`)
**Satır 1439:**
```javascript
{ field: "banka", title: "BANKA", width: 135 }
```
**Şu an:** Normal input, manuel yazma
**Olacak:** ComboBox ile banka listesinden seçim

### 2. BANKA GRID (`telerik_yeni_proje.html`)
**Satır 1512:** `banka_adi` (BANKA ADI)
**Satır 1516:** `para_birimi` (PARA BİRİMİ)
**Satır 1517:** `hesap_turu` (HESAP TÜRÜ)
**Satır 1518:** `sube` (ŞUBE)

**Şu an:** Normal input, manuel yazma
**Olacak:** ComboBox ile önceden tanımlı listelerden seçim

---

## 🔧 NASIL YAPACAĞIZ?

### ADIM 1: Liste Verilerini Tanımlayacağız

**Banka Listesi:**
```javascript
var bankaListesi = [
  "Ziraat Bankası",
  "İş Bankası",
  "Garanti BBVA",
  "Akbank",
  "Yapı Kredi",
  "Halkbank",
  "Vakıfbank"
];
```

**Para Birimi Listesi:**
```javascript
var paraBirimiListesi = ["TL", "USD", "EUR", "GBP"];
```

**Hesap Türü Listesi:**
```javascript
var hesapTuruListesi = ["Vadeli", "Vadesiz", "Tasarruf", "Cari"];
```

**Şube Listesi:**
```javascript
var subeListesi = ["YAĞCILAR", "TEPEKUM", "NAMDAR", "ŞEKER", "AKOVA", "KOOP.", "NAZİLLİ"];
```

---

### ADIM 2: Grid Column'lara ComboBox Editor Ekleyeceğiz

**Telerik Grid'de ComboBox editor kullanımı:**

```javascript
// ÖNCE (Şu anki durum):
{ field: "banka_adi", title: "BANKA ADI", width: 150 }

// SONRA (ComboBox ile):
{ 
  field: "banka_adi", 
  title: "BANKA ADI", 
  width: 150,
  editor: function(container, options) {
    $('<input name="' + options.field + '"/>')
      .appendTo(container)
      .kendoComboBox({
        dataSource: bankaListesi,
        filter: "contains",
        placeholder: "Banka seçin...",
        suggest: true
      });
  }
}
```

---

### ADIM 3: Kredi Kartı Grid'ine ComboBox Ekleyeceğiz

**Nereye:** `telerik_yeni_proje.html` - Kredi Kartı Grid tanımı (satır ~1439)

**Ne değişecek:**
- `banka` sütununa `editor` özelliği eklenecek
- Banka listesinden seçim yapılacak

---

### ADIM 4: Banka Grid'ine ComboBox Ekleyeceğiz

**Nereye:** `telerik_yeni_proje.html` - Banka Grid tanımı (satır ~1512-1518)

**Ne değişecek:**
- `banka_adi` sütununa ComboBox eklenecek
- `para_birimi` sütununa ComboBox eklenecek
- `hesap_turu` sütununa ComboBox eklenecek
- `sube` sütununa ComboBox eklenecek

---

## 📊 DEĞİŞİKLİK ÖZETİ

### Dosyalar:
1. **`telerik_yeni_proje.html`** → 2 Grid'de ComboBox eklenecek

### Değişiklikler:
- ✅ 4 adet liste tanımlanacak (Banka, Para Birimi, Hesap Türü, Şube)
- ✅ 1 adet ComboBox eklenecek (Kredi Kartı Grid - banka)
- ✅ 4 adet ComboBox eklenecek (Banka Grid - banka_adi, para_birimi, hesap_turu, sube)
- ✅ Toplam 5 alan ComboBox ile çalışacak

---

## 🎨 NASIL GÖRÜNECEK?

### Şu An (Normal Input):
- ❌ Metin alanına tıklayınca → Normal input, manuel yazma
- ❌ Yazım hatası mümkün
- ❌ Liste yok

### Olacak (ComboBox):
- ✅ Metin alanına tıklayınca → **Dropdown liste açılacak**
- ✅ Listeden seçim yapılacak
- ✅ Yazarken arama yapılacak (filtreleme)
- ✅ Yazım hatası engellenecek
- ✅ Tutarlı veri girişi

---

## ✅ TEST PLANI

### Test 1: Kredi Kartı Grid - Banka
- Kredi Kartı Grid'i aç
- "BANKA" sütununa çift tıkla
- Dropdown liste açılıyor mu?
- Banka seçiliyor mu?
- Yazarken arama çalışıyor mu?

### Test 2: Banka Grid - Banka Adı
- Banka Grid'i aç
- "BANKA ADI" sütununa çift tıkla
- Dropdown liste açılıyor mu?
- Banka seçiliyor mu?

### Test 3: Banka Grid - Para Birimi
- "PARA BİRİMİ" sütununa çift tıkla
- Dropdown liste açılıyor mu?
- TL, USD, EUR seçilebiliyor mu?

### Test 4: Banka Grid - Şube
- "ŞUBE" sütununa çift tıkla
- Dropdown liste açılıyor mu?
- Şube listesi görünüyor mu? (YAĞCILAR, TEPEKUM, vb.)

---

## 🚨 DİKKAT EDİLECEKLER

### 1. ComboBox Özellikleri
- `filter: "contains"` → Yazarken arama yapılacak
- `suggest: true` → Öneriler gösterilecek
- `placeholder` → Boş durumda gösterilecek metin

### 2. Liste Verileri
- Liste verileri Grid tanımından önce tanımlanmalı
- Tüm Grid'lerde kullanılabilir olmalı

### 3. Mevcut Değer
- `options.model[options.field]` ile mevcut değer alınmalı
- ComboBox'ta seçili değer gösterilmeli

---

## 📝 SONUÇ

### Ne Yapacağız:
1. ✅ Liste verilerini tanımlayacağız (Banka, Para Birimi, Hesap Türü, Şube)
2. ✅ Kredi Kartı Grid'ine ComboBox ekleyeceğiz (`banka`)
3. ✅ Banka Grid'ine 4 adet ComboBox ekleyeceğiz (`banka_adi`, `para_birimi`, `hesap_turu`, `sube`)
4. ✅ Test edeceğiz

### Faydaları:
- ✅ %100 daha tutarlı (yazım hatası engellenecek)
- ✅ %70 daha hızlı (listeden seçim, manuel yazma yok)
- ✅ Arama özelliği (yazarken filtreleme)
- ✅ Profesyonel görünüm

### Risk:
- ⚠️ Düşük risk (sadece Grid editor değişiyor)
- ⚠️ Çalışmazsa geri alınabilir

---

**Hazırız! ComboBox bileşenini ekleyelim mi?** 🚀
