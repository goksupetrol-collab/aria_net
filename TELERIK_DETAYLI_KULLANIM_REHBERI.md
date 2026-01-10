# TELERİK DETAYLI KULLANIM REHBERİ

> **Bu dosya, Telerik dokümantasyonlarından çıkarılan detaylı kullanım örnekleri, API'ler ve özellikleri içerir.**

## 📚 İNCELENEN DOKÜMANTASYONLAR

1. **Kendo UI for jQuery** - 120+ bileşen (Bizim kullandığımız)
2. **ASP.NET Core** - 110+ bileşen (Server-side wrappers)
3. **ASP.NET AJAX** - 120+ bileşen
4. **WPF** - 160+ bileşen
5. **WinForms** - 160+ bileşen
6. **WinUI** - WinUI 3 bileşenleri
7. **.NET MAUI** - 60+ bileşen
8. **Test Studio** - Test otomasyonu

---

## 🎯 KENDO UI FOR JQUERY - DETAYLI KULLANIM

### 1. MENU (kendoMenu)

#### HTML Yapısı ile Kullanım (ÖNERİLEN)
```html
<ul id="menu">
    <li>Item 1
        <ul>
            <li>Sub Item 1</li>
            <li>Sub Item 2</li>
        </ul>
    </li>
    <li>Item 2</li>
</ul>

<script>
$(document).ready(function() {
    $("#menu").kendoMenu({
        orientation: "horizontal",  // veya "vertical"
        openOnClick: false,          // Tıklamada açılır mı?
        animation: false,            // Animasyon var mı?
        select: function(e) {
            var itemText = $(e.item).text();
            console.log("Seçilen:", itemText);
        }
    });
});
</script>
```

#### DataSource ile Kullanım
```javascript
$("#menu").kendoMenu({
    dataSource: [
        {
            text: "Item 1",
            items: [
                { text: "Sub Item 1" },
                { text: "Sub Item 2" }
            ]
        },
        { text: "Item 2" }
    ]
});
```

#### Programatik Kontrol
```javascript
var menu = $("#menu").kendoMenu().data("kendoMenu");

// Menü öğesini devre dışı bırak
menu.enable("#item2", false);

// Menü öğesini etkinleştir
menu.enable("#item2", true);
```

**API Referansı:**
- https://www.telerik.com/kendo-jquery-ui/documentation/api/javascript/ui/menu

---

### 2. GRID (kendoGrid)

#### Temel Kullanım
```html
<div id="grid"></div>

<script>
$(document).ready(function() {
    $("#grid").kendoGrid({
        dataSource: {
            data: [
                { Name: "Jane Doe", Age: 30 },
                { Name: "John Doe", Age: 33 }
            ],
            schema: {
                model: {
                    fields: {
                        Name: { type: "string" },
                        Age: { type: "number" }
                    }
                }
            },
            pageSize: 10
        },
        height: 400,
        sortable: true,        // Sıralama aktif
        pageable: true,        // Sayfalama aktif
        filterable: true,      // Filtreleme aktif
        editable: {
            mode: "incell",    // Hücre içinde düzenleme
            update: true
        },
        columns: [
            { field: "Name", title: "İsim" },
            { field: "Age", title: "Yaş" }
        ]
    });
});
</script>
```

#### Grid Olayları (Events)
```javascript
$("#grid").kendoGrid({
    dataSource: { /* ... */ },
    edit: function(e) {
        // Düzenleme başladığında
        console.log("Düzenleme başladı");
    },
    save: function(e) {
        // Kaydetme sırasında
        console.log("Kaydediliyor:", e.model);
    },
    dataBound: function(e) {
        // Veri yüklendikten sonra
        console.log("Veri yüklendi");
    }
});
```

**API Referansı:**
- https://www.telerik.com/kendo-jquery-ui/documentation/api/javascript/ui/grid
- Demo: https://demos.telerik.com/kendo-ui/grid/api

---

### 3. TOOLBAR (kendoToolbar)

#### Temel Kullanım
```html
<div id="toolbar"></div>

<script>
$("#toolbar").kendoToolBar({
    items: [
        { type: "button", text: "Buton" },
        { type: "button", text: "Toggle", togglable: true },
        { 
            type: "splitButton", 
            text: "SplitButton", 
            menuButtons: [
                { text: "Seçenek 1" }, 
                { text: "Seçenek 2" }
            ]
        }
    ]
});
</script>
```

#### Özel Araçlar (Custom Tools)
```javascript
$("#toolbar").kendoToolBar({
    items: [
        { 
            template: '<input id="dropdownlist" />', 
            overflow: "never"  // Overflow menüsüne gitmesin
        }
    ]
});

// DropDownList'i ayrıca initialize et
$("#dropdownlist").kendoDropDownList({
    dataSource: [
        { item: "Seçenek 1", value: 1 }, 
        { item: "Seçenek 2", value: 2 }
    ],
    dataTextField: "item",
    dataValueField: "value"
});
```

