# HIZLI BAŞLANGIÇ REHBERİ - YENİ CURSOR SOHBETLERİ İÇİN

## 🚀 YENİ SOHBET BAŞLARKEN MUTLAKA OKUYUN!

Bu dosya, yeni bir Cursor sohbeti başlattığınızda AI asistanının projeyi hızlıca anlaması için hazırlanmıştır.

---

## 📋 1. PROJE ÖZETİ

**Proje Adı:** aria_net  
**Framework:** Django 5.2.9  
**Konum:** `D:\tayfun`  
**Durum:** ✅ Aktif geliştirme  
**Veritabanı:** SQLite (geçici) / SQL Server (yapılandırılacak)  
**URL:** http://127.0.0.1:8000

---

## 👤 KULLANICI BİLGİLERİ

- **Kullanıcı Adı:** goksu
- **Önemli:** Kullanıcı kod yazmayı bilmiyor, sadece mantık söylüyor
- **Dil:** Türkçe konuşulacak
- **Kural:** AI asistanı tüm kodları yazacak, hataları kendi kendine tarayıp düzeltecek

---

## ⚙️ ÖNEMLİ KURALLAR

### 1. Git Commit Kuralı
- ✅ **AI asistanı her değişiklik yaptığında otomatik commit yapacak**
- ✅ Kullanıcı manuel commit yapmayacak (kod yazmayı bilmiyor)
- ✅ Her değişiklikten sonra: `git add .` ve `git commit -m "açıklama"`

### 2. Değişiklik Yapmadan Önce
- ✅ `PROJE_DURUMU.md` dosyasını oku
- ✅ `TABLO_YAPILARI.md` dosyasını kontrol et (tablo değişiklikleri için)
- ✅ `git status` ile mevcut durumu kontrol et
- ✅ Mevcut yapıyı anla, sonra değişiklik yap

### 3. Değişiklik Yaptıktan Sonra
- ✅ Test et (tarayıcıda kontrol et)
- ✅ Git commit yap
- ✅ Başka bir şey bozuldu mu kontrol et

---

## 📁 PROJE YAPISI

```
D:\tayfun\
├── aria_net\                    # Ana Django projesi
│   ├── settings.py              # Django ayarları
│   └── urls.py                  # URL yönlendirmeleri
├── dashboard\                    # Ana uygulama
│   ├── models.py                # Veritabanı modelleri
│   ├── views.py                 # API endpoints ve view'lar
│   ├── admin.py                 # Admin panel ayarları
│   ├── templates\
│   │   └── dashboard\
│   │       └── dashboard.html  # ⭐ ANA DOSYA (en çok düzenlenen)
│   └── static\                  # CSS, JS dosyaları
├── .git\                        # Git kayıtları (GİZLİ - ASLA SİLME!)
├── db.sqlite3                   # Veritabanı dosyası
├── manage.py                    # Django yönetim scripti
├── venv\                        # Virtual environment
└── requirements.txt            # Python paketleri
```

---

## 📄 ÖNEMLİ DOSYALAR

### Ana Dosyalar
1. **`dashboard/templates/dashboard/dashboard.html`** - Ana ekran (en çok düzenlenen)
2. **`dashboard/models.py`** - Veritabanı modelleri
3. **`dashboard/views.py`** - API endpoints ve view fonksiyonları
4. **`aria_net/settings.py`** - Django ayarları

### Dokümantasyon Dosyaları
1. **`PROJE_DURUMU.md`** - Proje durumu ve önemli bilgiler
2. **`TABLO_YAPILARI.md`** - Tüm tabloların detaylı yapısı (tablo değişiklikleri için MUTLAKA oku!)
3. **`DEGISIKLIK_ONCESI_KONTROL.md`** - Değişiklik yapmadan önce kontrol listesi
4. **`KOLAY_ANLATIM_REHBERI.md`** - Kullanıcının kolay anlatması için rehber

---

## 🔍 SON YAPILAN DEĞİŞİKLİKLER (Git Log)

Son 10 commit:
- ✅ YAKIT ALIMLARI tablosunda FIRMA hücresine çift tıklamayla temizleme özelliği
- ✅ YAKIT ALIMLARI tablosunda URUN localStorage yükleme sonrası TL hesaplama
- ✅ YAKIT ALIMLARI tablosunda TL hesaplama hataları düzeltildi
- ✅ YAKIT ALIMLARI tablosunda TL değerleri Türkçe formatta gösteriliyor
- ✅ YAKIT ALIMLARI tablosunda sayfa yüklendiğinde TL değerleri otomatik hesaplanıyor
- ✅ YAKIT ALIMLARI tablosunda TL sütununa input alanı ve hesaplama fonksiyonu

---

## 🎯 TABLO DEĞİŞİKLİKLERİ İÇİN ÖZEL KURALLAR

