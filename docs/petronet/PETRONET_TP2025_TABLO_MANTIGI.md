# PETRONET TP_2025 VERİTABANI - TABLO MANTIĞI

> **Bu dosya, TP_2025 veritabanındaki tabloların yapısı ve mantığını açıklar.**

## 📊 ÖNEMLİ TABLOLAR

### 1. POMPACI VARDIYA (pomvardimas, pomvardikap, pomvardiozet)

#### pomvardimas (Vardiya Masası - Ana Tablo)
**44 sütun** - Vardiya başlık bilgileri

**Önemli Sütunlar:**
- `varno` - Vardiya numarası
- `tarih` - Vardiya tarihi
- `saat` - Vardiya saati
- `varad` - Vardiya adı (örn: "ÇARŞAMBA", "1. VARDİYA")
- `aksatmik` - Akaryakıt satış miktarı
- `aksattop` - Akaryakıt satış tutarı
- `naktestop` - Nakliye tutarı
- `postop` - POS satış tutarı
- `veresitop` - Veresiye tutarı
- `malsattop` - Mal satış tutarı
- `gelirtop` - Gelir tutarı
- `gidertop` - Gider tutarı
- `tahtop` - Tahsilat tutarı
- `odetop` - Ödeme tutarı
- `otomastop` - Otomasyon tutarı
- `otomasmik` - Otomasyon miktarı
- `veresimik` - Veresiye miktarı

**Mantık:**
- Her vardiya için bir kayıt
- Tüm toplamlar bu tabloda tutuluyor
- `varok` = Vardiya kapalı mı? (0=açık, 1=kapalı)

#### pomvardikap (Vardiya Kap - Detay)
**19 sütun** - Vardiya kapanış detayları

**Önemli Sütunlar:**
- `varno` - Vardiya numarası (pomvardimas ile ilişkili)
- `kaptip` - Kapanış tipi (manuel, otomatik)
- `kod` - Kart kodu (P0001, P0008 gibi)
- `tutar` - Tutar
- `cartip` - Kart tipi (perkart, carikart vb.)
- `ackfaz` - Açık/Fazla durumu (tamam, açık, fazla)

**Mantık:**
- Vardiya kapanışında hangi kartların kullanıldığı
- Her kart için bir kayıt

#### pomvardiozet (Vardiya Özet)
**19 sütun** - Vardiya özet bilgileri

**Önemli Sütunlar:**
- `varno` - Vardiya numarası
- `tip` - Tip kodu (AKSAT, VERAT, vb.)
- `tipack` - Tip açıklaması ("Akaryakıt Sayaçlı Satış Tutarı", "Veresiye Alacak Tutarı")
- `giris` - Giriş tutarı
- `cikis` - Çıkış tutarı
- `bakiye` - Bakiye

**Mantık:**
- Vardiya özet raporu
- Her tip için bir kayıt (AKSAT, VERAT, vb.)

### 2. MARKET SATIŞ (marsatmas, marsathrk)

#### marsatmas (Market Satış Masası)
**51 sütun** - Market satış başlık bilgileri

**Önemli Sütunlar:**
- `marsatid` - Market satış ID
- `varno` - Vardiya numarası
- `tarih` - Satış tarihi
- `saat` - Satış saati
- `naktop` - Nakit toplam
- `postop` - POS toplam
- `veresitop` - Veresiye toplam
- `satistop` - Satış toplam
- `gidertop` - Gider toplam

#### marsathrk (Market Satış Hareket)
**50 sütun** - Market satış detayları

**Önemli Sütunlar:**
- `marsatid` - Market satış ID (marsatmas ile ilişkili)
- `perkod` - Ürün kodu
- `mik` - Miktar
- `brmfiy` - Birim fiyat
- `stkod` - Stok kodu

### 3. KASA (kasahrk, kasakart)

#### kasahrk (Kasa Hareket)
**63 sütun** - Kasa işlem hareketleri

**Önemli Sütunlar:**
- `kaskod` - Kasa kodu
- `kashrkid` - Kasa hareket ID
- `gctip` - Giriş/Çıkış tipi (G=giriş, C=çıkış)
- `tutar` - Tutar
- `tarih` - İşlem tarihi

#### kasakart (Kasa Kartı)
Kasa tanımları

### 4. CARİ (carihrk, carikart)

#### carihrk (Cari Hareket)
Cari hesap hareketleri

#### carikart (Cari Kart)
Cari hesap kartları

### 5. FATURA (faturamas, faturahrk)

#### faturamas (Fatura Masası)
Fatura başlık bilgileri

#### faturahrk (Fatura Hareket)
Fatura detayları

---

