# TELERİK 120+ BİLEŞEN - KOLAY ÖRNEKLERLE
## Sokak Diliyle, Basit Anlatım, Projemize Uygun Örnekler

---

## 🎯 GİRİŞ

**Telerik Kendo UI = 120+ Hazır Bileşen**

**Ne demek bu?**
- ✅ Hazır kodlar → Sen sadece kullanıyorsun
- ✅ Profesyonel görünüm → Otomatik güzel görünür
- ✅ Kolay kullanım → 1-2 satır kod yeter

**Örnek:**
```javascript
// Normal HTML buton (50 satır CSS gerekir)
<button>Bas</button>

// Telerik Button (1 satır kod)
$("#buton").kendoButton();
// → Otomatik güzel görünür, hover efekti var, profesyonel!
```

---

## 📋 BİLEŞEN KATEGORİLERİ

### 1. VERİ YÖNETİMİ (Data Management) - 15 Bileşen

#### ✅ GRID (Tablo) - KULLANIYORUZ!
**Ne işe yarar:** Tablo yapmak için

**Projemizde:**
- `motorin-grid` - Motorin satış tablosu
- `benzin-grid` - Benzin satış tablosu
- `tahsilat-grid` - Tahsilat kayıtları
- `odeme-grid` - Ödeme kayıtları

**Kolay Örnek:**
```javascript
// Basit tablo oluştur
$("#tablo").kendoGrid({
  dataSource: {
    data: [
      { ad: "YAĞCILAR", miktar: 100000 },
      { ad: "TEPEKUM", miktar: 100000 }
    ]
  },
  columns: [
    { field: "ad", title: "Şube" },
    { field: "miktar", title: "Miktar" }
  ]
});
// → Otomatik: Sıralama, filtreleme, sayfalama!
```

---

#### 📊 PIVOTGRID (Özet Tablo)
**Ne işe yarar:** Excel PivotTable gibi özet tablo

**Projemizde kullanılabilir:**
- Satış analizi (şube bazında, ürün bazında)

**Kolay Örnek:**
```javascript
// Özet tablo oluştur
$("#ozet").kendoPivotGrid({
  dataSource: {
    data: satisVerileri,
    columns: [{ name: "sube" }],  // Sütunlar: Şubeler
    rows: [{ name: "urun" }],     // Satırlar: Ürünler
    measures: ["sum:miktar"]      // Toplam: Miktar
  }
});
// → Otomatik: Şube bazında, ürün bazında toplamlar!
```

---

#### 📁 SPREADSHEET (Excel Benzeri)
**Ne işe yarar:** Excel gibi tablo (formül, hesaplama)

**Projemizde kullanılabilir:**
- Hesaplama tabloları
- Formül kullanımı

**Kolay Örnek:**
```javascript
// Excel benzeri tablo
$("#excel").kendoSpreadsheet({
  sheets: [{
    name: "Satışlar",
    rows: [{
      cells: [
        { value: "Miktar" },
        { value: "Fiyat" },
        { formula: "A1*B1" }  // Otomatik hesaplama!
      ]
    }]
  }]
});
// → Excel gibi formül yazabilirsin!
```

---

#### 🌳 TREELIST (Hiyerarşik Tablo)
**Ne işe yarar:** Kategori + alt kategori tablosu

**Projemizde kullanılabilir:**
- Şube + alt şubeler
- Kategori yapısı

**Kolay Örnek:**
```javascript
// Hiyerarşik tablo
$("#agac-tablo").kendoTreeList({
  dataSource: {
    data: [
      { id: 1, ad: "YAĞCILAR", parentId: null },
      { id: 2, ad: "Alt Şube 1", parentId: 1 },
      { id: 3, ad: "Alt Şube 2", parentId: 1 }
    ]
  },
  columns: [
    { field: "ad", title: "Şube" }
  ]
});
// → Otomatik: Açılır/kapanır yapı!
```

---

#### 📋 LISTVIEW (Liste Görünümü)
**Ne işe yarar:** Kart görünümü (Instagram gibi)

**Projemizde kullanılabilir:**
- Firma kartları
- Ürün kartları

**Kolay Örnek:**
```javascript
// Kart görünümü
$("#kartlar").kendoListView({
  dataSource: {
    data: [
      { ad: "YAĞCILAR", miktar: 100000 },
      { ad: "TEPEKUM", miktar: 100000 }
    ]
  },
  template: "<div class='kart'>#: ad # - #: miktar #</div>"
});
// → Otomatik: Güzel kart görünümü!
```