### Tablo Değişikliği Yaparken:
1. **`TABLO_YAPILARI.md`** dosyasını MUTLAKA oku
2. Hangi tablo? (MOTORİN, BENZİN, TAHSİLAT, ÖDEME, YAKIT ALIMLARI, vb.)
3. Mevcut yapıyı anla (satır numaraları, CSS sınıfları, JavaScript var mı?)
4. Değişiklik yap
5. Test et
6. Git commit yap

### Dikkat Edilecekler:
- ⚠️ MOTORİN/BENZİN tablolarında JavaScript kodları var (satır 313-565)
- ⚠️ API entegrasyonları var (`/api/motorin-satis/`, `/api/benzin-satis/`)
- ⚠️ CSS sınıflarını değiştirirken dikkatli ol
- ⚠️ JavaScript kodlarını bozmamaya dikkat et

---

## 🚀 PROJE ÇALIŞTIRMA

### Yöntem 1: Masaüstü Kısayolu
- Masaüstünde "ARIA NET Proje Ac.lnk" kısayoluna çift tıklayın

### Yöntem 2: Batch Dosyası
- `D:\tayfun\PROJE_AC.bat` dosyasını çalıştırın

### Yöntem 3: Manuel
```powershell
cd D:\tayfun
.\venv\Scripts\Activate.ps1
py manage.py runserver
```

Tarayıcıda açın: http://127.0.0.1:8000

---

## 🔧 HIZLI KONTROL KOMUTLARI

### Git Durumu
```bash
cd D:\tayfun
git status              # Değişiklik var mı?
git log --oneline -5    # Son 5 commit'i gör
```

### Proje Durumu
```bash
py --version            # Python versiyonu
git --version           # Git versiyonu
Test-Path D:\tayfun\.git  # Git başlatıldı mı?
```

---

## 🐛 SORUN GİDERME

### Proje Açılmıyor?
1. Python kurulu mu? `py --version`
2. Virtual environment var mı? `D:\tayfun\venv\`
3. Django çalışıyor mu? `cd D:\tayfun; .\venv\Scripts\Activate.ps1; py manage.py runserver`

### Git Sorunları?
1. Git kurulu mu? `git --version`
2. Git başlatıldı mı? `Test-Path D:\tayfun\.git`
3. Son commit nedir? `git log --oneline -1`

### Başka Bir Şey Bozuldu?
1. `git status` ile ne değişti bak
2. `git diff` ile değişiklikleri gör
3. Gerekirse `git restore` ile geri al

---

## 📝 ÖRNEK KULLANICI İSTEKLERİ

Kullanıcı şöyle istekler yapabilir:

### ✅ İyi Örnekler:
- "MOTORİN tablosuna yeni bir satır ekle, adı 'TOPLAM' olsun"
- "YAKIT ALIMLARI tablosunda TL sütununa yeni bir özellik ekle"
- "TAHSİLAT tablosunda AÇIKLAMA satırının altına bir satır daha ekle"

### ❌ Kötü Örnekler:
- "Şu tabloda, şuraya, şunu ekle..." (belirsiz)
- "Bunu değiştir" (ne olduğu belli değil)

---

## ⚠️ ÖNEMLİ UYARILAR

1. **`.git` klasörünü ASLA silme!** (Git kayıtları burada)
2. **`dashboard.html` dosyasını değiştirirken JavaScript kodlarını bozmamaya dikkat et**
3. **Her değişiklikten sonra test et**
4. **Git commit yapmayı unutma**

---

## 📚 DETAYLI BİLGİ İÇİN

- **Proje Durumu:** `PROJE_DURUMU.md`
- **Tablo Yapıları:** `TABLO_YAPILARI.md`
- **Değişiklik Kontrolü:** `DEGISIKLIK_ONCESI_KONTROL.md`
- **Kullanıcı Rehberi:** `KOLAY_ANLATIM_REHBERI.md`

---

## 🎯 ÖZET

**Yeni sohbet başlarken:**
1. ✅ Bu dosyayı oku
2. ✅ `PROJE_DURUMU.md` dosyasını oku
3. ✅ `git status` ile mevcut durumu kontrol et
4. ✅ Kullanıcının isteğini anla
5. ✅ Gerekirse `TABLO_YAPILARI.md` dosyasını oku
6. ✅ Değişiklik yap
7. ✅ Test et
8. ✅ Git commit yap

**Kullanıcı:**
- Kod yazmayı bilmiyor
- Sadece mantık söylüyor
- Türkçe konuşuyor

**AI Asistan:**
- Tüm kodları yazacak
- Hataları kendi kendine tarayıp düzeltecek
- Her değişiklikte otomatik Git commit yapacak

---

**Son Güncelleme:** 2025-01-26  
**Hazırlayan:** Cursor AI Assistant
