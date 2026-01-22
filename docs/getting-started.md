# Başlangıç Rehberi

Aria Net projesine hoş geldiniz! Bu rehber, projeyi kullanmaya başlamanız için gereken tüm bilgileri içerir.

## İçindekiler

1. [Gereksinimler](#gereksinimler)
2. [Kurulum](#kurulum)
3. [İlk Adımlar](#ilk-adımlar)
4. [Temel Kullanım](#temel-kullanım)
5. [İleri Seviye Konular](#ileri-seviye-konular)
6. [Sorun Giderme](#sorun-giderme)

## Gereksinimler

Bu projeyi kullanmak için:

- Git yüklü olmalı
- Bir metin editörü (VS Code, Sublime Text, vb.)
- İnternet bağlantısı (repository klonlamak için)

### Önerilen Araçlar

- **Git**: Versiyon kontrolü için
- **VS Code**: Markdown dosyalarını düzenlemek için
- **GitHub Desktop**: Git işlemlerini görsel olarak yönetmek için (opsiyonel)

## Kurulum

### 1. Repository'yi Klonlayın

HTTPS ile:
```bash
git clone https://github.com/goksupetrol-collab/aria_net.git
cd aria_net
```

SSH ile (SSH key'iniz varsa):
```bash
git clone git@github.com:goksupetrol-collab/aria_net.git
cd aria_net
```

### 2. Projeyi Keşfedin

Repository'yi klonladıktan sonra, dosya yapısını inceleyin:

```
aria_net/
├── README.md          # Ana dokümantasyon
├── FAQ.md            # Sık sorulan sorular
├── HELP.md           # Yardım rehberi
├── CONTRIBUTING.md   # Katkıda bulunma rehberi
└── docs/            # Ek dokümantasyon
    └── getting-started.md  # Bu dosya
```

## İlk Adımlar

### Adım 1: README'yi Okuyun

İlk olarak [README.md](../README.md) dosyasını okuyun. Bu dosya projeye genel bir bakış sağlar.

### Adım 2: FAQ'yi İnceleyin

[FAQ.md](../FAQ.md) dosyasında sık sorulan sorulara ve cevaplarına göz atın.

### Adım 3: Dokümantasyonu Gözden Geçirin

Tüm dokümantasyon dosyalarını okuyun:
- HELP.md - Detaylı yardım bilgileri
- CONTRIBUTING.md - Katkıda bulunma rehberi

## Temel Kullanım

### Dokümantasyon Okuma

Tüm dokümantasyon Markdown (.md) formatındadır. Bu dosyaları şu şekillerde okuyabilirsiniz:

1. **GitHub Web Arayüzü**: Doğrudan GitHub'da görüntüleyin
2. **VS Code**: Markdown Preview ile (Ctrl+Shift+V veya Cmd+Shift+V)
3. **Markdown Viewer**: Tarayıcı eklentileri veya özel uygulamalar

### Repository'yi Güncel Tutma

Repository'deki güncellemeleri almak için:

```bash
git pull origin main
```

### Katkıda Bulunma

Projeye katkıda bulunmak istiyorsanız:

1. Repository'yi fork edin
2. Yeni bir branch oluşturun
3. Değişikliklerinizi yapın
4. Pull request açın

Detaylı bilgi için [CONTRIBUTING.md](../CONTRIBUTING.md) dosyasını okuyun.

## İleri Seviye Konular

### Özel Branch'lerle Çalışma

Belirli bir özellik veya düzeltme üzerinde çalışıyorsanız:

```bash
# Yeni branch oluştur
git checkout -b ozellik/yeni-ozellik

# Değişiklikleri commit et
git add .
git commit -m "Yeni özellik eklendi"

# Remote'a push et
git push origin ozellik/yeni-ozellik
```

### Multiple Remote'larla Çalışma

Orijinal repository ve fork'unuzla çalışırken:

```bash
# Upstream ekle
git remote add upstream https://github.com/goksupetrol-collab/aria_net.git

# Upstream'den güncellemeleri çek
git fetch upstream

# Ana branch'i güncelle
git checkout main
git merge upstream/main
```

### Git Hook'ları

Commit öncesi otomatik kontroller için Git hook'ları kullanabilirsiniz (gelecekte eklenebilir).

## Sorun Giderme

### Yaygın Sorunlar

#### "Permission denied" hatası

**Sorun**: Git işlemleri sırasında yetki hatası

**Çözüm**: 
- SSH key'inizin doğru yapılandırıldığından emin olun
- Veya HTTPS kullanarak klonlayın
- GitHub kimlik bilgilerinizi kontrol edin

#### "Merge conflict" hatası

**Sorun**: Birleştirme çakışmaları

**Çözüm**:
```bash
# Çakışan dosyaları düzenle
# Çakışmaları çöz
git add .
git commit -m "Merge conflict çözüldü"
```

#### Güncel olmayan local repository

**Sorun**: Local kopyanız güncel değil

**Çözüm**:
```bash
git fetch origin
git pull origin main
```

### Daha Fazla Yardım

Sorunlarınız devam ediyorsa:

1. [HELP.md](../HELP.md) dosyasını kontrol edin
2. [FAQ.md](../FAQ.md) dosyasına bakın
3. GitHub'da issue açın
4. Topluluk desteği alın

## Faydalı Komutlar

### Git Komutları

```bash
# Durum kontrolü
git status

# Değişiklikleri görüntüle
git diff

# Commit geçmişi
git log --oneline

# Branch listesi
git branch -a

# Remote'ları listele
git remote -v
```

### Markdown Önizleme

VS Code'da:
- `Ctrl+Shift+V` (Windows/Linux)
- `Cmd+Shift+V` (macOS)

## Sonraki Adımlar

Artık başlangıç seviyesinde bilgi sahibisiniz! Şimdi:

1. **Projeyi Keşfedin**: Tüm dosyaları inceleyin
2. **Katkıda Bulunun**: Katkıda bulunmak istiyorsanız CONTRIBUTING.md'yi okuyun
3. **Güncel Kalın**: Repository'yi star'layın ve güncellemeleri takip edin
4. **Geri Bildirim Verin**: Önerilerinizi veya sorunlarınızı paylaşın

## Kaynaklar

### Dahili Kaynaklar

- [README.md](../README.md)
- [FAQ.md](../FAQ.md)
- [HELP.md](../HELP.md)
- [CONTRIBUTING.md](../CONTRIBUTING.md)

### Harici Kaynaklar

- [Git Resmi Dokümantasyonu](https://git-scm.com/doc)
- [GitHub Guides](https://guides.github.com/)
- [Markdown Guide](https://www.markdownguide.org/)
- [Pro Git Book (Türkçe)](https://git-scm.com/book/tr/v2)

## Geri Bildirim

Bu rehberi geliştirmemize yardımcı olun! Eksik veya yanlış bilgi gördüyseniz:

- Issue açın
- Pull request gönderin
- Repository sahibiyle iletişime geçin

---

**İyi şanslar ve mutlu kodlamalar!** 🚀
