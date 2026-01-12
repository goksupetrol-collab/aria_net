# 4. MADDE: NUMERICTEXTBOX (SAYI GİRİŞİ) - DETAYLI PLAN
## Ne Yapacağız? Nasıl Yapacağız? Nerede Kullanacağız?

---

## 🎯 NE YAPACAĞIZ?

### Şu Anki Durum:
- ❌ Grid'lerde sayı alanları var ama **normal input** kullanılıyor
- ❌ Kullanıcı harf girebilir: "abc123"
- ❌ Negatif sayı girebilir: "-1000"
- ❌ Ondalık sayı kontrolü yok
- ❌ Format kontrolü yok (binlik ayırıcı, ondalık basamak)

### Yapacağımız:
- ✅ Telerik NumericTextBox bileşenini ekleyeceğiz
- ✅ Grid'lerde sayı alanlarına **sadece sayı** girişi yapılacak
- ✅ Harf girişi engellenecek
- ✅ Format kontrolü yapılacak (ondalık basamak, binlik ayırıcı)
- ✅ Min/max değer kontrolü yapılabilir

---

## 📍 NEREDE KULLANACAĞIZ?

### 1. KREDİ KARTI GRID (`telerik_yeni_proje.html`)
**Satır ~1457:**
```javascript
{ field: "tutar", title: "TUTAR", width: 115, attributes: { class: "number-cell", style: "text-align: right;" } }
```
**Şu an:** Normal input, harf girişi mümkün
**Olacak:** NumericTextBox ile sadece sayı girişi

### 2. BANKA GRID (`telerik_yeni_proje.html`)
**Satır ~1555:**
```javascript
{ field: "bakiye", title: "BAKİYE", width: 130, attributes: { class: "number-cell", style: "text-align: right;" } }
```
**Şu an:** Normal input, harf girişi mümkün
**Olacak:** NumericTextBox ile sadece sayı girişi

### 3. TAHSİLAT GRID (`telerik_yeni_proje.html`)
**Satır ~1192:**
```javascript
{ field: "tl", title: "TL", width: 80, attributes: { class: "number-cell", style: "text-align: right;" } }
```
**Şu an:** Normal input, harf girişi mümkün
**Olacak:** NumericTextBox ile sadece sayı girişi

### 4. ÖDEME GRID (`telerik_yeni_proje.html`)
**Satır ~1219:**
```javascript
{ field: "tl", title: "TL", width: 80, attributes: { class: "number-cell", style: "text-align: right;" } }
```
**Şu an:** Normal input, harf girişi mümkün
**Olacak:** NumericTextBox ile sadece sayı girişi

---

## 🔧 NASIL YAPACAĞIZ?

### ADIM 1: Grid Column'lara NumericTextBox Editor Ekleyeceğiz

**Telerik Grid'de sayı alanları için NumericTextBox editor kullanımı:**

```javascript
// ÖNCE (Şu anki durum):
{ field: "tutar", title: "TUTAR", width: 115, attributes: { class: "number-cell", style: "text-align: right;" } }

// SONRA (NumericTextBox ile):
{ 
  field: "tutar", 
  title: "TUTAR", 
  width: 115, 
  attributes: { class: "number-cell", style: "text-align: right;" },
  editor: function(container, options) {
    $('<input name="' + options.field + '"/>')
      .appendTo(container)
      .kendoNumericTextBox({
        format: "n2",  // 2 ondalık basamak, binlik ayırıcı
        decimals: 2,
        culture: "tr-TR",
        value: options.model[options.field] || 0,
        min: 0  // Negatif değer engellenecek
      });
  }
}
```

---

### ADIM 2: Kredi Kartı Grid'ine NumericTextBox Ekleyeceğiz

**Nereye:** `telerik_yeni_proje.html` - Kredi Kartı Grid tanımı (satır ~1457)

**Ne değişecek:**
- `tutar` sütununa `editor` özelliği eklenecek
- Sadece sayı girişi yapılacak
- Ondalık sayı desteği (2 basamak)

---

### ADIM 3: Banka Grid'ine NumericTextBox Ekleyeceğiz

**Nereye:** `telerik_yeni_proje.html` - Banka Grid tanımı (satır ~1555)

**Ne değişecek:**
- `bakiye` sütununa `editor` özelliği eklenecek
- Sadece sayı girişi yapılacak
- Ondalık sayı desteği (2 basamak)

---

### ADIM 4: Tahsilat ve Ödeme Grid'lerine NumericTextBox Ekleyeceğiz

**Nereye:** `telerik_yeni_proje.html` - Tahsilat Grid (satır ~1192) ve Ödeme Grid (satır ~1219)