---

### 2. NAVİGASYON (Navigation) - 12 Bileşen

#### ✅ MENU (Menü) - KULLANIYORUZ!
**Ne işe yarar:** Açılır menü yapmak için

**Projemizde:**
- `top-menu-bar` - En üst menü (Tanımlar, Kartlar)

**Kolay Örnek:**
```javascript
// Menü oluştur
$("#menu").kendoMenu({
  dataSource: [
    {
      text: "Tanımlar",
      items: [
        { text: "Firmalar" },
        { text: "Ürünler" }
      ]
    },
    { text: "Kartlar" }
  ]
});
// → Otomatik: Açılır menü, hover efekti!
```

---

#### ✅ TABSTRIP (Sekmeler) - KULLANIYORUZ!
**Ne işe yarar:** Tab (sekme) yapmak için

**Projemizde:**
- `#tabs` - ALAN 3'teki tab sistemi

**Kolay Örnek:**
```javascript
// Tab oluştur
$("#tablar").kendoTabStrip({
  items: [
    { text: "Operasyon", content: "İçerik 1" },
    { text: "Banka", content: "İçerik 2" }
  ]
});
// → Otomatik: Tab açma/kapama, aktif tab gösterimi!
```

---

#### 🌳 TREEVIEW (Ağaç Görünümü)
**Ne işe yarar:** Klasör yapısı gibi liste

**Projemizde kullanılabilir:**
- Şube hiyerarşisi
- Kategori yapısı

**Kolay Örnek:**
```javascript
// Ağaç görünümü
$("#agac").kendoTreeView({
  dataSource: [
    {
      text: "YAĞCILAR",
      items: [
        { text: "Alt Şube 1" },
        { text: "Alt Şube 2" }
      ]
    }
  ]
});
// → Otomatik: Açılır/kapanır, + / - işaretleri!
```

---

#### 📑 PANELBAR (Panel Çubuğu)
**Ne işe yarar:** Açılır/kapanır paneller

**Projemizde kullanılabilir:**
- Detay panelleri
- Ayarlar paneli

**Kolay Örnek:**
```javascript
// Panel çubuğu
$("#paneller").kendoPanelBar({
  items: [
    {
      text: "Motorin Detayları",
      content: "Motorin bilgileri burada..."
    },
    {
      text: "Benzin Detayları",
      content: "Benzin bilgileri burada..."
    }
  ]
});
// → Otomatik: Açılır/kapanır paneller!
```

---

#### 🍞 BREADCRUMB (Ekmek Kırıntısı)
**Ne işe yarar:** Sayfa yolu gösterme (Ana Sayfa > Şubeler > YAĞCILAR)

**Projemizde kullanılabilir:**
- Sayfa navigasyonu
- Hangi sayfada olduğunu gösterme

**Kolay Örnek:**
```javascript
// Ekmek kırıntısı
$("#yol").kendoBreadcrumb({
  items: [
    { text: "Ana Sayfa", href: "/" },
    { text: "Şubeler", href: "/subeler" },
    { text: "YAĞCILAR" }
  ]
});
// → Otomatik: Tıklanabilir yol gösterimi!
```

---

### 3. DÜZENLEYİCİLER (Editors) - 20 Bileşen

#### 📅 DATEPICKER (Tarih Seçici)
**Ne işe yarar:** Takvimden tarih seçme

**Projemizde kullanılabilir:**
- Satış tarihi seçimi
- Rapor tarih aralığı

**Kolay Örnek:**
```javascript
// Tarih seçici
$("#tarih").kendoDatePicker({
  culture: "tr-TR",
  format: "dd/MM/yyyy",
  value: new Date()
});
// → Otomatik: Takvim açılır, Türkçe tarih!
```

---

#### 📅 DATETIMEPICKER (Tarih + Saat Seçici)
**Ne işe yarar:** Tarih + saat seçme

**Projemizde kullanılabilir:**
- Randevu tarihi + saati
- İşlem zamanı

**Kolay Örnek:**
```javascript
// Tarih + saat seçici
$("#tarih-saat").kendoDateTimePicker({
  culture: "tr-TR",
  format: "dd/MM/yyyy HH:mm"
});
// → Otomatik: Takvim + saat seçimi!
```

---

