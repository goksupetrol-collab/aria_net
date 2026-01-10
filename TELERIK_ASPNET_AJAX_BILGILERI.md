# TELERİK ASP.NET AJAX DOKÜMANTASYONU - BİZİM PROJE İÇİN ÇIKARILANLAR

> **Not:** Bu dosya ASP.NET AJAX dokümantasyonundan bizim Django/Kendo UI projesi için çıkarılan önemli bilgileri içerir.

## 🎯 ASP.NET AJAX NEDİR? (Basit Açıklama)

**ASP.NET AJAX:**
- 🌐 **Ne için:** .NET Framework ile web uygulamaları (Web Forms)
- 💻 **Dil:** C# / VB.NET (Server-side) + HTML/JavaScript (Client-side)
- 📦 **Kurulum:** .NET Framework 4.6.2 - 4.8.1
- 🔧 **Yaklaşım:** Server-side kontroller (RadGrid, RadMenu, vb.)
- ❌ **Bizim projede:** KULLANILMIYOR (Django + Kendo UI kullanıyoruz)

**Kendo UI (Bizim Kullandığımız):**
- 🌐 **Ne için:** Web uygulamaları (herhangi bir backend ile)
- 💻 **Dil:** JavaScript, HTML, CSS (Client-side)
- 📦 **Kurulum:** Web sunucusunda çalışır
- 🔧 **Yaklaşım:** Client-side JavaScript bileşenleri
- ✅ **Bizim projede:** KULLANILIYOR (Django backend, Kendo UI frontend)

## 📋 ASP.NET AJAX'DAKİ BİLEŞENLER (120+ Adet)

### ✅ BİZİM PROJEDE KULLANDIKLARIMIZ

| ASP.NET AJAX | Kendo UI (Bizim) | Kullanım Durumu |
|--------------|------------------|-----------------|
| **Grid** | `kendoGrid` | ✅ **KULLANILIYOR** (6 adet grid) |
| **Menu** | `kendoMenu` | ✅ **KULLANILIYOR** (top-menu-bar) |
| **ToolBar** | `kendoToolbar` | ✅ **KULLANILIYOR** (panel başlıkları) |
| **Button** | `k-button` CSS | ✅ **KULLANILIYOR** (ikonlu butonlar) |
| **Badge** | `kendoBadge` | ✅ **KULLANILIYOR** (toplam değerleri) |

### 🎯 KULLANILABİLİR AMA HENÜZ KULLANMADIĞIMIZ

| ASP.NET AJAX | Kendo UI | Ne İçin Kullanılabilir? |
|--------------|----------|-------------------------|
| **DatePicker** | `kendoDatePicker` | Tarih seçimi (satış tarihleri, rapor tarihleri) |
| **DateTimePicker** | `kendoDateTimePicker` | Tarih + saat seçimi |
| **ComboBox** | `kendoComboBox` | Dropdown liste (şube seçimi, ürün seçimi) |
| **MultiSelect** | `kendoMultiSelect` | Çoklu seçim (filtreleme için) |
| **NumericTextBox** | `kendoNumericTextBox` | Sayı girişi (miktar, fiyat) |
| **AutoCompleteBox** | `kendoAutoComplete` | Otomatik tamamlama (arama) |
| **Chart** | `kendoChart` | Grafikler (satış grafikleri, istatistikler) |
| **TreeView** | `kendoTreeView` | Hiyerarşik liste (kategori yapısı) |
| **TabStrip** | `kendoTabStrip` | Sekmeler (farklı görünümler) |
| **Window** | `kendoWindow` | Popup pencereler (detay görüntüleme) |
| **Notification** | `kendoNotification` | Bildirimler (başarı/hata mesajları) |
| **ProgressBar** | `kendoProgressBar` | İlerleme çubuğu (yükleme durumu) |
| **Slider** | `kendoSlider` | Kaydırıcı (filtreleme, ayar) |
| **Upload** | `kendoUpload` | Dosya yükleme (Excel, resim) |
| **Editor** | `kendoEditor` | Metin editörü (notlar, açıklamalar) |
| **PivotGrid** | `kendoPivotGrid` | Pivot tablo (analiz, özet) |
| **Scheduler** | `kendoScheduler` | Takvim/planlayıcı (randevu, görev) |
| **Gantt** | `kendoGantt` | Gantt çizelgesi (proje yönetimi) |
| **Map** | `kendoMap` | Harita (konum gösterimi) |
| **Diagram** | `kendoDiagram` | Diyagram (akış şeması, organizasyon) |

### 📊 VERİ YÖNETİMİ BİLEŞENLERİ

| ASP.NET AJAX | Kendo UI | Kullanım Senaryosu |
|--------------|----------|-------------------|
| **ListBox** | `kendoListBox` | Liste seçimi (çoklu seçim) |
| **ListView** | `kendoListView` | Liste görünümü (kart görünümü) |
| **TreeList** | `kendoTreeList` | Hiyerarşik grid (kategori + alt kategori) |
| **PivotGrid** | `kendoPivotGrid` | Özet tablo (satış analizi) |
| **Spreadsheet** | `kendoSpreadsheet` | Excel benzeri tablo (hesaplama) |

## 💡 BİZİM PROJE İÇİN ÇIKARILANLAR

### 1. ✅ ZATEN KULLANDIKLARIMIZ

#### Grid (6 Adet)
- `motorin-grid` - Motorin satış tablosu
- `benzin-grid` - Benzin satış tablosu
- `tahsilat-grid` - Tahsilat kayıtları
- `odeme-grid` - Ödeme kayıtları
- `yakit-alimlari-grid` - Yakıt alımları
- `araclar-grid` - Araç listesi

