# Yardım Rehberi (HELP)

Bu dokümanda Aria Net projesini kullanırken ihtiyaç duyabileceğiniz yardım bilgilerini bulabilirsiniz.

## İçindekiler

1. [Hızlı Başlangıç](#hızlı-başlangıç)
2. [Dokümantasyon](#dokümantasyon)
3. [Sorun Giderme](#sorun-giderme)
4. [Destek Alma](#destek-alma)
5. [Yararlı Kaynaklar](#yararlı-kaynaklar)

## Hızlı Başlangıç

### İlk Adımlar

1. **Repository'yi Klonlayın**
   ```bash
   git clone https://github.com/goksupetrol-collab/aria_net.git
   cd aria_net
   ```

2. **Dokümantasyonu İnceleyin**
   - README.md - Genel bakış
   - FAQ.md - Sık sorulan sorular
   - HELP.md - Bu dosya
   - CONTRIBUTING.md - Katkıda bulunma rehberi

3. **Projeyi Keşfedin**
   - docs/ klasöründeki ek dokümantasyonu inceleyin
   - İhtiyaçlarınıza göre özelleştirin

## Dokümantasyon

### Mevcut Dokümantasyon

- **README.md**: Projeye genel bakış ve hızlı başlangıç bilgileri
- **FAQ.md**: Sık sorulan sorular ve cevapları
- **CONTRIBUTING.md**: Katkıda bulunma kuralları ve yönergeleri
- **docs/**: Detaylı teknik dokümantasyon

### Dokümantasyon Yapısı

```
aria_net/
├── README.md          # Ana dokümantasyon
├── FAQ.md            # Sık sorulan sorular
├── HELP.md           # Yardım rehberi (bu dosya)
├── CONTRIBUTING.md   # Katkıda bulunma rehberi
└── docs/            # Ek dokümantasyon
    └── getting-started.md
```

## Sorun Giderme

### Yaygın Sorunlar ve Çözümleri

#### Dokümantasyon dosyalarını görüntüleyemiyorum

**Çözüm**: Dokümantasyon Markdown formatındadır. Aşağıdaki yöntemlerle görüntüleyebilirsiniz:
- GitHub web arayüzünde
- VS Code gibi bir editörde
- Herhangi bir Markdown görüntüleyici ile

#### Git işlemleri çalışmıyor

**Çözüm**: 
- Git'in yüklü olduğundan emin olun: `git --version`
- Repository izinlerinizi kontrol edin
- HTTPS veya SSH bağlantısını doğrulayın

#### Değişikliklerim gösterilmiyor

**Çözüm**:
- Değişikliklerinizi commit ettiğinizden emin olun
- Remote repository'ye push yapın
- Branch'inizi kontrol edin

## Destek Alma

### Nasıl Yardım Alabilirim?

1. **Dokümantasyonu Kontrol Edin**
   - İlk olarak mevcut dokümantasyonu inceleyin
   - FAQ.md dosyasında benzer sorunlar olabilir

2. **Issue Açın**
   - GitHub repository'sinde yeni bir issue açın
   - Sorununuzu detaylı açıklayın
   - Gerekirse ekran görüntüleri ekleyin

3. **Topluluk Desteği**
   - Mevcut issue'ları kontrol edin
   - Benzer sorunlar çözülmüş olabilir

### İyi Bir Soru Nasıl Sorulur?

Issue açarken aşağıdakileri dahil edin:

1. **Problem Açıklaması**: Neyi yapmaya çalışıyorsunuz?
2. **Beklenen Davranış**: Ne olmasını bekliyorsunuz?
3. **Gerçek Davranış**: Ne oluyor?
4. **Adımlar**: Sorunu nasıl tekrar oluşturabiliriz?
5. **Ortam**: İşletim sistemi, versiyon bilgileri vs.
6. **Ekran Görüntüleri**: Varsa ekleyin

### Örnek Issue Şablonu

```markdown
## Problem
[Problemi kısaca açıklayın]

## Beklenen Davranış
[Ne olmasını bekliyorsunuz?]

## Gerçek Davranış
[Gerçekte ne oluyor?]

## Tekrar Oluşturma Adımları
1. [İlk adım]
2. [İkinci adım]
3. [Üçüncü adım]

## Ortam
- İşletim Sistemi: [ör. Windows 10, macOS 13, Ubuntu 22.04]
- Git Versiyonu: [git --version çıktısı]

## Ekran Görüntüleri
[Varsa ekleyin]
```

## Yararlı Kaynaklar

### Dahili Kaynaklar

- [README.md](README.md) - Projeye genel bakış
- [FAQ.md](FAQ.md) - Sık sorulan sorular
- [CONTRIBUTING.md](CONTRIBUTING.md) - Katkıda bulunma rehberi
- [docs/](docs/) - Detaylı dokümantasyon

### Harici Kaynaklar

- [Git Dokümantasyonu](https://git-scm.com/doc)
- [GitHub Rehberleri](https://guides.github.com/)
- [Markdown Rehberi](https://www.markdownguide.org/)

## İletişim

Daha fazla yardım için:

- **GitHub Issues**: Teknik sorular ve hata raporları için
- **Repository Owner**: Genel sorular için repository sahibiyle iletişime geçin

## Güncellemeler

Bu yardım dokümanı düzenli olarak güncellenmektedir. Son güncelleme tarihi ve değişiklikler için git log'u kontrol edebilirsiniz.

---

**Not**: Bu dokümanda bulamadığınız bir konuda yardıma mı ihtiyacınız var? Lütfen bir issue açın, böylece bu dokümanı geliştirebiliriz!
