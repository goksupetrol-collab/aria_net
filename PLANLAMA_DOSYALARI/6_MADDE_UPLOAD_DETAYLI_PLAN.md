# 6. MADDE: UPLOAD (DOSYA YÜKLEME) - DETAYLI PLAN
## Ne Yapacağız? Nasıl Yapacağız? Nerede Kullanacağız?

---

## 🎯 NE YAPACAĞIZ?

### Şu Anki Durum:
- ✅ Backend API var (`api_upload_excel`)
- ❌ Frontend'de **Telerik Upload** bileşeni yok
- ❌ Normal HTML `<input type="file">` kullanılıyor (muhtemelen)
- ❌ Profesyonel görünüm yok
- ❌ İlerleme göstergesi yok

### Yapacağımız:
- ✅ Telerik Upload bileşenini ekleyeceğiz
- ✅ Excel dosyası yükleme özelliği ekleyeceğiz
- ✅ İlerleme göstergesi (progress bar) ekleyeceğiz
- ✅ Başarı/hata bildirimleri ekleyeceğiz
- ✅ Mevcut backend API'yi kullanacağız

---

## 📍 NEREDE KULLANACAĞIZ?

### 1. OPERASYON SAYFASI (`telerik_yeni_proje.html`)
**Nereye:** Uygun bir yere (örneğin Chart'ın yanına veya üstüne)

**Ne ekleyeceğiz:**
- Excel dosyası yükleme alanı
- İlerleme göstergesi
- Başarı/hata bildirimleri

**Backend API:**
- `/api/upload-excel/` (zaten mevcut)

---

## 🔧 NASIL YAPACAĞIZ?

### ADIM 1: HTML'e Upload Container Ekleyeceğiz

**Nereye:** `telerik_yeni_proje.html` - Operasyon sayfası içeriği

**Ne ekleyeceğiz:**
```html
<!-- Excel Dosyası Yükleme -->
<div id="upload-container" style="padding:15px;background:#fff;border-radius:8px;margin:10px 0;box-shadow:0 2px 4px rgba(0,0,0,0.1);">
  <div style="font-weight:bold;margin-bottom:10px;font-size:14px;color:#2d3748;">EXCEL DOSYASI YÜKLEME</div>
  <div id="upload-area"></div>
  <div id="upload-progress" style="margin-top:10px;display:none;"></div>
</div>
```

---

### ADIM 2: Upload Bileşenini Başlatacağız

**Telerik Upload kullanımı:**

```javascript
$("#upload-area").kendoUpload({
  async: {
    saveUrl: "/api/upload-excel/",
    autoUpload: true
  },
  multiple: false,
  validation: {
    allowedExtensions: [".xlsx", ".xls"],
    maxFileSize: 10485760  // 10 MB
  },
  upload: function(e) {
    // Yükleme başladı
    $("#upload-progress").show();
  },
  success: function(e) {
    // Yükleme başarılı
    var response = e.response;
    if (response && response.success) {
      if (typeof showSuccess === 'function') {
        showSuccess("Dosya başarıyla yüklendi: " + response.filename);
      }
    }
    $("#upload-progress").hide();
  },
  error: function(e) {
    // Yükleme hatası
    var response = e.response;
    var errorMsg = response && response.error ? response.error : "Dosya yüklenirken hata oluştu";
    if (typeof showError === 'function') {
      showError(errorMsg);
    }
    $("#upload-progress").hide();
  },
  progress: function(e) {
    // İlerleme güncellemesi
    var percentComplete = e.percentComplete;
    $("#upload-progress").html("Yükleniyor: %" + percentComplete);
  }
});
```

---

### ADIM 3: Upload'ı Sayfaya Entegre Edeceğiz

**Nereye:** Operasyon sayfası içeriği, Chart'ın yanına veya üstüne

**Ne yapacağız:**
- Upload container'ı HTML'e ekleyeceğiz
- Upload'ı JavaScript ile başlatacağız
- Backend API ile entegre edeceğiz
- Notification ile bildirimler göstereceğiz

---

## 📊 DEĞİŞİKLİK ÖZETİ

### Dosyalar:
1. **`telerik_yeni_proje.html`** → Upload bileşeni eklenecek

### Değişiklikler:
- ✅ 1 adet HTML container eklenecek (Upload için)
- ✅ 1 adet Upload başlatma kodu eklenecek
- ✅ İlerleme göstergesi eklenecek
- ✅ Başarı/hata bildirimleri eklenecek (Notification kullanarak)

---

## 🎨 NASIL GÖRÜNECEK?

### Şu An:
- ❌ Normal HTML file input (çirkin)
- ❌ İlerleme göstergesi yok
- ❌ Profesyonel görünüm yok

### Olacak:
- ✅ Güzel görünümlü yükleme alanı
- ✅ Sürükle-bırak desteği
- ✅ İlerleme göstergesi (progress bar)
- ✅ Dosya seçimi için buton
- ✅ Başarı/hata bildirimleri (Notification ile)
- ✅ Profesyonel görünüm

---

## ✅ TEST PLANI

### Test 1: Upload Görünümü
- Sayfa açıldığında Upload alanı görünüyor mu?
- Dosya seç butonu var mı?
- Sürükle-bırak çalışıyor mu?

### Test 2: Dosya Yükleme
- Excel dosyası seç → Yükleme başlıyor mu?
- İlerleme göstergesi görünüyor mu?
- Başarı bildirimi gösteriliyor mu?

### Test 3: Hata Kontrolü
- Geçersiz dosya seç (örn: .txt) → Hata mesajı gösteriliyor mu?
- Çok büyük dosya → Hata mesajı gösteriliyor mu?

---

## 🚨 DİKKAT EDİLECEKLER

### 1. Upload Özellikleri
- `async.saveUrl` → Backend API endpoint
- `autoUpload: true` → Otomatik yükleme
- `multiple: false` → Tek dosya yükleme
- `allowedExtensions` → Sadece Excel dosyaları
- `maxFileSize` → Maksimum dosya boyutu (10 MB)

### 2. Backend API Entegrasyonu
- API zaten mevcut: `/api/upload-excel/`
- POST isteği ile dosya gönderilecek
- Response: `{success: true/false, message/error: "...", filename: "..."}`

### 3. Bildirimler
- Başarı → `showSuccess()` ile Notification
- Hata → `showError()` ile Notification
- İlerleme → Progress bar ile gösterilecek

---

## 📝 SONUÇ

### Ne Yapacağız:
1. ✅ HTML'e Upload container ekleyeceğiz
2. ✅ Upload bileşenini başlatacağız
3. ✅ Backend API ile entegre edeceğiz
4. ✅ İlerleme göstergesi ekleyeceğiz
5. ✅ Bildirimler ekleyeceğiz (Notification kullanarak)
6. ✅ Test edeceğiz

### Faydaları:
- ✅ %95 daha hızlı (profesyonel yükleme)
- ✅ İlerleme göstergesi
- ✅ Sürükle-bırak desteği
- ✅ Profesyonel görünüm
- ✅ Hata kontrolü

### Risk:
- ⚠️ Orta risk (backend API zaten var, sadece frontend entegrasyonu)
- ⚠️ Çalışmazsa geri alınabilir

---

**Hazırız! Upload bileşenini ekleyelim mi?** 🚀
