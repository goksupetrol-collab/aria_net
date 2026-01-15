# TABLO YAPILARI - DETAYLI DOKÜMANTASYON

## MOTORİN TABLOSU (MTR SOL)

### Konum
- **Dosya:** `dashboard/templates/dashboard/dashboard.html`
- **Satır:** 194-246
- **ID/Class:** `.mtr1` veya `#p-motorin` (yoksa `.mtr1`)

### Yapı
```
Başlık: "MOTORİN"
┌─────────────────────────────────────────────────────────┐
│ MTR │ YAĞCILAR │ TEPEKUM │ NAMDAR │ ŞEKER │ AKOVA │ KOOP. │ NAZİLLİ │
├─────┼──────────┼─────────┼────────┼───────┼───────┼───────┼─────────┤
│ KAPASİTE │ 100.000 │ 100.000 │ 29.000 │ 60.000 │ 50.000 │ 60.000 │ 70.000 │
│ ANLIK │ (otomatik) │ (otomatik) │ ... │ ... │ ... │ ... │ ... │
│ SATIŞ │ [input] │ [input] │ [input] │ [input] │ [input] │ [input] │ [input] │
│ TARİH │ YAĞCILAR │ TEPEKUM │ ... │ ... │ ... │ ... │ ... │
│ Perşembe │ [input] │ [input] │ ... │ ... │ ... │ ... │ ... │
│ Cuma │ [input] │ [input] │ ... │ ... │ ... │ ... │ ... │
│ ... (devam ediyor) │
└─────────────────────────────────────────────────────────┘
```

### Sütunlar (7 sütun)
1. MTR (satır başlığı)
2. YAĞCILAR
3. TEPEKUM
4. NAMDAR
5. ŞEKER
6. AKOVA
7. KOOP.
8. NAZİLLİ

