# Telerik Kendo UI Menu - Yazıların Sol Hizalaması Sorunu (Detaylı)

## Sorun Açıklaması

Telerik Kendo UI Menu bileşeninde alt menü öğelerinde yazıların sol hizalaması çalışmıyor. Dikey ortalama (`align-items: center`) çalışıyor ama yazıların sol baştan başlaması için yatay hizalama çalışmıyor. Tüm CSS ve JavaScript çözümleri denendi ama sorun devam ediyor.

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
  <span class="k-link k-menu-link">
    <span class="k-menu-item-text">Firma Tanımları</span>
  </span>
</li>
```

## Mevcut Durum (DevTools Kontrolü)

**Parent `<li>` elementi için:**
- ✅ `display: flex !important` - VAR
- ✅ `align-items: center !important` - VAR (dikey ortalama çalışıyor)
- ✅ `justify-content: flex-start !important` - VAR (ama çalışmıyor)
- ✅ `padding: 0px 20px 0px 25px !important` - VAR

**`.k-link` elementi için:**
- ✅ `display: flex !important` - VAR (bazen `grid` görünüyor)
- ✅ `align-items: center !important` - VAR
- ❌ `justify-content: flex-start` - VAR ama çalışmıyor
- ✅ `text-align: left !important` - VAR ama çalışmıyor
- ✅ `padding-left: 0px !important` - VAR
- ✅ `margin-left: 0px !important` - VAR

**`.k-menu-item-text` elementi için:**
- ✅ `text-align: left !important` - VAR ama çalışmıyor
- ✅ `padding-left: 0px !important` - VAR
- ✅ `margin-left: 0px !important` - VAR

## Denenen Tüm Çözümler

### 1. CSS Specificity Artırma

**Denenen CSS Kuralları:**

```css
/* Çok spesifik selector'lar */
#ana-menu-bar .k-menu-group .k-menu-item > .k-link {
  display: flex !important;
  align-items: center !important;
  justify-content: flex-start !important;
  text-align: left !important;
}

#ana-menu-bar .k-menu-group .k-menu-item > .k-link > .k-menu-item-text {
  text-align: left !important;
  margin-left: 0 !important;
  padding-left: 0 !important;
}
```

**Sonuç:** ❌ Çalışmadı

### 2. Flexbox Kullanımı

**Denenen CSS:**

```css
#ana-menu-bar .k-menu-group li.k-item {
  display: flex !important;
  align-items: center !important;
  justify-content: flex-start !important;
}

#ana-menu-bar .k-menu-group .k-link {
  display: flex !important;
  align-items: center !important;
  justify-content: flex-start !important;
}
```

**Sonuç:** ❌ Çalışmadı - `justify-content: flex-start` var ama yazılar hala ortalanmış görünüyor

### 3. Grid Yapısı

**Denenen CSS:**

```css
#ana-menu-bar .k-menu-group .k-link {
  display: grid !important;
  grid-template-columns: auto 1fr !important;
  align-items: center !important;
}

#ana-menu-bar .k-menu-group .k-menu-item-text {
  justify-self: start !important;
  text-align: left !important;
}
```

**Sonuç:** ❌ Çalışmadı - Grid yapısı flexbox ile çakıştı

### 4. JavaScript ile Inline Style Override

**Denenen JavaScript:**

```javascript
$('#ana-menu-bar .k-menu-group .k-menu-item .k-link').each(function() {
  $(this).css('display', 'flex')
    .css('align-items', 'center')
    .css('justify-content', 'flex-start')
    .css('text-align', 'left');
});