#### 📋 COMBOBOX (Dropdown Liste)
**Ne işe yarar:** Açılır listeden seçim

**Projemizde kullanılabilir:**
- Şube seçimi
- Ürün seçimi
- Banka seçimi

**Kolay Örnek:**
```javascript
// Dropdown liste
$("#sube").kendoComboBox({
  dataSource: ["YAĞCILAR", "TEPEKUM", "NAMDAR", "ŞEKER"],
  placeholder: "Şube seçin..."
});
// → Otomatik: Açılır liste, arama özelliği!
```

---

#### 🔍 AUTOCOMPLETE (Otomatik Tamamlama)
**Ne işe yarar:** Yazarken otomatik öneri

**Projemizde kullanılabilir:**
- Firma adı arama
- Ürün adı arama

**Kolay Örnek:**
```javascript
// Otomatik tamamlama
$("#firma-ara").kendoAutoComplete({
  dataSource: ["Aria Petrol", "Namdar Petrol", "Aygaz"],
  filter: "contains",
  placeholder: "Firma ara..."
});
// → Otomatik: Yazarken öneriler gelir!
```

---

#### 🔢 NUMERICTEXTBOX (Sayı Girişi)
**Ne işe yarar:** Sadece sayı girişi (metin yok)

**Projemizde kullanılabilir:**
- Miktar girişi (litre)
- Fiyat girişi (TL)
- Kapasite girişi

**Kolay Örnek:**
```javascript
// Sayı girişi
$("#miktar").kendoNumericTextBox({
  format: "n2",      // 2 ondalık
  decimals: 2,
  min: 0,
  max: 1000000
});
// → Otomatik: Sadece sayı kabul eder, min/max kontrolü!
```

---

#### 📝 EDITOR (Metin Editörü)
**Ne işe yarar:** Word benzeri metin düzenleme

**Projemizde kullanılabilir:**
- Notlar
- Açıklamalar
- Rapor metinleri

**Kolay Örnek:**
```javascript
// Metin editörü
$("#notlar").kendoEditor({
  tools: [
    "bold", "italic", "underline",
    "foreColor", "backColor"
  ]
});
// → Otomatik: Kalın, italik, renk seçimi!
```

---

#### 🎨 COLORPICKER (Renk Seçici)
**Ne işe yarar:** Renk seçme (palet)

**Projemizde kullanılabilir:**
- Özel renk seçimi
- Tema renkleri

**Kolay Örnek:**
```javascript
// Renk seçici
$("#renk").kendoColorPicker({
  value: "#ff0000",
  buttons: true
});
// → Otomatik: Renk paleti açılır!
```

---

#### 🎚️ SLIDER (Kaydırıcı)
**Ne işe yarar:** Değer seçme (kaydırarak)

**Projemizde kullanılabilir:**
- Filtreleme (min/max değer)
- Ayar değerleri

**Kolay Örnek:**
```javascript
// Kaydırıcı
$("#deger").kendoSlider({
  min: 0,
  max: 100,
  value: 50,
  smallStep: 1,
  largeStep: 10
});
// → Otomatik: Kaydırarak değer seçimi!
```

---

#### ⭐ RATING (Değerlendirme)
**Ne işe yarar:** Yıldız değerlendirme (1-5 yıldız)

**Projemizde kullanılabilir:**
- Müşteri değerlendirmesi
- Ürün puanlama

**Kolay Örnek:**
```javascript
// Yıldız değerlendirme
$("#puan").kendoRating({
  min: 1,
  max: 5,
  value: 3
});
// → Otomatik: Yıldız tıklama, görsel!
```

---

#### 🔐 MASKEDTEXTBOX (Maskeli Metin)
**Ne işe yarar:** Belirli formatta metin (telefon, TC)

**Projemizde kullanılabilir:**
- Telefon numarası (555-123-4567)
- TC Kimlik No (12345678901)
- Kart numarası

**Kolay Örnek:**
```javascript
// Maskeli metin
$("#telefon").kendoMaskedTextBox({
  mask: "000-000-0000",
  value: "5551234567"
});
// → Otomatik: Format kontrolü, sadece sayı!
```

---

#### 📋 MULTISELECT (Çoklu Seçim)
**Ne işe yarar:** Birden fazla seçim

**Projemizde kullanılabilir:**
- Filtreleme (birden fazla şube)
- Kategori seçimi