### Satırlar
1. **KAPASİTE** - Sabit değerler (değiştirilemez)
2. **ANLIK** - Otomatik hesaplanan (KAPASİTE - İlk gün satışı)
3. **SATIŞ** - Input alanları (API'ye kaydediliyor)
4. **TARİH** - Sabit başlık satırı
5. **Perşembe, Cuma, ...** - Tarih satırları (input alanları)

### Önemli Notlar
- SATIŞ satırı API'ye kaydediliyor (`/api/motorin-satis/`)
- ANLIK otomatik hesaplanıyor (JavaScript)
- Tarih satırları otomatik dolduruluyor (JavaScript)

---

## BENZİN TABLOSU (MTR SAĞ)

### Konum
- **Dosya:** `dashboard/templates/dashboard/dashboard.html`
- **Satır:** 267-271
- **ID/Class:** `.mtr2`

### Yapı
```
Başlık: "MTR"
┌─────────────────────────────────────┐
│ (Şu an boş - sadece başlık var) │
└─────────────────────────────────────┘
```

### Durum
- ⚠️ Henüz içerik yok, sadece başlık var

---

## TAHSİLAT TABLOSU

### Konum
- **Dosya:** `dashboard/templates/dashboard/dashboard.html`
- **Satır:** 277-289
- **ID/Class:** `#p-tahsilat`

### Yapı
```
Başlık: "TAHSİLAT"
┌─────────────────────────────┐
│ AÇIKLAMA │ (satır) │
│ TL │ (satır) │
│ (boş alan - 30 satır olacak) │
└─────────────────────────────┘
```

### Alt Başlıklar
1. **AÇIKLAMA** - Satır (dikey)
2. **TL** - Satır (dikey)

### CSS Sınıfları
- `.tahsilat-header` - Container
- `.tahsilat-row` - Satır
- `.tahsilat-label` - Etiket

### Durum
- ✅ Alt başlıklar eklendi
- ⚠️ İçerik (30 satır) henüz yok

---

## ÖDEME TABLOSU

### Konum
- **Dosya:** `dashboard/templates/dashboard/dashboard.html`
- **Satır:** 291-299
- **ID/Class:** `#p-odeme`

### Yapı
```
Başlık: "ÖDEME"
┌─────────────────────────────┐
│ A │ B │ (sütunlar - yan yana) │
│ (boş alan - 30 satır olacak) │
└─────────────────────────────┘
```

### Alt Başlıklar
1. **A** - Sütun (yan yana)
2. **B** - Sütun (yan yana)

### CSS Sınıfları
- `.odeme-header` - Container
- `.odeme-row` - Satır
- `.odeme-label` - Etiket (text-align: center)

### Durum
- ✅ Alt başlıklar eklendi (A ve B sütunları)
- ⚠️ İçerik (30 satır) henüz yok

---

## ÖDEME (DBS) TABLOSU

### Konum
- **Dosya:** `dashboard/templates/dashboard/dashboard.html`
- **Satır:** 296-299
- **ID/Class:** `#p-dbs`

### Yapı
```
Başlık: "ÖDEME (DBS)"
┌─────────────────────────────┐
│ (Kırmızı arka plan) │
│ (boş alan) │
└─────────────────────────────┘
```

### Özellikler
- Kırmızı arka plan (#b31212)
- Kırmızı başlık (#5b0b0b)
- Özel çizgiler (lines-dbs)

### Durum
- ⚠️ Henüz içerik yok

---

## ENTRY TABLOSU

### Konum
- **Dosya:** `dashboard/templates/dashboard/dashboard.html`
- **Satır:** 321-323
- **ID/Class:** `.entry`

### Yapı
```
Başlık: "FİRMA / ÜRÜN / LİTRE / TL / ÖDEME TÜR"
┌─────────────────────────────────────────────┐
│ (30 sipariş satırı olacak) │
└─────────────────────────────────────────────┘
```

### Durum
- ⚠️ Henüz içerik yok

---

## ARAÇLAR (CARS)

### Konum
- **Dosya:** `dashboard/templates/dashboard/dashboard.html`
- **Satır:** 325-337
- **ID/Class:** `.cars` ve `.carsGrid`

### Yapı
```
2x4 Grid (2 satır, 4 sütun)
┌─────────┬─────────┬─────────┬─────────┐
│ 1 ARAÇ │ 2 ARAÇ │ 3 ARAÇ │ 4 ARAÇ │
├─────────┼─────────┼─────────┼─────────┤
│ 5 ARAÇ │ 6 ARAÇ │ 7 ARAÇ │ 8 ARAÇ │
└─────────┴─────────┴─────────┴─────────┘
```

### Durum
- ✅ 8 araç kartı var
- ⚠️ İçerik henüz yok

---

## DEĞİŞİKLİK YAPARKEN DİKKAT EDİLECEKLER

### 1. MOTORİN Tablosunda Değişiklik
- ⚠️ JavaScript kodları var (satır 313-565)
- ⚠️ API entegrasyonu var (`/api/motorin-satis/`)
- ⚠️ ANLIK hesaplama var (otomatik)
- ✅ Değişiklik yaparken JavaScript'i bozmamaya dikkat!

### 2. TAHSİLAT/ÖDEME Tablolarında Değişiklik
- ✅ Sadece HTML/CSS (JavaScript yok)
- ✅ Kolay değiştirilebilir
- ⚠️ CSS sınıflarına dikkat!

### 3. Genel Kurallar
- ✅ Değişiklik yapmadan önce mevcut yapıyı kontrol et
- ✅ CSS sınıflarını değiştirirken dikkatli ol
- ✅ JavaScript varsa test et
- ✅ Değişiklikten sonra Git commit yap

---

## HIZLI REFERANS

### Tablo Bulma
- MOTORİN → `.mtr1` veya satır 194
- BENZİN → `.mtr2` veya satır 267
- TAHSİLAT → `#p-tahsilat` veya satır 277
- ÖDEME → `#p-odeme` veya satır 291
- ÖDEME (DBS) → `#p-dbs` veya satır 296
- ENTRY → `.entry` veya satır 321
- ARAÇLAR → `.cars` veya satır 325

### Değişiklik Yaparken
1. Bu dosyayı oku
2. Hangi tabloyu değiştireceğini bul
3. Mevcut yapıyı kontrol et
4. Değişiklik yap
5. Test et
6. Git commit yap