#### Boyut ve Görünüm
```javascript
$("#toolbar").kendoToolBar({
    size: "small",  // "small", "medium", "large"
    resizable: true,
    items: [
        { type: "button", text: "Buton 1", overflow: "never" },
        { type: "button", text: "Buton 2", overflow: "auto" },
        { type: "button", text: "Buton 3", overflow: "always" }
    ]
});
```

**API Referansı:**
- https://www.telerik.com/kendo-jquery-ui/documentation/api/javascript/ui/toolbar

---

### 4. BUTTON (kendoButton)

#### CSS Sınıfı ile Kullanım (ÖNERİLEN)
```html
<button class="k-button">Tıkla</button>
```

#### JavaScript ile Kullanım
```html
<button id="myButton">Tıkla</button>
<script>
$(document).ready(function() {
    $("#myButton").kendoButton({
        icon: "save",  // İkon ekle
        click: function() {
            alert("Butona tıklandı!");
        }
    });
});
</script>
```

#### İkonlu Buton
```javascript
$("#iconButton").kendoButton({
    icon: "save"  // veya "edit", "delete", vb.
});
```

#### Buton Grubu
```html
<div class="k-button-group">
    <button id="btn1">Buton 1</button>
    <button id="btn2">Buton 2</button>
</div>
<script>
$(document).ready(function() {
    $("#btn1").kendoButton();
    $("#btn2").kendoButton();
});
</script>
```

**CSS Sınıfları:**
- `.k-button` - Temel buton
- `.k-button-md` - Orta boyut
- `.k-button-sm` - Küçük boyut
- `.k-button-lg` - Büyük boyut
- `.k-button-solid` - Dolu buton
- `.k-button-outline` - Çerçeveli buton

---

### 5. DATEPICKER (kendoDatePicker)

```html
<input id="datepicker" />

<script>
$(document).ready(function() {
    $("#datepicker").kendoDatePicker({
        value: new Date(),
        culture: "tr-TR",  // Türkçe
        format: "dd/MM/yyyy",
        change: function() {
            var value = this.value();
            console.log("Seçilen tarih:", kendo.toString(value, 'd'));
        }
    });
});
</script>
```

---

### 6. COMBOBOX (kendoComboBox)

```html
<input id="combobox" />

<script>
$(document).ready(function() {
    $("#combobox").kendoComboBox({
        dataSource: ["Seçenek 1", "Seçenek 2", "Seçenek 3"],
        placeholder: "Bir seçenek seçin...",
        change: function() {
            var value = this.value();
            console.log("Seçilen:", value);
        }
    });
});
</script>
```

---

### 7. NOTIFICATION (kendoNotification)

```html
<div id="notification"></div>
<button id="showNotification">Bildirim Göster</button>

<script>
$(document).ready(function() {
    var notification = $("#notification").kendoNotification().data("kendoNotification");

    $("#showNotification").click(function() {
        notification.show("Bu bir bildirim mesajıdır.", "info");
        // Tip: "info", "success", "warning", "error"
    });
});
</script>
```

**Kullanım Senaryoları:**
- Başarı mesajları: `notification.show("Kayıt başarıyla eklendi", "success");`
- Hata mesajları: `notification.show("Hata oluştu", "error");`
- Bilgi mesajları: `notification.show("Bilgi", "info");`
- Uyarı mesajları: `notification.show("Dikkat!", "warning");`

---

### 8. WINDOW (kendoWindow)

```html
<div id="window">
    <p>Bu bir Kendo UI Window'dur.</p>
</div>
<button id="openWindow">Pencereyi Aç</button>

<script>
$(document).ready(function() {
    var window = $("#window").kendoWindow({
        width: "400px",
        height: "300px",
        title: "Kendo UI Window",
        visible: false,
        modal: true,  // Modal pencere
        actions: ["Pin", "Minimize", "Maximize", "Close"]
    }).data("kendoWindow");

    $("#openWindow").click(function() {
        window.center().open();
    });
});
</script>
```

---

## 📋 TÜM KENDO UI BİLEŞENLERİ (120+)

### Data Management (Veri Yönetimi)
- **Grid** ✅ (Kullanıyoruz)
- **Spreadsheet** - Excel benzeri tablo
- **ListView** - Liste görünümü
- **PivotGrid** - Özet tablo
- **TreeList** - Hiyerarşik grid
- **FileManager** - Dosya yöneticisi
- **Filter** - Filtreleme aracı

### Navigation (Navigasyon)
- **Menu** ✅ (Kullanıyoruz)
- **ToolBar** ✅ (Kullanıyoruz)
- **TabStrip** - Sekmeler
- **TreeView** - Ağaç görünümü
- **PanelBar** - Panel çubuğu
- **Breadcrumb** - Ekmek kırıntısı
- **Drawer** - Yan menü
- **BottomNavigation** - Alt navigasyon