**Kolay Örnek:**
```javascript
// Çoklu seçim
$("#subeler").kendoMultiSelect({
  dataSource: ["YAĞCILAR", "TEPEKUM", "NAMDAR"],
  placeholder: "Şube seçin..."
});
// → Otomatik: Birden fazla seçim, görsel!
```

---

### 4. VERİ GÖRSELLEŞTİRME (Data Visualization) - 10 Bileşen

#### 📊 CHART (Grafikler)
**Ne işe yarar:** Grafik çizme (çubuk, çizgi, pasta)

**Projemizde kullanılabilir:**
- Satış grafikleri
- İstatistik görselleştirme

**Kolay Örnek:**
```javascript
// Çubuk grafik
$("#grafik").kendoChart({
  dataSource: {
    data: [
      { sube: "YAĞCILAR", satis: 100000 },
      { sube: "TEPEKUM", satis: 100000 },
      { sube: "NAMDAR", satis: 29000 }
    ]
  },
  series: [{
    type: "column",  // Çubuk grafik
    field: "satis",
    categoryField: "sube"
  }]
});
// → Otomatik: Güzel grafik, renkler, etiketler!
```

**Grafik Türleri:**
- `column` - Çubuk grafik
- `line` - Çizgi grafik
- `pie` - Pasta grafik
- `area` - Alan grafik
- `bar` - Yatay çubuk

---

#### 📈 GAUGE (Gösterge)
**Ne işe yarar:** Dairesel/doğrusal gösterge

**Projemizde kullanılabilir:**
- Kapasite göstergesi
- İlerleme göstergesi

**Kolay Örnek:**
```javascript
// Dairesel gösterge
$("#gosterge").kendoCircularGauge({
  value: 75,
  min: 0,
  max: 100
});
// → Otomatik: Dairesel gösterge, renkli!
```

---

#### 🗺️ MAP (Harita)
**Ne işe yarar:** Harita gösterimi

**Projemizde kullanılabilir:**
- Şube konumları
- Müşteri konumları

**Kolay Örnek:**
```javascript
// Harita
$("#harita").kendoMap({
  center: [39.9, 32.8],  // Ankara koordinatları
  zoom: 10,
  layers: [{
    type: "tile",
    urlTemplate: "https://..."
  }]
});
// → Otomatik: Harita, zoom, işaretleme!
```

---

### 5. BİLDİRİMLER VE DİĞERLERİ - 15 Bileşen

#### 🔔 NOTIFICATION (Bildirimler)
**Ne işe yarar:** Başarı/hata mesajları

**Projemizde kullanılabilir:**
- Kayıt başarılı mesajı
- Hata mesajları

**Kolay Örnek:**
```javascript
// Bildirim göster
var notification = $("#bildirim").kendoNotification().data("kendoNotification");
notification.show("Kayıt başarıyla eklendi!", "success");
notification.show("Hata oluştu!", "error");
notification.show("Bilgi", "info");
// → Otomatik: Güzel bildirim, otomatik kapanma!
```

---

#### ✅ PROGRESSBAR (İlerleme Çubuğu)
**Ne işe yarar:** Yükleme durumu gösterme

**Projemizde kullanılabilir:**
- Excel yükleme
- Veri yükleme

**Kolay Örnek:**
```javascript
// İlerleme çubuğu
$("#yukleme").kendoProgressBar({
  value: 0,
  max: 100
});

// İlerleme güncelle
var progressBar = $("#yukleme").data("kendoProgressBar");
progressBar.value(50);  // %50 tamamlandı
// → Otomatik: Görsel ilerleme çubuğu!
```

---

#### ✅ WINDOW (Pencere) - KULLANIYORUZ!
**Ne işe yarar:** Popup pencere

**Projemizde:**
- `#firma-window` - Firma yönetimi penceresi
- `#urun-window` - Ürün yönetimi penceresi

**Kolay Örnek:**
```javascript
// Pencere oluştur
$("#pencere").kendoWindow({
  title: "Detaylar",
  width: 600,
  height: 400,
  modal: true,
  visible: false
});

// Pencereyi aç
var window = $("#pencere").data("kendoWindow");
window.center().open();
// → Otomatik: Güzel pencere, kapatma, taşıma!
```

---

#### 📤 UPLOAD (Dosya Yükleme)
**Ne işe yarar:** Dosya seçme ve yükleme

**Projemizde kullanılabilir:**
- Excel yükleme
- Resim yükleme

