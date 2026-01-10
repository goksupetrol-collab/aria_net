# KOLAY ANLATIM REHBERİ - TABLO DEĞİŞİKLİKLERİ İÇİN

## SORUN

- Tabloları 7 kere anlatmak zorunda kalıyorsunuz
- Değişiklik tarif etmek çok zor
- Ben bir şey değiştirince başka bir şeyi bozuyorum

## ÇÖZÜM: BASİT ANLATIM YÖNTEMİ

### Yöntem 1: Tablo Adı + Ne İstiyorsunuz?

**Örnek:**
```
"MOTORİN tablosuna yeni bir satır ekle, adı 'TEST' olsun"
```

**Ben ne yapacağım:**
1. TABLO_YAPILARI.md'yi okuyacağım
2. MOTORİN tablosunu bulacağım
3. Mevcut yapıyı kontrol edeceğim
4. Değişikliği yapacağım
5. Test edeceğim
6. Git commit yapacağım

---

### Yöntem 2: Ekran Görüntüsü Tarif Etme

**Örnek:**
```
"TAHSİLAT tablosunda, AÇIKLAMA satırının altına 
bir satır daha ekle, adı 'NOTLAR' olsun"
```

**Ben ne yapacağım:**
1. TAHSİLAT tablosunu bulacağım
2. AÇIKLAMA satırını bulacağım
3. Altına yeni satır ekleyeceğim
4. Git commit yapacağım

---

### Yöntem 3: Satır/Sütun Numarası (İleri Seviye)

**Örnek:**
```
"MOTORİN tablosunda, 3. satıra (SATIŞ satırı) 
yeni bir sütun ekle, adı 'YENİ ŞUBE' olsun"
```

**Ben ne yapacağım:**
1. MOTORİN tablosunu bulacağım
2. SATIŞ satırını bulacağım
3. Yeni sütun ekleyeceğim
4. JavaScript'i güncelleyeceğim (gerekirse)
5. Git commit yapacağım

---

## ÖRNEK ANLATIMLAR

### ✅ İYİ ANLATIM (Kolay)
```
"MOTORİN tablosuna yeni bir satır ekle, 
adı 'TOPLAM' olsun, en alta eklensin"
```

### ❌ KÖTÜ ANLATIM (Zor)
```
"Şu tabloda, şuraya, şunu ekle..."
```

---

## BENİM YAPACAĞIM İŞLEMLER (Otomatik)

### Her Değişiklik İsteğinde:

1. **TABLO_YAPILARI.md'yi Oku**
   - Hangi tablo?
   - Nerede? (satır numarası)
   - JavaScript var mı?
   - CSS sınıfları neler?

2. **Mevcut Durumu Kontrol Et**
   - `git status` ile değişiklik var mı?
   - Son commit nedir?

3. **Değişiklik Yap**
   - Sadece gerekli kısmı değiştir
   - JavaScript'i bozmamaya dikkat et
   - CSS sınıflarına dikkat et

4. **Test Et**
   - Tarayıcıda kontrol et
   - Başka bir şey bozuldu mu?

5. **Git Commit Yap**
   - Otomatik commit yapacağım

---

## SİZİN YAPMANIZ GEREKENLER

### Basit Anlatım:
1. **Tablo adını söyleyin:** "MOTORİN", "TAHSİLAT", "ÖDEME"
2. **Ne istediğinizi söyleyin:** "Satır ekle", "Sütun ekle", "Renk değiştir"
3. **Detay verin:** "Adı X olsun", "Y'ye eklensin"

### Örnek:
```
"MOTORİN tablosuna yeni bir satır ekle, 
adı 'TOPLAM' olsun, SATIŞ satırının altına eklensin"
```

---

## ÖZET

### Siz:
- Tablo adı + Ne istediğinizi söyleyin
- Basit ve net olsun

### Ben:
- TABLO_YAPILARI.md'yi okuyacağım
- Mevcut yapıyı kontrol edeceğim
- Değişikliği yapacağım
- Test edeceğim
- Git commit yapacağım

**Artık:**
- ✅ 7 kere anlatmak zorunda kalmayacaksınız
- ✅ Daha kolay anlatabileceksiniz
- ✅ Ben başka şeyleri bozmayacağım (kontrol edeceğim)


