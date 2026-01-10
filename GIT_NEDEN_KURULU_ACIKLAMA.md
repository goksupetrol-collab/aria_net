# GİT NEDEN KURULU? CURSOR NEDEN KULLANMADI?

## SORU 1: GİT NEDEN ZATEN KURULU?

### Olası Nedenler:

#### 1. **Python Kurulumu ile Geldi**
- Python kurarken bazı araçlar otomatik kurulur
- Git bazen Python ile birlikte gelir
- Siz farkında olmadan kurulmuş olabilir

#### 2. **Visual Studio veya Diğer Geliştirici Araçları**
- Visual Studio kurduysanız → Git gelmiş olabilir
- Visual Studio Code kurduysanız → Git gelmiş olabilir
- Diğer programlama araçları Git'i getirebilir

#### 3. **Daha Önce Kurulmuş ama Unutulmuş**
- Belki daha önce bir projede kullanmışsınız
- Veya başka biri kurmuş olabilir
- Unutulmuş olabilir

#### 4. **Windows Geliştirici Paketi**
- Windows'ta geliştirici araçları kurduysanız
- Git otomatik kurulmuş olabilir

---

## SORU 2: GİT KURULUYSA CURSOR NEDEN KULLANMADI?

### ÖNEMLİ FARK:

**Git Kurulu Olması ≠ Git Kullanılıyor**

### Açıklama:

#### 1. **Git Kurulu = Sadece Araç Var**
- Git programı bilgisayarınızda
- Ama projede Git **başlatılmamış**
- `.git` klasörü yok → Git çalışmıyor

#### 2. **Cursor Git'i Otomatik Kullanmaz**
- Cursor sadece bir editör
- Git'i otomatik başlatmaz
- Siz manuel başlatmalısınız

#### 3. **Git'i Başlatmak İçin:**
```bash
git init
```
- Bu komutu çalıştırmak gerekir
- Daha önce çalıştırılmamış olabilir
- Bu yüzden Cursor Git kullanmamış

---

## KARŞILAŞTIRMA:

### Git Kurulu (Şu Anki Durum):
```
✅ Git programı var
❌ Projede Git başlatılmamış
❌ .git klasörü yok
❌ Cursor Git kullanamıyor
```

### Git Başlatılmış (Yapacağımız):
```
✅ Git programı var
✅ Projede Git başlatılmış
✅ .git klasörü var
✅ Cursor Git kullanabilir
```

---

## ÖRNEK:

**Word Programı Analojisi:**
- Word kurulu → Ama belge açmamışsınız
- Word çalışıyor → Ama boş ekran
- Belge açmalısınız → Sonra kullanabilirsiniz

**Git:**
- Git kurulu → Ama projede başlatılmamış
- Git çalışıyor → Ama projede aktif değil
- `git init` yapmalısınız → Sonra kullanabilirsiniz

---

## SONUÇ:

1. **Git neden kurulu?**
   - Python veya başka programlarla gelmiş olabilir
   - Daha önce kurulmuş olabilir

2. **Cursor neden kullanmadı?**
   - Git kurulu ama projede başlatılmamış
   - `.git` klasörü yok
   - `git init` yapılmamış

**Şimdi yapacağımız:**
- `git init` → Git'i projede başlatacağız
- Sonra Cursor Git kullanabilecek!

