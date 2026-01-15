# Telerik Kendo UI Menu - Yazıların Sol Hizalaması Sorunu

## Sorun Açıklaması

Telerik Kendo UI Menu bileşeninde alt menü öğelerinde yazıların sol hizalaması çalışmıyor. Dikey ortalama (`align-items: center`) çalışıyor ama yazıların sol baştan başlaması için yatay hizalama çalışmıyor.

## Teknik Detaylar

- **Kullanılan Framework:** Django
- **Kullanılan UI Kütüphanesi:** Telerik Kendo UI (jQuery tabanlı)
- **Sorun:** Alt menü öğelerinde yazılar dikey olarak ortalanıyor ama sol baştan başlamıyor
- **Beklenen Davranış:** Yazılar hem dikey olarak ortalanmalı hem de sol baştan başlamalı (ilk harfler alt alta)
- **Gerçekleşen Davranış:** Yazılar dikey olarak ortalanıyor ama yatayda ortalanmış görünüyor

## HTML Yapısı

Telerik Kendo UI Menu şu HTML yapısını oluşturuyor:

```html
<li class="k-item k-menu-item">
  <span class="k-link">
    <span class="k-menu-item-text">Firma Tanımları</span>
  </span>
</li>
```

## Denenen Çözümler

### 1. CSS ile Çözüm Denemeleri

**Denenen CSS Kuralları:**

```css
/* li elementi için - dikey ortalama çalışıyor */
#ana-menu-bar .k-menu-group .k-menu-item {
  padding: 0 20px 0 25px !important;
  min-height: 28px !important;
  line-height: 28px !important;
  display: flex !important;
  align-items: center !important; /* Dikey ortalama - ÇALIŞIYOR */
  justify-content: flex-start !important; /* Sol hizalama - ÇALIŞMIYOR */
}

/* .k-link için - dikey ortalama çalışıyor */
#ana-menu-bar .k-menu-group .k-link {
  display: flex !important;
  align-items: center !important; /* Dikey ortalama - ÇALIŞIYOR */
  justify-content: flex-start !important; /* Sol hizalama - ÇALIŞMIYOR */
  text-align: left !important; /* ÇALIŞMIYOR */
  padding-left: 0 !important;
  margin-left: 0 !important;
}

/* .k-menu-item-text için */
#ana-menu-bar .k-menu-group .k-menu-item-text {
  text-align: left !important; /* ÇALIŞMIYOR */
  flex: 0 0 auto !important;
  align-self: flex-start !important; /* ÇALIŞMIYOR */
}
```

**Sonuç:** Dikey ortalama çalışıyor ama yazılar hala ortalanmış görünüyor.

### 2. JavaScript ile Çözüm Denemeleri

**Denenen JavaScript Kodu:**

```javascript
// .k-link için
kLink.style.setProperty('display', 'flex', 'important');
kLink.style.setProperty('align-items', 'center', 'important'); // ÇALIŞIYOR
kLink.style.setProperty('justify-content', 'flex-start', 'important'); // ÇALIŞMIYOR
kLink.style.setProperty('text-align', 'left', 'important'); // ÇALIŞMIYOR

// .k-menu-item-text için
text.style.setProperty('text-align', 'left', 'important'); // ÇALIŞMIYOR
text.style.setProperty('flex', '0 0 auto', 'important');
text.style.setProperty('align-self', 'flex-start', 'important'); // ÇALIŞMIYOR
```

**Sonuç:** JavaScript ile de çalışmıyor.

### 3. Padding/Margin Kontrolü

Tüm padding ve margin değerleri kontrol edildi:

```css
#ana-menu-bar .k-menu-group .k-link,
#ana-menu-bar .k-menu-group .k-menu-item-text {
  padding-left: 0 !important;
  padding-right: 0 !important;
  margin-left: 0 !important;
  margin-right: 0 !important;
}
```

**Sonuç:** Padding/margin sorunu değil.

## Sorunun Muhtemel Nedenleri

1. **Telerik'in Inline Style'ları:** Telerik runtime'da inline style'lar ekliyor olabilir ve bunlar CSS'i override ediyor
2. **CSS Specificity:** Telerik'in CSS kuralları bizim kurallarımızdan daha spesifik olabilir
3. **Flexbox Çakışması:** `.k-link` için `display: flex` kullanıyoruz (dikey ortalama için), ama bu yatay hizalamayı etkiliyor olabilir
4. **Text Alignment:** Flexbox içinde `text-align` çalışmayabilir
5. **Telerik'in Kendi Flexbox Kuralları:** Telerik kendi flexbox kurallarını uyguluyor olabilir

## Mevcut Durum

- ✅ Dikey ortalama çalışıyor (`align-items: center`)
- ✅ Sarı hover efekti çalışıyor
- ✅ Mavi sol çizgi çalışıyor
- ❌ Yazıların sol hizalaması çalışmıyor
- ❌ İlk harfler alt alta başlamıyor

## İstenen Çözüm

Alt menü öğelerinde yazılar:
1. Dikey olarak ortalanmalı (şu anda çalışıyor)
2. Sol baştan başlamalı (şu anda çalışmıyor)
3. İlk harfler alt alta olmalı (şu anda çalışmıyor)

## Ek Bilgiler

- Telerik Kendo UI versiyonu: `kendo.all.min.js`
- jQuery versiyonu: 3.6.0
- Tarayıcı: Chrome (Windows 10)
- Menü yapılandırması: `horizontal` orientation, `openOnClick: false`, `highlightFirst: false`

## Kod Örnekleri

Tüm kod `dashboard/templates/dashboard/base.html` dosyasında bulunuyor. CSS kuralları `<style>` tag'i içinde, JavaScript kodu `$(document).ready()` içinde.

## Soru

Telerik Kendo UI Menu'de alt menü öğelerinde yazıları hem dikey olarak ortalayıp hem de sol baştan başlatmak için ne yapmalıyız? Flexbox ile dikey ortalama çalışıyor ama yatay hizalama çalışmıyor. `justify-content: flex-start`, `text-align: left`, `align-self: flex-start` gibi tüm yöntemleri denedik ama çalışmadı.

## Ekran Görüntüsü

Menü açıldığında yazılar dikey olarak ortalanmış görünüyor ama yatayda ortalanmış görünüyor. İlk harfler (F, Ü, E) alt alta başlamıyor.