## 🔍 TAHSİLAT VE ÖDEME TABLOLARI

### TahsilatOdeme (Tahsilat/Ödeme Birleşik Tablo)
**61 sütun** - Hem tahsilat hem ödeme işlemleri

**Önemli Sütunlar:**
- `giren` - Giriş tutarı (TAHSİLAT)
- `cikan` - Çıkış tutarı (ÖDEME)
- `ack` - Açıklama
- `tarih` - İşlem tarihi
- `saat` - İşlem saati
- `Tutar` - Tutar
- `islmtip` - İşlem tipi
- `islmhrk` - İşlem hareket
- `cartip` - Kart tipi
- `carkod` - Kart kodu
- `belno` - Belge numarası
- `vadetar` - Vade tarihi
- `cekid` - Çek ID
- `bankkod` - Banka kodu

**Mantık:**
- `giren > 0` → TAHSİLAT
- `cikan > 0` → ÖDEME
- Aynı tabloda hem tahsilat hem ödeme tutuluyor

**Diğer Tahsilat Tabloları:**
- `BulutTahsilat` - Bulut tahsilat
- `TTS_BankaTahsilat` - Banka tahsilat

---

## 💡 TABLO MANTIĞI ÖZET

### Vardiya Sistemi
1. **pomvardimas** - Vardiya başlığı (tarih, saat, toplamlar)
2. **pomvardikap** - Vardiya kapanış detayları (kartlar)
3. **pomvardiozet** - Vardiya özet raporu

### Satış Sistemi
1. **marsatmas** - Satış başlığı
2. **marsathrk** - Satış detayları (ürünler)

### Kasa Sistemi
1. **kasakart** - Kasa tanımları
2. **kasahrk** - Kasa işlemleri (giriş/çıkış)

---

## 📋 BİZİM PROJEDEKİ TABLOLARLA KARŞILAŞTIRMA

| Bizim Proje | PetroNet Tablosu | Açıklama |
|-------------|-------------------|----------|
| MOTORİN Grid | `pomvardimas` + `pomvardiozet` | Vardiya tablosundan akaryakıt satışları |
| BENZİN Grid | `pomvardimas` + `pomvardiozet` | Vardiya tablosundan akaryakıt satışları |
| TAHSİLAT Grid | `kasahrk` (gctip='G') | Kasa giriş hareketleri |
| ÖDEME Grid | `kasahrk` (gctip='C') | Kasa çıkış hareketleri |
| YAKIT ALIMLARI | `stkhrk` (gctip='G') | Stok giriş hareketleri |
| ARAÇLAR | `SoforKart` veya `AracKart` | Araç/Şoför kartları |

---

## 🏢 ŞİRKET/FİRMA TANIMLARI

### Firma Tablosu
**73 sütun** - Şirket/Şube tanımları

**Önemli Sütunlar:**
- `id` - Firma ID
- `kod` - Firma kodu (1, 2, 3, vb.)
- `ad` - Firma adı (01-MERKEZ, 02-YAĞCILAR, vb.)
- `Pv_Kasa` - Pompacı vardiya kasa kodu (K0001, K0002, vb.)
- `Mv_Kasa` - Market vardiya kasa kodu
- `var_otomas` - Vardiya otomasyon tipi
- `on_otomas` - Online otomasyon tipi

**TP_2025 Veritabanındaki Firmalar:**
1. **01-MERKEZ** (kod: 1)
2. **02-YAĞCILAR** (kod: 2) ✅ (Bizim projede kullanılıyor)
3. **03-TEPEKUM** (kod: 3) ✅ (Bizim projede kullanılıyor)
4. **04-NAMDAR** (kod: 4) ✅ (Bizim projede kullanılıyor)
5. **05-ŞEKER** (kod: 5) ✅ (Bizim projede kullanılıyor)
6. **06-AKOVA** (kod: 6) ✅ (Bizim projede kullanılıyor)
7. **07-KOOP.** (kod: 7) ✅ (Bizim projede kullanılıyor)
8. **08-İSABEYLİ** (kod: 8)
9. (9. firma - muhtemelen 09-NAZİLLİ) ✅ (Bizim projede kullanılıyor)

**Bizim Projedeki Grid Sütunları ile Eşleşme:**
- MOTORİN ve BENZİN grid'lerindeki sütunlar: YAĞCILAR, TEPEKUM, NAMDAR, ŞEKER, AKOVA, KOOP., NAZİLLİ
- Bu sütunlar `Firma` tablosundaki `ad` alanından geliyor (kod 2-8 arası)

---

**Son Güncelleme:** 2025-01-XX
**Veritabanı:** TP_2025
**Server:** 81.214.134.225:9012
