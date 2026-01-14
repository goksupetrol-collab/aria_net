# PROJE DURUMU VE ÖNEMLİ BİLGİLER

## PROJE BİLGİLERİ

**Proje Adı:** aria_net  
**Klasör:** D:\tayfun  
**Framework:** Django 5.2.9  
**Veritabanı:** SQLite (geçici) / SQL Server (yapılandırılacak)  
**Durum:** Aktif geliştirme

---

## GİT DURUMU

**Git Kurulu:** ✅ Evet (versiyon 2.52.0)  
**Git Başlatıldı:** ✅ Evet  
**İlk Commit:** ✅ Yapıldı (894bc8e)  
**Kural:** Her değişiklikte otomatik commit yapılacak

**Son Commit'ler:**
- 7843b07 - ÖDEME tablosuna A ve B sütunları eklendi
- 894bc8e - İlk kayıt - Proje başlangıcı ve TAHSİLAT alt başlıkları eklendi

---

## ÖNEMLİ KURALLAR

### 1. Git Commit Kuralı
- **Ben (AI) her değişiklik yaptığımda otomatik commit yapacağım**
- Kullanıcı kod yazmayı bilmiyor, bu yüzden manuel commit yapmayacak
- Her değişiklikten sonra: `git add .` ve `git commit -m "açıklama"`

### 2. Dosya Kayıt Yeri
- **HTML dosyaları:** 
  - `D:\tayfun\dashboard\templates\dashboard\base.html` (Ana şablon - ALAN 1, 2, 3)
  - `D:\tayfun\dashboard\templates\dashboard\telerik_yeni_proje.html` (Ana sayfa - base'i kullanıyor)
- **Python dosyaları:** `D:\tayfun\dashboard\` klasöründe
- **Git kayıtları:** `D:\tayfun\.git\` (gizli klasör)
- **⚠️ ÖNEMLİ:** `dashboard.html` diye bir dosya YOK! (Sadece klasör adı "dashboard")

### 3. Yedek Dosyalar
- **Eski yedek dosyalar:** Silindi (Git kullanılıyor artık)
- **Git yedek:** `.git` klasöründe (asla silinmemeli!)

---

## YAPILAN DEĞİŞİKLİKLER

### TAHSİLAT Tablosu
- ✅ Alt başlıklar eklendi: "AÇIKLAMA" ve "TL" satırları
- Dosya: `telerik_yeni_proje.html` (base.html'i kullanıyor)

### ÖDEME Tablosu
- ✅ Alt başlıklar eklendi: "A" ve "B" sütunları
- Dosya: `telerik_yeni_proje.html` (base.html'i kullanıyor)
- CSS: `.odeme-header`, `.odeme-row`, `.odeme-label` stilleri eklendi

---

## BİLİNEN SORUNLAR VE ÇÖZÜMLER

### Sorun 1: HTML Dosyası Kaybolma
**Neden:** Cursor'un yedek sistemi karıştı  
**Çözüm:** Git kullanılıyor artık, yedek dosyalar silindi

### Sorun 2: Kullanıcı Değişti
**Durum:** Eski kullanıcı: arial → Yeni kullanıcı: goksu  
**Çözüm:** Git safe.directory ayarı yapıldı

### Sorun 3: Windows File History
**Durum:** Kapalı (sorun değil)

---

## KULLANICI BİLGİLERİ

**Kullanıcı Adı:** goksu  
**Kullanıcı Tipi:** Kod yazmayı bilmiyor, sadece mantık söylüyor  
**Dil:** Türkçe konuşulacak

---

## PROJE YAPISI

```
D:\tayfun\
├── aria_net\          (Ana Django projesi)
├── dashboard\         (Ana uygulama)
│   ├── models.py      (Veritabanı modelleri)
│   ├── views.py        (API endpoints)
│   ├── templates\      (HTML dosyaları)
│   │   └── dashboard\
│   │       ├── base.html              (ANA ŞABLON - ALAN 1, 2, 3)
│   │       └── telerik_yeni_proje.html (ANA SAYFA - base'i kullanıyor)
│   └── static\         (CSS, JS dosyaları)
├── .git\              (Git kayıtları - GİZLİ)
├── db.sqlite3          (Veritabanı)
└── manage.py          (Django yönetim)
```

---

## ÖNEMLİ DOSYALAR

1. **base.html** - Ana şablon (ALAN 1, 2, 3 - sabit çerçeve)
2. **telerik_yeni_proje.html** - Ana sayfa (base'i kullanıyor - içerik burada)
3. **models.py** - Veritabanı yapısı
4. **views.py** - API endpoints
5. **settings.py** - Django ayarları

**⚠️ ÖNEMLİ:** `dashboard.html` diye bir dosya YOK! Sadece klasör adı "dashboard" (Django uygulaması).

---

## GELECEKTE YAPILACAKLAR

- [ ] SQL Server bağlantısı yapılandırılacak
- [ ] Admin paneli modelleri kaydedilecek
- [ ] Daha fazla özellik eklenecek

---

## NOTLAR

- Proje çalışıyor: http://127.0.0.1:6543
- Python 3.14.2 kurulu
- Virtual environment: `D:\tayfun\venv\`
- Masaüstü kısayolu: "ARIA NET Proje Ac.lnk"

---

## YENİ SOHBET BAŞLARKEN

Bu dosyayı okuyun ve şu bilgileri hatırlayın:
1. Git kullanılıyor, her değişiklikte commit yapılacak
2. Kullanıcı kod yazmayı bilmiyor, sadece mantık söylüyor
3. Ana dosyalar: `base.html` (şablon) ve `telerik_yeni_proje.html` (sayfa)
4. **`dashboard.html` diye bir dosya YOK!** (Sadece klasör adı "dashboard")
5. Proje: D:\tayfun klasöründe

## ÖNEMLİ DOSYALAR (YENİ)

### Tablo Değişiklikleri İçin:
1. **TABLO_YAPILARI.md** - Tüm tabloların detaylı yapısı
2. **DEGISIKLIK_ONCESI_KONTROL.md** - Değişiklik yapmadan önce kontrol listesi
3. **KOLAY_ANLATIM_REHBERI.md** - Kullanıcının kolay anlatması için rehber

### Kural:
- **Her tablo değişikliğinde:** TABLO_YAPILARI.md'yi oku
- **Değişiklik yapmadan önce:** Mevcut yapıyı kontrol et
- **Değişiklikten sonra:** Test et ve Git commit yap