$('#ana-menu-bar .k-menu-group .k-menu-item .k-menu-item-text').each(function() {
  $(this).css('text-align', 'left')
    .css('margin-left', '0')
    .css('padding-left', '0');
});
```

**Sonuç:** ❌ Çalışmadı - Inline style'lar uygulanıyor ama görsel olarak değişmiyor

### 5. Inline Style Temizleme

**Denenen JavaScript:**

```javascript
// Telerik'in inline style'larını temizle
var currentStyle = element.getAttribute('style') || '';
var styleParts = currentStyle.split(';');
var newStyleParts = [];
for (var i = 0; i < styleParts.length; i++) {
  var part = styleParts[i].trim();
  if (part && !part.toLowerCase().includes('justify-content')) {
    newStyleParts.push(part);
  }
}
element.setAttribute('style', newStyleParts.join('; '));
```

**Sonuç:** ❌ Çalışmadı

### 6. Tüm Padding/Margin Sıfırlama

**Denenen CSS:**

```css
#ana-menu-bar .k-menu-group .k-link,
#ana-menu-bar .k-menu-group .k-menu-item-text {
  padding-left: 0 !important;
  padding-right: 0 !important;
  margin-left: 0 !important;
  margin-right: 0 !important;
}
```

**Sonuç:** ❌ Çalışmadı - Padding/margin sorunu değil

## Sorunun Muhtemel Nedenleri

1. **Telerik'in Runtime Inline Style'ları:** Telerik runtime'da inline style'lar ekliyor ve bunlar bizim CSS'lerimizi override ediyor
2. **CSS Specificity:** Telerik'in CSS kuralları bizim kurallarımızdan daha spesifik olabilir
3. **Flexbox Çakışması:** Parent ve child elementlerde farklı flexbox kuralları çakışıyor olabilir
4. **Text Alignment Override:** Telerik'in kendi text-align kuralları bizim kurallarımızı override ediyor olabilir
5. **Kendo UI'nin Kendi Hizalama Mantığı:** Kendo UI'nin kendi iç hizalama mantığı bizim CSS'lerimizi geçersiz kılıyor olabilir

## DevTools Gözlemleri

**Elements sekmesinde görülen:**
- Parent `<li>` elementinde `justify-content: flex-start !important` VAR
- `.k-link` elementinde `justify-content: flex-start !important` VAR
- `.k-menu-item-text` elementinde `text-align: left !important` VAR
- Tüm padding ve margin değerleri `0px` olarak görünüyor

**Ama görsel olarak:**
- Yazılar hala ortalanmış görünüyor
- İlk harfler (F, Ü, E) alt alta başlamıyor

## Mevcut Durum Özeti

- ✅ Dikey ortalama çalışıyor (`align-items: center`)
- ✅ Sarı hover efekti çalışıyor
- ✅ Mavi sol çizgi çalışıyor
- ✅ Tüm CSS kuralları uygulanıyor (DevTools'ta görünüyor)
- ❌ Yazıların sol hizalaması çalışmıyor (CSS var ama görsel olarak çalışmıyor)
- ❌ İlk harfler alt alta başlamıyor

## İstenen Çözüm

Alt menü öğelerinde yazılar:
1. Dikey olarak ortalanmalı (şu anda çalışıyor ✅)
2. Sol baştan başlamalı (şu anda çalışmıyor ❌)
3. İlk harfler alt alta olmalı (şu anda çalışmıyor ❌)

## Ek Bilgiler

- Telerik Kendo UI versiyonu: `kendo.all.min.js`
- jQuery versiyonu: 3.6.0
- Tarayıcı: Chrome (Windows 10)
- Menü yapılandırması: `horizontal` orientation, `openOnClick: false`, `highlightFirst: false`

## Kod Örnekleri

Tüm kod `dashboard/templates/dashboard/base.html` dosyasında bulunuyor. CSS kuralları `<style>` tag'i içinde, JavaScript kodu `$(document).ready()` içinde.

## Soru

Telerik Kendo UI Menu'de alt menü öğelerinde yazıları hem dikey olarak ortalayıp hem de sol baştan başlatmak için ne yapmalıyız? 

**Önemli:** Tüm CSS kuralları (`justify-content: flex-start`, `text-align: left`) DevTools'ta görünüyor ve `!important` ile uygulanmış durumda. Ama görsel olarak yazılar hala ortalanmış görünüyor. Bu, Telerik'in kendi iç hizalama mantığının bizim CSS'lerimizi görsel olarak override ettiğini gösteriyor.

**Denenen yöntemler:**
- ✅ CSS specificity artırma
- ✅ Flexbox kullanımı
- ✅ Grid yapısı
- ✅ JavaScript ile inline style override
- ✅ Inline style temizleme
- ✅ Padding/margin sıfırlama

**Hiçbiri çalışmadı.** Telerik'in kendi hizalama mantığını nasıl override edebiliriz?

## Ekran Görüntüleri

1. DevTools Elements sekmesi: Parent `<li>` elementinde `justify-content: flex-start` görünüyor
2. DevTools Styles sekmesi: `.k-link` elementinde tüm CSS kuralları doğru görünüyor
3. Menü görünümü: Yazılar dikey olarak ortalanmış ama yatayda ortalanmış görünüyor

## Yardım İsteği

Bu sorunu çözmek için önerileriniz nelerdir? Telerik Kendo UI Menu'nun kendi hizalama mantığını nasıl override edebiliriz? CSS kuralları uygulanıyor ama görsel olarak çalışmıyor - bu durumda ne yapmalıyız?
