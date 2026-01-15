# SORUN NOTLARI

## Güncelleme Geçmişi (Telerik)
- 2025-01-XX: Menu HTML yapısı düzeltildi (<ul><li> formatı)
- 2025-01-XX: Telerik dokümantasyonu incelendi ve uygulandı
- 2025-01-XX: Renk paleti düzenlendi (mavi kaldırıldı)

## WPF Bilgileri
- TELERIK_WPF_BILGILERI.md

## Sorun 1: Telerik Kendo UI Menu Hover "Merdiven" Sorunu
- Sorun: Alt menü öğelerine hover yapılınca tek renk yerine katmanlı/merdiven görünümü oluşuyor.
- Beklenen: Hover tüm öğede tek ve düz renk olmalı.
- Denenenler: !important hover kuralları, farklı selector denemeleri, gradient kaldırma, z-index ayarları, mouseenter/leave ile inline style, tüm çocuklara renk verme.
- Test: Kırmızı ve sarı-turuncu renklerde sorun devam etti.
- Olası nedenler: Inline style override, CSS spesifiklik, gradient/background-image, z-index, pseudo-element’ler.
- Kod yeri: dashboard/templates/dashboard/base.html (CSS: <style>, JS: $(document).ready()).

## Sorun 2: Telerik Kendo UI Menu Yazıların Sol Hizalaması (Detaylı)
- Sorun: Alt menü yazıları dikey ortalanıyor ama sol hizalama çalışmıyor.
- Beklenen: Yazılar dikey ortalı + sol baştan başlasın (ilk harfler alt alta).
- DevTools: justify-content/text-align görünüyor ama görsel değişmiyor.
- Denenenler: CSS specificity artırma, flexbox/grid denemeleri, inline style override, inline style temizleme, padding/margin sıfırlama.
- Olası nedenler: Telerik inline style’ları, kendi flexbox mantığı, text-align override.
- Ek bilgiler: kendo.all.min.js, jQuery 3.6.0, Chrome, horizontal menu, openOnClick:false.
- Kod yeri: dashboard/templates/dashboard/base.html (CSS: <style>, JS: $(document).ready()).
