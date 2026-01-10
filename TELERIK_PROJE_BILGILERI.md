# TELERİK PROJESİ - ÖNEMLİ BİLGİLER

> **Bu dosya, Telerik projesi için kritik bilgileri içerir. Her yeni sohbette bu dosyayı okuyun!**

## 🎯 TEMEL KURALLAR

### 1. SADECE LİSANSLI TELERİK BİLEŞENLERİ KULLANILMALI
- ✅ **Kullanılabilir:** Telerik'in lisanslı bileşenleri (Menu, Grid, Toolbar, Button, Badge, vb.)
- ❌ **Kullanılamaz:** Özel HTML/CSS çözümleri (Telerik bileşeni olmayan)
- 📌 **Kural:** Her şey Telerik'in kendi bileşenleri ve CSS sınıfları ile yapılmalı

### 2. RENK PALETİ
- ❌ **Mavi kullanılmamalı** (kullanıcı tercihi)
- ✅ **Uyumlu renkler:** Gri tonları, açık mavi tonları (#e3f2fd, #90caf9 gibi)
- 🎨 **Telerik CSS değişkenleri:** `var(--kendo-color-...)` kullanılabilir
- 📁 **CSS dosyası:** `dashboard/static/dashboard/kendo/styles/default-main.css`

### 3. MENÜ LAYOUT YAPISI
```
┌─────────────────────────────────────┐
│ [Tanımlar ▼] [Kartlar ▼]          │ ← 2 Açılır Menü (En Üst)
├─────────────────────────────────────┤
│ [⛽] [🚚] [💰]                      │ ← 3 Kompakt İkonlu Buton
├─────────────────────────────────────┤
│ [Sabit 1] [Sabit 2]                │ ← 2 Sabit Öğe
└─────────────────────────────────────┘
```

## 📁 DOSYA KONUMLARI

### Ana Sayfa
- **Dosya:** `dashboard/templates/dashboard/telerik_yeni_proje.html`
- **URL:** `/telerik-yeni-proje/` (muhtemelen)

### Telerik Statik Dosyalar
```
dashboard/static/dashboard/
├── kendo/
│   ├── styles/
│   │   └── default-main.css          ← Ana CSS dosyası
│   ├── js/                            ← Bazı bileşenler burada
│   └── telerik-license.js            ← Lisans dosyası
└── js/
    ├── jquery-3.6.0.min.js           ← jQuery (Telerik için gerekli)
    ├── kendo.all.min.js               ← Tüm Telerik bileşenleri
    └── cultures/
        └── kendo.culture.tr-TR.min.js ← Türkçe kültür
```

### Django Ayarları
- **Settings:** `aria_net/settings.py` veya `tayfun/settings.py`
- **URLs:** `dashboard/urls.py`, `aria_net/urls.py`

## 🔧 TELERİK BİLEŞEN KULLANIMI

### Menu (Açılır Menü)
**✅ DOĞRU KULLANIM:**
```html
<!-- HTML yapısı: <ul><li> formatı -->
<ul id="top-menu-bar">
  <li>
    Tanımlar
    <ul>
      <li>Şube Tanımları</li>
      <li>Ürün Tanımları</li>
    </ul>
  </li>
  <li>
    Kartlar
    <ul>
      <li>Cari Hesap Kartları</li>
    </ul>
  </li>
</ul>

<script>
$("#top-menu-bar").kendoMenu({
  orientation: "horizontal",
  openOnClick: false,
  animation: false
});
</script>
```

**❌ YANLIŞ KULLANIM:**
```javascript
// items array ile - ÇALIŞMAZ!
$("#menu").kendoMenu({
  items: [{ text: "Tanımlar" }]  // ❌ HTML yapısı kullanılmalı
});
```

### Grid
- **Kullanım:** `$("#grid").kendoGrid({ ... })`
- **Özellikler:** Sıralama, filtreleme, sayfalama aktif
- **Editable:** `editable: { mode: "incell" }` (grid seviyesinde)

### Toolbar
- **Kullanım:** `$("#toolbar").kendoToolbar({ ... })`
- **Not:** Eğer `kendoToolbar is not a function` hatası alınırsa, Telerik CSS sınıfları kullanılabilir (`k-button`, `k-toolbar`)

### Button
- **Telerik CSS sınıfları:** `k-button`, `k-button-md`, `k-button-solid`
- **Örnek:** `<div class="k-button k-button-md">Buton</div>`
- **JavaScript:** `$("#button").kendoButton({ icon: "save" })`

### Kullanılabilir Yeni Bileşenler (Henüz Kullanılmıyor)
- **Notification:** `$("#notification").kendoNotification()` - Bildirimler için
- **DatePicker:** `$("#datepicker").kendoDatePicker()` - Tarih seçimi için
- **ComboBox:** `$("#combobox").kendoComboBox()` - Dropdown liste için
- **Window:** `$("#window").kendoWindow()` - Popup pencere için
- **Chart:** `$("#chart").kendoChart()` - Grafikler için
- **TabStrip:** `$("#tabstrip").kendoTabStrip()` - Sekmeler için
- **TreeView:** `$("#treeview").kendoTreeView()` - Ağaç görünümü için

## 🎨 CSS KULLANIMI

### Telerik CSS Değişkenleri
```css
/* Telerik'in kendi CSS değişkenleri */
color: var(--kendo-color-primary);
background: var(--kendo-color-base);
border: 1px solid var(--kendo-color-border);
```

### Telerik CSS Sınıfları
```html
<!-- Button -->
<div class="k-button k-button-md k-button-solid">Buton</div>
<div class="k-button k-button-sm">Küçük Buton</div>
<div class="k-button k-button-lg">Büyük Buton</div>

<!-- Toolbar -->
<div class="k-toolbar">...</div>

<!-- Menu -->
<ul class="k-menu">...</ul>

<!-- Grid -->
<div class="k-grid">...</div>

<!-- Badge -->
<span class="k-badge">...</span>
```

**Button Boyutları:**
- `k-button-sm` - Küçük
- `k-button-md` - Orta (varsayılan)
- `k-button-lg` - Büyük

**Button Stilleri:**
- `k-button-solid` - Dolu buton
- `k-button-outline` - Çerçeveli buton
- `k-button-flat` - Düz buton

### Özel Stil (Sadece Layout İçin)
- ✅ **İzin verilen:** Layout için minimal CSS (position, grid, flexbox)
- ❌ **Yasak:** Telerik bileşenlerinin görünümünü değiştiren özel stiller
- 📌 **Kural:** Telerik bileşenleri kendi stillerini kullanmalı

## 📋 HTML YAPISI (telerik_yeni_proje.html)

### Head Bölümü
```html
<!-- Telerik Kendo UI CSS -->
<link rel="stylesheet" href="{% static 'dashboard/kendo/styles/default-main.css' %}" />

<!-- jQuery (Telerik için gerekli) -->
<script src="{% static 'dashboard/js/jquery-3.6.0.min.js' %}"></script>

<!-- Telerik Kendo UI JavaScript (Tüm bileşenler) -->
<script src="{% static 'dashboard/js/kendo.all.min.js' %}"></script>

<!-- Telerik Türkçe Kültür -->
<script src="{% static 'dashboard/js/cultures/kendo.culture.tr-TR.min.js' %}"></script>
<script>kendo.culture("tr-TR");</script>

<!-- Telerik Lisans -->
<script src="{% static 'dashboard/kendo/telerik-license.js' %}"></script>
```

### Body Yapısı
1. **En Üst:** 2 Açılır Menü (Tanımlar, Kartlar) - `#top-menu-container`
2. **Altında:** 3 Kompakt İkonlu Buton - `#middle-buttons`
3. **Altında:** 2 Sabit Öğe - `#bottom-fixed`
4. **Ana İçerik:** Grid'ler ve paneller

## 🐛 SIK KARŞILAŞILAN HATALAR VE ÇÖZÜMLERİ

### 1. `kendoMenu is not a function`
**Çözüm:**
- jQuery ve `kendo.all.min.js` yüklendiğinden emin olun
- `$(document).ready()` içinde çağırın
- HTML yapısını `<ul><li>` formatında kullanın

### 2. `kendoToolbar is not a function`
**Çözüm:**
- Telerik CSS sınıflarını kullanın: `k-button`, `k-toolbar`
- Veya `kendo.all.min.js` dosyasının yüklendiğini kontrol edin

### 3. `e.editable is not a function` (Grid)
**Çözüm:**
- `editable: true` sütun seviyesinde kullanmayın
- Sadece grid seviyesinde `editable: { mode: "incell" }` kullanın

### 4. Menu Görünmüyor
**Çözüm:**
- HTML yapısını kontrol edin (`<ul><li>` formatı)
- `setTimeout` ile yükleme kontrolü yapın
- Console'da hata var mı kontrol edin

## 🔍 DEBUGGING

### Telerik Yükleme Kontrolü
```javascript
$(document).ready(function() {
  if (typeof kendo !== 'undefined') {
    console.log("✅ Telerik yüklendi!");
    console.log("📦 Bileşenler:", Object.keys(kendo.ui || {}).length);
  } else {
    console.error("❌ Telerik yüklenemedi!");
  }
  
  // Menu kontrolü
  if (typeof $.fn.kendoMenu !== 'undefined') {
    console.log("✅ kendoMenu mevcut!");
  }
});
```

### Kullanılabilir Bileşenleri Listele
```javascript
var components = [];
if (kendo.ui) {
  for (var component in kendo.ui) {
    if (kendo.ui.hasOwnProperty(component) && typeof kendo.ui[component] === 'function') {
      components.push(component);
    }
  }
}
console.log("🔧 Kullanılabilir bileşenler:", components);
```

## 📚 ÖNEMLİ NOTLAR

1. **Lisans:** Telerik lisanslı, bu yüzden tüm bileşenler kullanılabilir
2. **Dil:** Türkçe kültür dosyası yüklü (`tr-TR`)
3. **Tema:** `default-main.css` kullanılıyor
4. **jQuery:** Telerik jQuery'ye bağımlı, mutlaka yüklenmeli
5. **Dokümantasyon:** https://www.telerik.com/aspnet-core-ui/documentation/introduction

## 🔗 API REFERANSLARI

- **Kendo UI for jQuery Ana Dokümantasyon:** https://www.telerik.com/kendo-jquery-ui/documentation
- **Kendo UI API Referansı:** https://www.telerik.com/kendo-jquery-ui/documentation/api/javascript/ui
- **Kendo UI Demos:** https://demos.telerik.com/kendo-ui
- **Menu API:** https://www.telerik.com/kendo-jquery-ui/documentation/api/javascript/ui/menu
- **Grid API:** https://www.telerik.com/kendo-jquery-ui/documentation/api/javascript/ui/grid
- **Toolbar API:** https://www.telerik.com/kendo-jquery-ui/documentation/api/javascript/ui/toolbar

## 🔍 TELERİK ÜRÜN AİLESİ (Bilgi Amaçlı)

### WPF vs ASP.NET AJAX vs Kendo UI - Fark Nedir?

**Telerik WPF:**
- 🖥️ **Ne için:** Windows masaüstü uygulamaları (ör: Excel, Word gibi programlar)
- 💻 **Dil:** C# veya VB.NET + XAML
- 📦 **Kurulum:** Bilgisayara program olarak kurulur
- ❌ **Bizim projede:** KULLANILMIYOR (web projesi olduğu için)

**Telerik ASP.NET AJAX:**
- 🌐 **Ne için:** .NET Framework web uygulamaları (Web Forms)
- 💻 **Dil:** C# / VB.NET (Server-side) + HTML/JavaScript
- 📦 **Kurulum:** .NET Framework 4.6.2 - 4.8.1
- ❌ **Bizim projede:** KULLANILMIYOR (Django kullanıyoruz)

**Kendo UI (Bizim Kullandığımız):**
- 🌐 **Ne için:** Web siteleri/uygulamaları (herhangi bir backend ile)
- 💻 **Dil:** JavaScript, HTML, CSS (Client-side)
- 📦 **Kurulum:** Web sunucusunda çalışır, tarayıcıdan erişilir
- ✅ **Bizim projede:** KULLANILIYOR (Django web projesi)

**Neden Diğer Dokümantasyonları Okumak Yararlı?**
- 🎯 Telerik'in genel yaklaşımını anlamak için (bileşen isimleri, özellikler benzer)
- 📚 Telerik'in tasarım mantığını öğrenmek için
- 🔧 Bileşen özelliklerini karşılaştırmak için (WPF/AJAX'daki özellik Kendo UI'da da olabilir)
- 📋 Kullanılabilir bileşenleri keşfetmek için (120+ ASP.NET AJAX bileşeni)
- ⚠️ **AMA:** Kod örnekleri farklı (WPF = C#/XAML, AJAX = C#/Server-side, Kendo UI = JavaScript)

**Detaylı Bilgi:**
- 📄 **WPF:** `TELERIK_WPF_BILGILERI.md`
- 📄 **ASP.NET AJAX:** `TELERIK_ASPNET_AJAX_BILGILERI.md`

**Örnek:**
- WPF'de: `<telerik:RadMenu>` (XAML)
- Kendo UI'da: `$("#menu").kendoMenu()` (JavaScript)
- **Aynı mantık, farklı dil!**

## 🎯 YENİ ÖZELLİK EKLERKEN

1. ✅ Telerik'in lisanslı bileşenlerini kullan
2. ✅ HTML yapısını doğru formatla (Menu için `<ul><li>`)
3. ✅ Telerik CSS sınıflarını kullan
4. ✅ Renk paletine uy (mavi yok)
5. ✅ Console'da hata kontrolü yap
6. ✅ `$(document).ready()` içinde initialize et

## 📖 DETAYLI KULLANIM ÖRNEKLERİ

**Detaylı kod örnekleri ve kullanım senaryoları için:**
- 📄 **Detaylı Rehber:** `TELERIK_DETAYLI_KULLANIM_REHBERI.md`
- 📄 **ASP.NET AJAX Analizi:** `TELERIK_ASPNET_AJAX_BILGILERI.md`
- 📄 **WPF Bilgileri:** `TELERIK_WPF_BILGILERI.md`

## 📝 GÜNCELLEME GEÇMİŞİ

- **2025-01-XX:** Menu HTML yapısı düzeltildi (`<ul><li>` formatı)
- **2025-01-XX:** Telerik dokümantasyonu incelendi ve uygulandı
- **2025-01-XX:** Renk paleti düzenlendi (mavi kaldırıldı)

---

**Son Güncelleme:** Bu dosya her önemli değişiklikten sonra güncellenmelidir.
