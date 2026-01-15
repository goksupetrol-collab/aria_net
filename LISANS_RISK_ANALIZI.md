# LISANS RISK ANALIZI: SQL SERVER -> DJANGO UYGULAMA

## SORUNUZ:
"SQL Server'a girip projenin mantığına bakabilir misin? Bizim projeye uygular mıyız yoksa başımız ağrır, lisans ihlali ne mi düşeriz?"

---

## CEVAP: **GÜVENLİ - LİSANS İHLALİ YOK** ✅

---

## ✅ GÜVENLİ OLANLAR (Lisans İhlali Değil):

### 1. **Veritabanı Yapısını İncelemek**
- Tablo isimlerini görmek
- Kolon yapılarını anlamak
- İlişkileri (Foreign Keys) görmek
- **NEDEN GÜVENLİ:** Bu sadece YAPISAL bilgi, VERİ değil

### 2. **Mantığı Anlamak ve Uygulamak**
- İş mantığını kavramak
- Kendi projenizde benzer yapı kurmak
- Farklı teknoloji (Django) ile aynı mantığı uygulamak
- **NEDEN GÜVENLİ:** İş mantığı telif hakkı kapsamında değil

### 3. **Kendi Kodunuzu Yazmak**
- Django'da kendi modellerinizi yazmak
- Kendi view'larınızı yazmak
- Kendi API'lerinizi yazmak
- **NEDEN GÜVENLİ:** Kendi kodunuz, kopya değil

---

## ❌ RİSKLİ OLANLAR (Lisans İhlali):

### 1. **Gerçek Verileri Kopyalamak**
- Müşteri bilgilerini kopyalamak
- Fiyat bilgilerini kopyalamak
- İş verilerini kopyalamak
- **NEDEN RİSKLİ:** Veri sahibinin izni gerekir

### 2. **Ticari Kodu Kopyalamak**
- Lisanslı yazılımın kodunu kopyalamak
- Stored procedure'leri kopyalamak
- View'leri birebir kopyalamak
- **NEDEN RİSKLİ:** Telif hakkı ihlali

### 3. **Lisanslı Yazılımı Kopyalamak**
- Tüm uygulamayı kopyalamak
- Executable dosyaları kopyalamak
- **NEDEN RİSKLİ:** Açık lisans ihlali

---

## 📋 YAPILACAKLAR (Güvenli):

### 1. **Veritabanı Yapısını İncele**
```python
# Tabloları gör
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES

# Kolonları gör
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS

# İlişkileri gör
SELECT * FROM sys.foreign_keys
```

### 2. **Mantığı Anla**
- Hangi tablolar birbiriyle ilişkili?
- İş akışı nasıl?
- Veri nasıl akıyor?

### 3. **Django'da Uygula**
- Kendi modellerinizi yazın
- Kendi view'larınızı yazın
- Kendi API'lerinizi yazın

---

## ⚖️ YASAL DURUM:

### Telif Hakkı Kapsamında OLMAYANLAR:
- ✅ Veritabanı şeması (tablo/kolon isimleri)
- ✅ İş mantığı (business logic)
- ✅ Genel fikirler ve konseptler
- ✅ Veri yapıları

### Telif Hakkı Kapsamında OLANLAR:
- ❌ Yazılımın kendisi (kod)
- ❌ Gerçek veriler
- ❌ Özel algoritmalar
- ❌ Ticari sırlar

---

## 💡 ÖRNEK:

### GÜVENLİ Senaryo:
1. SQL Server'da "Musteriler" tablosunu görüyorsunuz
2. Kolonları görüyorsunuz: `id`, `ad`, `soyad`, `email`
3. Django'da kendi `Customer` modelinizi yazıyorsunuz
4. Benzer kolonlar kullanıyorsunuz ama kendi kodunuz
5. **SONUÇ:** ✅ Güvenli, lisans ihlali yok

### RİSKLİ Senaryo:
1. SQL Server'dan müşteri verilerini çekiyorsunuz
2. Bu verileri Django projenize kopyalıyorsunuz
3. **SONUÇ:** ❌ Riskli, veri sahibinin izni gerekir

---

## ✅ SONUÇ:

**SQL Server'daki veritabanı yapısını inceleyip Django'ya uygulamak:**

- ✅ **GÜVENLİ** - Lisans ihlali değil
- ✅ **YASAL** - Telif hakkı kapsamında değil
- ✅ **NORMAL** - Herkes yapabilir

**YAPILMASI GEREKENLER:**
1. Veritabanı yapısını incele (güvenli)
2. Mantığı anla (güvenli)
3. Django'da kendi kodunuzu yazın (güvenli)

**YAPILMAMASI GEREKENLER:**
1. Gerçek verileri kopyalamayın (riskli)
2. Ticari kodu kopyalamayın (riskli)
3. Lisanslı yazılımı kopyalamayın (riskli)

---

## 🎯 ÖZET:

**"SQL Server'a girip projenin mantığına bakabilir misin?"**

**CEVAP: EVET, BAKABILIRIM VE UYGULAYABILIRIZ!**

- Veritabanı yapısını incelemek → ✅ Güvenli
- Mantığı anlamak → ✅ Güvenli
- Django'da uygulamak → ✅ Güvenli
- Lisans ihlali → ❌ Yok

**RAHATÇA YAPABILIRSINIZ!** 🎉
