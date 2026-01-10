# GİT vs CURSOR YEDEK SİSTEMİ - DETAYLI KARŞILAŞTIRMA

## SİZİN YAŞADIĞINIZ SORUN

### Cursor Yedek Sistemi (Sorunlu)
- ❌ Aynı isimde bir sürü yedek oluşturdu
- ❌ Cursor karıştırdı
- ❌ Her seferinde farklı arayüzler açtı
- ❌ Son programa gidemediniz

**Neden oldu?**
- Cursor her yedekte yeni dosya oluşturuyor
- Aynı isimde dosyalar → Karışıklık
- Cursor hangi yedeği açacağını bilemiyor

---

## GİT NASIL ÇALIŞIR?

### 1. NEREYE KAYDEDER?

**Cevap:** `.git` klasörüne (gizli klasör)

**Örnek:**
```
D:\tayfun\
  ├── dashboard.html  (Ana dosya)
  └── .git\          (Gizli klasör - Git buraya kaydeder)
      ├── commits\    (Her değişiklik burada)
      └── objects\    (Dosya içerikleri burada)
```

**Önemli:**
- ✅ Tek bir `.git` klasörü
- ✅ Dosya isimleri değişmez
- ✅ Karışıklık yok

---

### 2. NE KADAR KAYDEDER?

**Cevap:** Sadece değişen kısımları

**Örnek:**
- İlk kayıt: 100 KB (tüm dosya)
- İkinci kayıt: 2 KB (sadece değişen satır)
- Üçüncü kayıt: 1 KB (sadece değişen kelime)

**Avantaj:**
- ✅ Çok az yer kaplar
- ✅ Hızlı
- ✅ Binlerce kayıt yapabilirsiniz

---

### 3. HER SEFERİNDE YENİ DOSYA MI KAYDEDER?

**Cevap:** HAYIR! Tek dosya, sadece geçmişi kaydeder

**Cursor Yedek Sistemi (Sorunlu):**
```
dashboard.html
dashboard.YEDEK-1.html
dashboard.YEDEK-2.html
dashboard.YEDEK-3.html
→ Karışıklık!
```

**Git Sistemi (Doğru):**
```
dashboard.html  (Tek dosya - her zaman güncel)
.git/          (Gizli klasör - geçmiş burada)
→ Karışıklık yok!
```

---

### 4. ÇALIŞMA PRENSİBİ

#### Adım 1: Git Başlatma
```bash
git init
```
- Projeye Git ekler
- `.git` klasörü oluşturur

#### Adım 2: Değişiklik Yapma
- `dashboard.html` dosyasını düzenlersiniz
- Normal çalışma

#### Adım 3: Kaydetme (Commit)
```bash
git add dashboard.html
git commit -m "TAHSİLAT alt başlıkları eklendi"
```
- Değişikliği kaydeder
- Mesaj ekler (ne değişti?)

#### Adım 4: Geçmişe Bakma
```bash
git log
```
- Tüm kayıtları görürsünüz
- Her kayıt: Tarih + Mesaj

#### Adım 5: Geri Dönme
```bash
git checkout [kayıt-numarası]
```
- İstediğiniz kayda dönersiniz
- Sonra tekrar güncel hale dönebilirsiniz

---

### 5. HATALAR ÇIKAR MI?

**Evet, ama çözümü var:**

#### Hata 1: "Commit yapmadım, değişiklik kayboldu"
**Çözüm:** Her değişiklikten sonra `git commit` yapın

#### Hata 2: "Yanlış kayda döndüm"
**Çözüm:** `git checkout main` ile güncel hale dönün

#### Hata 3: "Dosya silindi"
**Çözüm:** `git restore dashboard.html` ile geri getirin

---

## GİT vs CURSOR YEDEK KARŞILAŞTIRMA

| Özellik | Cursor Yedek | Git |
|---------|--------------|-----|
| **Dosya Sayısı** | ❌ Çok fazla | ✅ Tek dosya |
| **İsim Karışıklığı** | ❌ Var | ✅ Yok |
| **Yer Kaplama** | ❌ Çok | ✅ Az |
| **Geri Dönme** | ❌ Zor | ✅ Kolay |
| **Geçmiş Görme** | ❌ Zor | ✅ Kolay |
| **Mesaj Ekleme** | ❌ Yok | ✅ Var |
| **Otomatik** | ⚠️ Bazen | ✅ Manuel (daha güvenli) |

---

## SİZİN SORUNUNUZUN ÇÖZÜMÜ

### Cursor Yedek Sorunu
- ❌ Aynı isimde dosyalar → Karışıklık
- ❌ Cursor hangisini açacağını bilemiyor

### Git Çözümü
- ✅ Tek dosya → Karışıklık yok
- ✅ Git hangi versiyonu açacağını biliyor
- ✅ Her kayıt numaralı → Kolay bulma

---

## ÖRNEK KULLANIM

### Senaryo: TAHSİLAT alt başlıkları ekleme

**Cursor Yedek (Sorunlu):**
1. Yedek al → `dashboard.YEDEK-1.html`
2. Değişiklik yap
3. Yedek al → `dashboard.YEDEK-2.html`
4. Cursor karıştı → Hangi dosyayı açacağını bilemiyor ❌

**Git (Doğru):**
1. `git commit` → Kayıt #1: "İlk hali"
2. Değişiklik yap
3. `git commit` → Kayıt #2: "TAHSİLAT alt başlıkları eklendi"
4. Git biliyor → Her zaman doğru dosyayı açar ✅

---

## SONUÇ

**Git kullanırsanız:**
- ✅ Tek dosya (karışıklık yok)
- ✅ Her kayıt numaralı (kolay bulma)
- ✅ Mesaj ekleyebilirsiniz (ne değişti?)
- ✅ Geri dönme kolay
- ✅ Cursor yedek sorunu çözülür

**Cursor yedek kullanırsanız:**
- ❌ Çok dosya (karışıklık var)
- ❌ Aynı isimler (bulma zor)
- ❌ Cursor karıştırıyor
- ❌ Yaşadığınız sorun devam eder

---

## ÖNERİ

**Git kullanın!** Cursor yedek sisteminden çok daha iyi.

