# Telerik Kendo UI Menu Hover Efekti "Merdiven" Sorunu

## Sorun Açıklaması

Telerik Kendo UI Menu bileşeninde alt menü öğelerine hover yapıldığında, hover rengi düzgün uygulanmıyor ve "merdiven" gibi görünüyor. Farklı elementler farklı renkler alıyor ve tek bir düz renk yerine katmanlı/merdiven görünümü oluşuyor.

## Teknik Detaylar

- **Kullanılan Framework:** Django
- **Kullanılan UI Kütüphanesi:** Telerik Kendo UI (jQuery tabanlı)
- **Sorun:** Alt menü öğelerine hover yapıldığında hover rengi (`#FF0000` veya `#FFF9C4`) tüm elementlere düzgün uygulanmıyor
- **Beklenen Davranış:** Hover durumunda tüm menü öğesi tek bir düz renkte görünmeli
- **Gerçekleşen Davranış:** Farklı elementler (li, .k-link, span, vb.) farklı renkler alıyor ve merdiven görünümü oluşuyor

## Denenen Çözümler

### 1. CSS ile Çözüm Denemeleri
- `!important` ile tüm hover kuralları yazıldı
- Farklı CSS selector'ları denendi (`li:hover`, `.k-link:hover`, `*` selector'ları)
- `background-image: none !important` ile gradient'ler kaldırılmaya çalışıldı
- `z-index` ayarları yapıldı

**Örnek CSS Kuralı:**
```css
#ana-menu-bar .k-menu-group li:hover * {
  background: #FF0000 !important;
  background-color: #FF0000 !important;
  background-image: none !important;
}
```

### 2. JavaScript ile Çözüm Denemeleri
- `mouseenter` ve `mouseleave` event listener'ları eklendi
- `element.style.setProperty()` ile inline style uygulandı
- `querySelectorAll('*')` ile tüm çocuk elementler bulundu ve renkleri ayarlandı
- Recursive fonksiyon ile tüm nested elementler kontrol edildi

**Örnek JavaScript Kodu:**
```javascript
function setAllChildrenRed(element) {
  element.style.setProperty('background', '#FF0000', 'important');
  element.style.setProperty('background-color', '#FF0000', 'important');
  element.style.setProperty('background-image', 'none', 'important');
  
  var allDescendants = element.querySelectorAll('*');
  for (var j = 0; j < allDescendants.length; j++) {
    allDescendants[j].style.setProperty('background', '#FF0000', 'important');
    allDescendants[j].style.setProperty('background-color', '#FF0000', 'important');
    allDescendants[j].style.setProperty('background-image', 'none', 'important');
  }
}
```

### 3. Test Sonuçları
- Kırmızı renk (`#FF0000`) test edildi - Sorun devam ediyor
- Sarı-turuncu renk (`#FFF9C4`) test edildi - Sorun devam ediyor
- Her iki renkte de "merdiven" görünümü oluşuyor

## HTML Yapısı

```html
<ul id="ana-menu-bar">
  <li>
    <span>Tanımlar</span>
    <ul>
      <li><span>Firma Tanımları</span></li>
      <li><span>Ürün Tanımları</span></li>
      <!-- ... -->
    </ul>
  </li>
</ul>
```

Telerik Kendo UI Menu bu HTML'i şu şekilde dönüştürüyor:
```html
<li class="k-item k-menu-item">
  <span class="k-link">
    <span class="k-menu-item-text">Firma Tanımları</span>
  </span>
</li>
```

## Sorunun Muhtemel Nedenleri

1. **Telerik'in Inline Style'ları:** Telerik runtime'da inline style'lar ekliyor olabilir ve bunlar CSS'i override ediyor
2. **CSS Specificity:** Telerik'in CSS kuralları bizim kurallarımızdan daha spesifik olabilir
3. **Gradient/Background-Image:** Telerik gradient veya background-image kullanıyor olabilir ve bunlar `background-color`'ı override ediyor
4. **Z-index Sorunları:** Farklı elementler farklı z-index değerlerine sahip olabilir
5. **Pseudo-element'ler:** `::before` veya `::after` pseudo-element'leri sorun yaratıyor olabilir

## İstenen Çözüm

Alt menü öğelerine hover yapıldığında, tüm menü öğesi (li, .k-link, span ve tüm iç elementler) tek bir düz renkte görünmeli. Merdiven görünümü olmamalı.

## Ek Bilgiler

- Telerik Kendo UI versiyonu: `kendo.all.min.js` (tam versiyon bilgisi yok)
- jQuery versiyonu: 3.6.0
- Tarayıcı: Chrome (Windows 10)
- Menü yapılandırması: `horizontal` orientation, `openOnClick: false`

## Kod Örnekleri

Tüm kod `dashboard/templates/dashboard/base.html` dosyasında bulunuyor. CSS kuralları `<style>` tag'i içinde, JavaScript kodu `$(document).ready()` içinde.

## Yardım İsteği

Bu sorunu çözmek için önerileriniz nelerdir? Telerik Kendo UI Menu'de hover efektini nasıl düzgün bir şekilde override edebiliriz?