**Ne değişecek:**
- `tl` sütunlarına `editor` özelliği eklenecek
- Sadece sayı girişi yapılacak
- Ondalık sayı desteği (2 basamak)

---

## 📊 DEĞİŞİKLİK ÖZETİ

### Dosyalar:
1. **`telerik_yeni_proje.html`** → 4 Grid'de NumericTextBox eklenecek

### Değişiklikler:
- ✅ 1 adet NumericTextBox eklenecek (Kredi Kartı Grid - tutar)
- ✅ 1 adet NumericTextBox eklenecek (Banka Grid - bakiye)
- ✅ 1 adet NumericTextBox eklenecek (Tahsilat Grid - tl)
- ✅ 1 adet NumericTextBox eklenecek (Ödeme Grid - tl)
- ✅ Toplam 4 sayı alanı NumericTextBox ile çalışacak

---

## 🎨 NASIL GÖRÜNECEK?

### Şu An (Normal Input):
- ❌ Sayı alanına tıklayınca → Normal input, harf girişi mümkün
- ❌ "abc123" gibi hatalı giriş mümkün
- ❌ Format kontrolü yok

### Olacak (NumericTextBox):
- ✅ Sayı alanına tıklayınca → **Sadece sayı girişi**
- ✅ Harf girişi engellenecek
- ✅ Format kontrolü: "1.234,56" (binlik ayırıcı, ondalık basamak)
- ✅ Negatif değer engellenecek (min: 0)
- ✅ Artı/eksi butonları olacak

---

## ✅ TEST PLANI

### Test 1: Kredi Kartı Grid - Tutar
- Kredi Kartı Grid'i aç
- "TUTAR" sütununa çift tıkla
- Harf girişi yapmayı dene → Engellenmeli
- Sayı girişi yap → Çalışmalı
- Ondalık sayı girişi → Çalışmalı (örn: 1234.56)

### Test 2: Banka Grid - Bakiye
- Banka Grid'i aç
- "BAKİYE" sütununa çift tıkla
- Harf girişi yapmayı dene → Engellenmeli
- Sayı girişi yap → Çalışmalı

### Test 3: Tahsilat Grid - TL
- Tahsilat Grid'i aç
- "TL" sütununa çift tıkla
- Harf girişi yapmayı dene → Engellenmeli
- Sayı girişi yap → Çalışmalı

### Test 4: Ödeme Grid - TL
- Ödeme Grid'i aç
- "TL" sütununa çift tıkla
- Harf girişi yapmayı dene → Engellenmeli
- Sayı girişi yap → Çalışmalı

---

## 🚨 DİKKAT EDİLECEKLER

### 1. NumericTextBox Özellikleri
- `format: "n2"` → 2 ondalık basamak, binlik ayırıcı
- `decimals: 2` → Ondalık basamak sayısı
- `culture: "tr-TR"` → Türkçe format (nokta binlik, virgül ondalık)
- `min: 0` → Negatif değer engellenecek
- `value: options.model[options.field] || 0` → Mevcut değer veya 0

### 2. Format Açıklaması
- `"n2"` → Sayı formatı, 2 ondalık basamak
- Türkçe kültürde: "1.234,56" (nokta binlik, virgül ondalık)
- İngilizce kültürde: "1,234.56" (virgül binlik, nokta ondalık)

### 3. Veri Tipi Uyumu
- Grid'in `schema.model.fields` kısmında `type: "number"` olmalı
- Şu anda `type: "string"` olabilir, değiştirmeyeceğiz (NumericTextBox otomatik dönüştürür)

---

## 📝 SONUÇ

### Ne Yapacağız:
1. ✅ Kredi Kartı Grid'ine NumericTextBox ekleyeceğiz (`tutar`)
2. ✅ Banka Grid'ine NumericTextBox ekleyeceğiz (`bakiye`)
3. ✅ Tahsilat Grid'ine NumericTextBox ekleyeceğiz (`tl`)
4. ✅ Ödeme Grid'ine NumericTextBox ekleyeceğiz (`tl`)
5. ✅ Test edeceğiz

### Faydaları:
- ✅ %100 daha güvenli (harf girişi engellenecek)
- ✅ Format kontrolü (ondalık basamak, binlik ayırıcı)
- ✅ Negatif değer engellenecek
- ✅ Profesyonel görünüm (artı/eksi butonları)

### Risk:
- ⚠️ Düşük risk (sadece Grid editor değişiyor)
- ⚠️ Çalışmazsa geri alınabilir

---

**Hazırız! NumericTextBox bileşenini ekleyelim mi?** 🚀