**Kolay Örnek:**
```javascript
// Dosya yükleme
$("#dosya-yukle").kendoUpload({
  async: {
    saveUrl: "/api/upload/",
    removeUrl: "/api/remove/"
  },
  multiple: true
});
// → Otomatik: Dosya seçme, yükleme, ilerleme!
```

---

#### 🎯 TOOLTIP (İpucu)
**Ne işe yarar:** Hover'da ipucu gösterme

**Projemizde kullanılabilir:**
- Buton açıklamaları
- Form alan açıklamaları

**Kolay Örnek:**
```javascript
// İpucu
$("#buton").kendoTooltip({
  content: "Bu butona tıklayınca kayıt eklenir"
});
// → Otomatik: Hover'da ipucu gösterir!
```

---

#### 🎨 FLATCOLORPICKER (Düz Renk Seçici)
**Ne işe yarar:** Renk seçme (düz palet)

**Projemizde kullanılabilir:**
- Tema renkleri
- Özel renkler

**Kolay Örnek:**
```javascript
// Düz renk seçici
$("#renk").kendoFlatColorPicker({
  value: "#ff0000"
});
// → Otomatik: Renk paleti!
```

---

### 6. FORM BİLEŞENLERİ - 10 Bileşen

#### ✅ BUTTON (Buton) - KULLANIYORUZ!
**Ne işe yarar:** Profesyonel buton

**Projemizde:**
- Ribbon butonları (ALAN 2)
- Form butonları

**Kolay Örnek:**
```javascript
// Buton oluştur
$("#buton").kendoButton({
  content: "Kaydet",
  icon: "save"
});
// → Otomatik: Güzel buton, hover efekti!
```

---

#### 📋 DROPDOWNLIST (Dropdown Liste)
**Ne işe yarar:** Açılır liste (sadece seçim)

**Projemizde kullanılabilir:**
- Şube seçimi
- Durum seçimi

**Kolay Örnek:**
```javascript
// Dropdown liste
$("#liste").kendoDropDownList({
  dataSource: ["Aktif", "Pasif"],
  value: "Aktif"
});
// → Otomatik: Açılır liste!
```

---

#### 📋 LISTBOX (Liste Kutusu)
**Ne işe yarar:** Liste seçimi (çoklu)

**Projemizde kullanılabilir:**
- Çoklu seçim
- Filtreleme

**Kolay Örnek:**
```javascript
// Liste kutusu
$("#liste").kendoListBox({
  dataSource: ["YAĞCILAR", "TEPEKUM", "NAMDAR"],
  selectable: "multiple"
});
// → Otomatik: Çoklu seçim, görsel!
```

---

### 7. DİĞER BİLEŞENLER - 40+ Bileşen

#### 📅 CALENDAR (Takvim)
**Ne işe yarar:** Takvim görünümü

**Projemizde kullanılabilir:**
- Tarih seçimi
- Randevu takvimi

**Kolay Örnek:**
```javascript
// Takvim
$("#takvim").kendoCalendar({
  value: new Date(),
  culture: "tr-TR"
});
// → Otomatik: Türkçe takvim!
```

---

#### 📅 SCHEDULER (Planlayıcı)
**Ne işe yarar:** Randevu/planlama takvimi

**Projemizde kullanılabilir:**
- Randevu takvimi
- Görev planlama

**Kolay Örnek:**
```javascript
// Planlayıcı
$("#planlayici").kendoScheduler({
  date: new Date(),
  dataSource: [
    {
      id: 1,
      title: "Toplantı",
      start: new Date("2024-01-15T10:00"),
      end: new Date("2024-01-15T11:00")
    }
  ]
});
// → Otomatik: Takvim görünümü, randevu ekleme!
```

---

#### 📊 GANTT (Gantt Çizelgesi)
**Ne işe yarar:** Proje yönetimi çizelgesi

**Projemizde kullanılabilir:**
- Proje planlama
- Görev takibi

**Kolay Örnek:**
```javascript
// Gantt çizelgesi
$("#gantt").kendoGantt({
  dataSource: [
    {
      id: 1,
      title: "Görev 1",
      start: new Date("2024-01-01"),
      end: new Date("2024-01-05")
    }
  ]
});
// → Otomatik: Gantt çizelgesi, zaman çizelgesi!
```

---

#### 🗂️ FILEMANAGER (Dosya Yöneticisi)
**Ne işe yarar:** Dosya yönetimi (Windows Explorer gibi)

