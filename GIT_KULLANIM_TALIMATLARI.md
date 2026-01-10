# GİT KULLANIM TALİMATLARI - BASİT REHBER

## ✅ TAMAMLANAN İŞLEMLER

1. ✅ Git başlatıldı (`git init`)
2. ✅ İlk kayıt yapıldı
3. ✅ Tüm dosyalar kaydedildi

---

## GÜNLÜK KULLANIM

### Senaryo 1: Değişiklik Yaptınız ve Kaydetmek İstiyorsunuz

**Adımlar:**
1. Değişiklik yapın (örnek: `dashboard.html` dosyasını düzenleyin)
2. Cursor'da **Ctrl + S** ile kaydedin
3. PowerShell'de şu komutları çalıştırın:

```bash
cd D:\tayfun
git add dashboard/templates/dashboard/dashboard.html
git commit -m "TAHSİLAT tablosuna yeni özellik eklendi"
```

**Açıklama:**
- `git add` → Değişikliği hazırlar
- `git commit` → Değişikliği kaydeder
- `-m "mesaj"` → Ne değişti? (açıklama)

---

### Senaryo 2: Yanlış Değişiklik Yaptınız, Geri Dönmek İstiyorsunuz

**Adımlar:**
1. Son kaydı görün:
```bash
cd D:\tayfun
git log --oneline
```

2. Geri dönmek istediğiniz kaydı bulun (ilk satır = en son kayıt)

3. Geri dönün:
```bash
git checkout [kayıt-numarası]
```

**Örnek:**
```bash
git checkout 894bc8e
```

4. Güncel hale dönmek için:
```bash
git checkout main
```

---

### Senaryo 3: Dosya Silindi, Geri Getirmek İstiyorsunuz

**Adımlar:**
```bash
cd D:\tayfun
git restore dashboard/templates/dashboard/dashboard.html
```

**Açıklama:**
- `git restore` → Dosyayı son kayıttan geri getirir

---

## ÖNEMLİ KOMUTLAR

### Kayıt Geçmişini Görme
```bash
git log --oneline
```
- Tüm kayıtları listeler
- Her kayıt: Numara + Mesaj

### Değişiklikleri Görme
```bash
git status
```
- Hangi dosyalar değişti?
- Hangi dosyalar kaydedildi?

### Tüm Değişiklikleri Kaydetme
```bash
git add .
git commit -m "Açıklama buraya"
```
- Tüm değişiklikleri kaydeder

---

## ÖRNEK KULLANIM GÜNLÜĞÜ

### Gün 1: İlk Kayıt
```bash
git commit -m "İlk kayıt - Proje başlangıcı"
```

### Gün 2: TAHSİLAT Alt Başlıkları Eklendi
```bash
git add dashboard/templates/dashboard/dashboard.html
git commit -m "TAHSİLAT alt başlıkları eklendi"
```

### Gün 3: Yeni Özellik Eklendi
```bash
git add .
git commit -m "Yeni özellik: ÖDEME tablosu güncellendi"
```

---

## İPUÇLARI

1. **Her Değişiklikten Sonra Commit Yapın**
   - Küçük değişiklikler bile kaydedin
   - Geri dönmek kolay olur

2. **Açıklayıcı Mesajlar Yazın**
   - "Değişiklik" yerine → "TAHSİLAT tablosuna AÇIKLAMA satırı eklendi"
   - Ne değişti? Açık yazın

3. **Düzenli Kayıt Yapın**
   - Her gün sonunda kayıt yapın
   - Her önemli değişiklikte kayıt yapın

---

## SORUN GİDERME

### Sorun: "fatal: not a git repository"
**Çözüm:** `cd D:\tayfun` yapın, sonra tekrar deneyin

### Sorun: "nothing to commit"
**Çözüm:** Değişiklik yok, her şey kayıtlı

### Sorun: Dosya geri gelmedi
**Çözüm:** `git log` ile kayıtları kontrol edin, doğru kayda dönün

---

## ÖZET

**3 Basit Adım:**
1. Değişiklik yap → Kaydet (Ctrl + S)
2. `git add .` → Hazırla
3. `git commit -m "Açıklama"` → Kaydet

**Artık:**
- ✅ Değişiklikler kayıtlı
- ✅ Geri dönebilirsiniz
- ✅ Cursor yedek sorunu çözüldü!