### Editors (Düzenleyiciler)
- **DatePicker** - Tarih seçici
- **DateTimePicker** - Tarih + saat seçici
- **ComboBox** - Dropdown liste
- **AutoComplete** - Otomatik tamamlama
- **NumericTextBox** - Sayı girişi
- **MaskedTextBox** - Maskeli metin kutusu
- **MultiSelect** - Çoklu seçim
- **Editor** - Zengin metin editörü
- **ColorPicker** - Renk seçici
- **Slider** - Kaydırıcı
- **Rating** - Değerlendirme

### Data Visualization (Veri Görselleştirme)
- **Chart** - Grafikler (Area, Bar, Line, Pie, vb.)
- **Gauge** - Gösterge (Circular, Linear, Radial)
- **Map** - Harita
- **Diagram** - Diyagram
- **Sparkline** - Mini grafik
- **TreeMap** - Ağaç haritası

### Layout (Yerleşim)
- **Window** - Pencere
- **Dialog** - Diyalog
- **Splitter** - Bölücü
- **Notification** - Bildirim
- **Tooltip** - İpucu
- **Badge** ✅ (Kullanıyoruz)
- **Avatar** - Profil resmi
- **Cards** - Kartlar

### Scheduling (Zamanlama)
- **Calendar** - Takvim
- **Scheduler** - Planlayıcı
- **Gantt** - Gantt çizelgesi

### Media (Medya)
- **MediaPlayer** - Medya oynatıcı
- **ScrollView** - Kaydırılabilir görünüm

### PDF
- **PDFViewer** - PDF görüntüleyici

---

## 🔧 ASP.NET CORE - SERVER-SIDE WRAPPERS

### HTML Helpers
```csharp
@(Html.Kendo().NumericTextBox()
      .Name("age")
      .Value(10)
      .Spinners(false)
)
```

### Tag Helpers
```html
@addTagHelper *, Kendo.Mvc

<kendo-numerictextbox name="age" value="10" spinners="false"></kendo-numerictextbox>
```

**Not:** Bizim proje Django kullandığı için server-side wrapper'lar kullanılmıyor. Direkt JavaScript/Kendo UI kullanıyoruz.

---

## 🎨 STYLING VE TEMA

### CSS Değişkenleri
```css
/* Telerik CSS değişkenleri */
color: var(--kendo-color-primary);
background: var(--kendo-color-base);
border: 1px solid var(--kendo-color-border);
```

### Tema Dosyası
- **Dosya:** `dashboard/static/dashboard/kendo/styles/default-main.css`
- **Kullanım:** `<link rel="stylesheet" href="{% static 'dashboard/kendo/styles/default-main.css' %}" />`

### CSS Sınıfları
- `.k-button` - Buton
- `.k-menu` - Menü
- `.k-grid` - Grid
- `.k-toolbar` - Toolbar
- `.k-badge` - Badge

---

## 📚 API REFERANSLARI

### Kendo UI for jQuery
- **Ana Dokümantasyon:** https://www.telerik.com/kendo-jquery-ui/documentation
- **API Referansı:** https://www.telerik.com/kendo-jquery-ui/documentation/api/javascript/ui
- **Demos:** https://demos.telerik.com/kendo-ui

### ASP.NET Core
- **Dokümantasyon:** https://www.telerik.com/aspnet-core-ui/documentation/introduction

---

## 💡 ÖNEMLİ NOTLAR

### 1. HTML Yapısı Önemli
- **Menu:** `<ul><li>` formatı kullanılmalı
- **Grid:** `<div>` yeterli
- **Button:** `<button>` veya `<div>` kullanılabilir

### 2. jQuery Gerekli
- Tüm Kendo UI bileşenleri jQuery'ye bağımlı
- jQuery yüklenmeden önce Kendo UI yüklenmemeli

### 3. Kültür Ayarları
```javascript
// Türkçe kültür
<script src="{% static 'dashboard/js/cultures/kendo.culture.tr-TR.min.js' %}"></script>
<script>kendo.culture("tr-TR");</script>
```

### 4. Lisans
- Telerik lisanslı, tüm bileşenler kullanılabilir
- Lisans dosyası: `dashboard/static/dashboard/kendo/telerik-license.js`

---

## 🚀 ÖNERİLER

### Kısa Vadede Eklenebilir
1. **DatePicker** - Tarih seçimi
2. **Notification** - Bildirimler
3. **ComboBox** - Dropdown seçimler

### Orta Vadede Eklenebilir
1. **Chart** - Grafik görselleştirme
2. **Window** - Popup pencereler
3. **TabStrip** - Sekme yapısı

### Uzun Vadede Eklenebilir
1. **PivotGrid** - Analiz tabloları
2. **Scheduler** - Takvim/planlayıcı
3. **Gantt** - Proje yönetimi

---

**Son Güncelleme:** 2025-01-XX
**Kaynak:** Telerik resmi dokümantasyonları