**Özellikler:**
- ✅ Sıralama (sortable)
- ✅ Filtreleme (filterable)
- ✅ Sayfalama (pageable)
- ✅ Düzenlenebilir (editable: incell)
- ✅ Yeniden boyutlandırılabilir (resizable)

#### Menu
- `top-menu-bar` - En üst menü (Tanımlar, Kartlar)

**Özellikler:**
- ✅ Yatay menü (horizontal)
- ✅ Alt menüler (dropdown)
- ✅ HTML yapısı (`<ul><li>`)

#### Toolbar
- Panel başlıkları (MOTORİN, BENZİN, TAHSİLAT, vb.)

### 2. 🎯 KULLANILABİLİR YENİ BİLEŞENLER

#### DatePicker / DateTimePicker
**Ne için:**
- Satış tarihi seçimi
- Rapor tarih aralığı seçimi
- Filtreleme için tarih seçimi

**Örnek Kullanım:**
```javascript
$("#tarih-secici").kendoDatePicker({
  culture: "tr-TR",
  format: "dd/MM/yyyy"
});
```

#### ComboBox / MultiSelect
**Ne için:**
- Şube seçimi (dropdown)
- Ürün seçimi (dropdown)
- Filtreleme için çoklu seçim

**Örnek Kullanım:**
```javascript
$("#sube-secici").kendoComboBox({
  dataSource: subeListesi,
  dataTextField: "ad",
  dataValueField: "id"
});
```

#### Chart
**Ne için:**
- Satış grafikleri
- İstatistik görselleştirme
- Rapor grafikleri

**Örnek Kullanım:**
```javascript
$("#satis-grafik").kendoChart({
  dataSource: satisVerileri,
  series: [{
    type: "column",
    field: "miktar"
  }]
});
```

#### Notification
**Ne için:**
- Başarı mesajları ("Kayıt başarıyla eklendi")
- Hata mesajları ("Hata oluştu")
- Bilgi mesajları

**Örnek Kullanım:**
```javascript
var notification = $("#notification").kendoNotification().data("kendoNotification");
notification.show("Kayıt başarıyla eklendi", "success");
```

#### Window
**Ne için:**
- Detay görüntüleme (popup)
- Form açma (yeni kayıt)
- Onay penceresi

**Örnek Kullanım:**
```javascript
$("#detay-pencere").kendoWindow({
  title: "Detaylar",
  width: 600,
  height: 400,
  modal: true
});
```

### 3. 📚 ÖZELLİK KARŞILAŞTIRMASI

ASP.NET AJAX dokümantasyonundan öğrendiklerimiz:

#### Grid Özellikleri
- ✅ **Sıralama:** ASP.NET AJAX'da var → Kendo UI'da da var
- ✅ **Filtreleme:** ASP.NET AJAX'da var → Kendo UI'da da var
- ✅ **Sayfalama:** ASP.NET AJAX'da var → Kendo UI'da da var
- ✅ **Düzenlenebilir:** ASP.NET AJAX'da var → Kendo UI'da da var
- ✅ **Yeniden boyutlandırma:** ASP.NET AJAX'da var → Kendo UI'da da var

#### Menu Özellikleri
- ✅ **Yatay/Dikey:** ASP.NET AJAX'da var → Kendo UI'da da var
- ✅ **Alt menüler:** ASP.NET AJAX'da var → Kendo UI'da da var
- ✅ **Animasyon:** ASP.NET AJAX'da var → Kendo UI'da da var

### 4. 🎨 TASARIM YAKLAŞIMI

ASP.NET AJAX dokümantasyonundan:
- **Tema sistemi:** Telerik'in tüm ürünlerinde benzer tema yaklaşımı
- **CSS değişkenleri:** Benzer renk sistemi
- **Responsive:** Mobil uyumlu tasarım
- **Accessibility:** Erişilebilirlik özellikleri

**Bizim projede:**
- ✅ Telerik CSS değişkenleri kullanılıyor
- ✅ Tema: `default-main.css`
- ✅ Responsive tasarım düşünülmeli

## 🚀 ÖNERİLER

### Kısa Vadede Eklenebilir
1. **DatePicker** - Tarih seçimi için
2. **Notification** - Kullanıcı bildirimleri için
3. **ComboBox** - Dropdown seçimler için

### Orta Vadede Eklenebilir
1. **Chart** - Grafik görselleştirme
2. **Window** - Popup pencereler
3. **TabStrip** - Sekme yapısı

### Uzun Vadede Eklenebilir
1. **PivotGrid** - Analiz tabloları
2. **Scheduler** - Takvim/planlayıcı
3. **Gantt** - Proje yönetimi

## ⚠️ ÖNEMLİ NOTLAR

### Kod Farkları
- ❌ **ASP.NET AJAX:** Server-side kontroller (`<telerik:RadGrid>`)
- ✅ **Kendo UI:** Client-side JavaScript (`$("#grid").kendoGrid()`)

### Direkt Kopyalama Yapmayın
- ASP.NET AJAX kodunu direkt kopyalayamazsınız
- Mantığı anlayıp JavaScript'e çevirin
- Kendo UI dokümantasyonuna bakın

### Bileşen İsimleri Benzer
- ASP.NET AJAX'da `Grid` → Kendo UI'da `Grid`
- ASP.NET AJAX'da `Menu` → Kendo UI'da `Menu`
- Özellik isimleri de benzer olabilir

## 📚 KAYNAK

**ASP.NET AJAX Dokümantasyonu:**
https://www.telerik.com/products/aspnet-ajax/documentation/introduction

**Kendo UI Dokümantasyonu (Bizim için):**
https://www.telerik.com/kendo-jquery-ui

---

**Son Güncelleme:** 2025-01-XX
**Analiz:** ASP.NET AJAX dokümantasyonundan bizim Django/Kendo UI projesi için çıkarılanlar