**Projemizde kullanılabilir:**
- Dosya yönetimi
- Rapor dosyaları

**Kolay Örnek:**
```javascript
// Dosya yöneticisi
$("#dosyalar").kendoFileManager({
  dataSource: {
    transport: {
      read: "/api/files/"
    }
  }
});
// → Otomatik: Dosya listesi, klasör yapısı!
```

---

#### 🔍 FILTER (Filtre)
**Ne işe yarar:** Gelişmiş filtreleme aracı

**Projemizde kullanılabilir:**
- Gelişmiş filtreleme
- Rapor filtreleri

**Kolay Örnek:**
```javascript
// Filtre
$("#filtre").kendoFilter({
  dataSource: {
    data: satisVerileri
  },
  fields: [
    { name: "sube", type: "string" },
    { name: "miktar", type: "number" }
  ]
});
// → Otomatik: Filtre oluşturma, görsel!
```

---

## 📊 TÜM BİLEŞENLER ÖZET TABLOSU

| Kategori | Bileşen Sayısı | Örnekler |
|----------|---------------|----------|
| **Veri Yönetimi** | 15 | Grid, PivotGrid, Spreadsheet, TreeList |
| **Navigasyon** | 12 | Menu, TabStrip, TreeView, PanelBar |
| **Düzenleyiciler** | 20 | DatePicker, ComboBox, Editor, NumericTextBox |
| **Veri Görselleştirme** | 10 | Chart, Gauge, Map |
| **Bildirimler** | 15 | Notification, ProgressBar, Window, Upload |
| **Form Bileşenleri** | 10 | Button, DropDownList, ListBox |
| **Diğerleri** | 40+ | Calendar, Scheduler, Gantt, FileManager |
| **TOPLAM** | **120+** | **Tüm bileşenler dahil!** |

---

## 💡 KOLAY KULLANIM ÖRNEKLERİ

### Örnek 1: Tarih Seçici + Dropdown Liste
```javascript
// Tarih seçici
$("#tarih").kendoDatePicker({
  culture: "tr-TR",
  format: "dd/MM/yyyy"
});

// Şube seçici
$("#sube").kendoComboBox({
  dataSource: ["YAĞCILAR", "TEPEKUM", "NAMDAR"],
  placeholder: "Şube seçin..."
});
```

### Örnek 2: Grafik + Bildirim
```javascript
// Satış grafiği
$("#grafik").kendoChart({
  dataSource: { data: satisVerileri },
  series: [{ type: "column", field: "satis" }]
});

// Başarı bildirimi
var notification = $("#bildirim").kendoNotification().data("kendoNotification");
notification.show("Grafik yüklendi!", "success");
```

### Örnek 3: Dosya Yükleme + İlerleme Çubuğu
```javascript
// Dosya yükleme
$("#dosya-yukle").kendoUpload({
  async: {
    saveUrl: "/api/upload/",
    upload: function(e) {
      // İlerleme güncelle
      var progressBar = $("#yukleme").data("kendoProgressBar");
      progressBar.value(e.percentComplete);
    }
  }
});

// İlerleme çubuğu
$("#yukleme").kendoProgressBar({
  value: 0,
  max: 100
});
```

---

## 🎯 SONUÇ

### Şu An Kullandıklarımız:
1. ✅ **Grid** - 6 adet tablo
2. ✅ **Menu** - 1 adet menü
3. ✅ **TabStrip** - 1 adet tab sistemi
4. ✅ **Button** - 10+ adet buton
5. ✅ **Window** - 2 adet pencere

### Kullanılabilir Ama Henüz Kullanmadıklarımız:
- **DatePicker** - Tarih seçimi
- **ComboBox** - Dropdown liste
- **Chart** - Grafikler
- **Notification** - Bildirimler
- **Upload** - Dosya yükleme
- **Ve 110+ bileşen daha!**

### Nasıl Kullanılır?
1. HTML'de `<div>` oluştur: `<div id="ornek"></div>`
2. JavaScript'te bileşeni başlat: `$("#ornek").kendoBileşenAdı({ ... });`
3. Hazır! Otomatik güzel görünür! 🎉

---

**Özet:** 120+ bileşen var, hepsi kullanılabilir! Sadece kod yazmamız gerekiyor. Her bileşen 1-2 satır kod ile çalışır! 🚀
