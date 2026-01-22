# Katkıda Bulunma Rehberi (CONTRIBUTING)

Aria Net projesine katkıda bulunmayı düşündüğünüz için teşekkür ederiz! Bu dokümanda, projeye nasıl katkıda bulunabileceğinizi bulabilirsiniz.

## İçindekiler

1. [Davranış Kuralları](#davranış-kuralları)
2. [Nasıl Katkıda Bulunabilirim?](#nasıl-katkıda-bulunabilirim)
3. [Geliştirme Süreci](#geliştirme-süreci)
4. [Kod Standartları](#kod-standartları)
5. [Pull Request Süreci](#pull-request-süreci)

## Davranış Kuralları

Bu projeye katkıda bulunan herkes:

- Saygılı ve yapıcı olmalı
- Farklı bakış açılarını kabul etmeli
- Topluluk üyelerine nazik davranmalı
- Yapıcı eleştiri sunmalı ve kabul etmeli

## Nasıl Katkıda Bulunabilirim?

### Hata Bildirimi

Bir hata buldunuz mu? Lütfen aşağıdaki adımları izleyin:

1. **Mevcut Issue'ları Kontrol Edin**: Aynı hata daha önce rapor edilmiş olabilir
2. **Yeni Issue Açın**: Bulunamadıysa, yeni bir issue açın
3. **Detaylı Açıklama Yapın**: 
   - Hatanın ne olduğunu açıklayın
   - Hatayı nasıl tekrar oluşturabileceğinizi belirtin
   - Beklenen ve gerçek davranışı belirtin
   - Mümkünse ekran görüntüleri ekleyin

### Özellik Önerisi

Yeni bir özellik mi istiyorsunuz?

1. **Issue Açın**: "Feature Request" etiketi ile
2. **Özelliği Açıklayın**: Ne istediğinizi ve neden istediğinizi belirtin
3. **Kullanım Senaryosu**: Özelliğin nasıl kullanılacağını açıklayın

### Dokümantasyon İyileştirmeleri

Dokümantasyonda bir sorun mu buldunuz veya iyileştirme öneriniz mi var?

- Dokümantasyon her zaman geliştirilebilir
- Yazım hataları, belirsiz açıklamalar veya eksik bilgiler için pull request açabilirsiniz
- Yeni örnekler ekleyebilirsiniz

### Kod Katkısı

Kod katkısında bulunmak istiyorsanız:

1. **Issue Kontrol Edin**: Çalışmak istediğiniz bir issue bulun veya yeni bir issue açın
2. **Tartışın**: Büyük değişiklikler için önce tartışın
3. **Kod Yazın**: Değişikliklerinizi yapın
4. **Test Edin**: Değişikliklerinizi test edin
5. **Pull Request Açın**: PR açın ve değişikliklerinizi açıklayın

## Geliştirme Süreci

### 1. Repository'yi Fork Edin

```bash
# GitHub'da "Fork" butonuna tıklayın
# Ardından fork'u klonlayın:
git clone https://github.com/KULLANICI_ADINIZ/aria_net.git
cd aria_net
```

### 2. Upstream'i Ekleyin

```bash
git remote add upstream https://github.com/goksupetrol-collab/aria_net.git
```

### 3. Yeni Branch Oluşturun

```bash
git checkout -b ozellik/aciklayici-isim
# veya
git checkout -b hata/aciklayici-isim
```

Branch isimlendirme:
- `ozellik/aciklama` - Yeni özellikler için
- `hata/aciklama` - Hata düzeltmeleri için
- `dokuman/aciklama` - Dokümantasyon için
- `refactor/aciklama` - Kod iyileştirmeleri için

### 4. Değişikliklerinizi Yapın

```bash
# Dosyaları düzenleyin
# Test edin
# Commit edin
git add .
git commit -m "Açıklayıcı commit mesajı"
```

### 5. Branch'inizi Güncel Tutun

```bash
git fetch upstream
git rebase upstream/main
```

### 6. Push Edin

```bash
git push origin ozellik/aciklayici-isim
```

### 7. Pull Request Açın

- GitHub'da repository'nize gidin
- "New Pull Request" butonuna tıklayın
- Değişikliklerinizi açıklayın
- Gerekli testleri belirtin

## Kod Standartları

### Genel Kurallar

- **Temiz Kod**: Okunabilir ve anlaşılır kod yazın
- **Yorum Satırları**: Gerekli yerlerde Türkçe veya İngilizce açıklayıcı yorumlar ekleyin
- **Tutarlılık**: Mevcut kod stiline uyun
- **Basitlik**: Karmaşık çözümler yerine basit ve anlaşılır çözümler tercih edin

### Commit Mesajları

İyi commit mesajları yazın:

```
Kısa başlık (50 karakter veya daha az)

Daha detaylı açıklama gerekiyorsa, boş bir satırdan sonra ekleyin.
- Yapılan değişiklikleri açıklayın
- Neden bu değişikliği yaptığınızı belirtin
- İlgili issue numaralarını ekleyin (#123)
```

Örnekler:
```
✅ İyi: "FAQ.md dosyasına yeni sorular eklendi"
❌ Kötü: "güncelleme"

✅ İyi: "Hata: README.md'deki bozuk bağlantı düzeltildi (#42)"
❌ Kötü: "düzeltme"
```

### Dokümantasyon

- Markdown formatını kullanın
- Başlıkları mantıklı şekilde organize edin
- Kod örnekleri ekleyin
- Bağlantıların çalıştığından emin olun

## Pull Request Süreci

### PR Hazırlama

1. **Açıklayıcı Başlık**: PR'ın ne yaptığını kısaca açıklayın
2. **Detaylı Açıklama**: 
   - Ne değiştiğini açıklayın
   - Neden bu değişiklik gerekli
   - İlgili issue'ları bağlayın
3. **Checklist**: Tamamlanan görevleri işaretleyin

### PR Şablonu

```markdown
## Açıklama
[Değişikliklerin kısa açıklaması]

## Motivasyon ve Bağlam
[Neden bu değişiklik gerekli?]

## Nasıl Test Edildi?
[Test yöntemini açıklayın]

## Değişiklik Türü
- [ ] Hata düzeltmesi (breaking change olmayan düzeltme)
- [ ] Yeni özellik (breaking change olmayan yeni fonksiyonellik)
- [ ] Breaking change (mevcut fonksiyonelliği bozabilecek değişiklik)
- [ ] Dokümantasyon güncellemesi

## Checklist
- [ ] Kod kendi kendini açıklıyor veya yorum satırları ekledim
- [ ] Dokümantasyonu güncelledim
- [ ] Değişikliklerim uyarı üretmiyor
- [ ] İlgili issue'ları bağladım
```

### Review Süreci

1. PR'ınız gözden geçirilecek
2. Gerekirse değişiklik istekleri olabilir
3. Değişiklikleri yapın ve push edin
4. PR onaylandıktan sonra merge edilecek

### PR Birleştirilmesi

- PR en az bir kişi tarafından onaylanmalı
- Tüm tartışmalar çözülmeli
- CI/CD kontrolleri başarılı olmalı (varsa)

## Sorularınız mı Var?

- Issue açın
- HELP.md dosyasını kontrol edin
- FAQ.md dosyasına bakın

## Teşekkürler!

Katkılarınız için teşekkür ederiz! Her katkı, küçük veya büyük, projeyi iyileştirir.

---

**Not**: Bu rehber zaman içinde güncellenebilir. Değişiklikler için repository'yi takip edin.
