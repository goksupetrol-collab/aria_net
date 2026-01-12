# 5. MADDE: CHART (GRAFİKLER) - DETAYLI PLAN
## Ne Yapacağız? Nasıl Yapacağız? Nerede Kullanacağız?

---

## 🎯 NE YAPACAĞIZ?

### Şu Anki Durum:
- ❌ Satış verileri sadece **tablo** ile gösteriliyor
- ❌ Görsel grafik yok
- ❌ Karşılaştırma zor
- ❌ İstatistik görselleştirme yok

### Yapacağımız:
- ✅ Telerik Chart bileşenini ekleyeceğiz
- ✅ Şube bazlı satış grafiği ekleyeceğiz
- ✅ Çubuk grafik ile görselleştirme yapacağız
- ✅ Renkli ve profesyonel görünüm

---

## 📍 NEREDE KULLANACAĞIZ?

### 1. OPERASYON SAYFASI (`telerik_yeni_proje.html`)
**Nereye:** Sağ üstte veya ayrı bir panelde

**Ne ekleyeceğiz:**
- Şube bazlı satış grafiği (Çubuk grafik)
- Motorin ve Benzin satışlarını karşılaştırma

**Veri kaynağı:**
- Şube listesi: ["YAĞCILAR", "TEPEKUM", "NAMDAR", "ŞEKER", "AKOVA", "KOOP.", "NAZİLLİ"]
- Örnek satış verileri (şu an için statik, ileride Grid'den alınabilir)

---

## 🔧 NASIL YAPACAĞIZ?

### ADIM 1: HTML'e Chart Container Ekleyeceğiz

**Nereye:** `telerik_yeni_proje.html` - Operasyon sayfası içeriği

**Ne ekleyeceğiz:**
```html
<!-- Şube Bazlı Satış Grafiği -->
<div id="satis-grafik-container" style="padding:10px;background:#fff;border-radius:8px;margin:10px 0;">
  <div style="font-weight:bold;margin-bottom:10px;font-size:14px;">ŞUBE BAZLI SATIŞ GRAFİĞİ</div>
  <div id="satis-grafik" style="height:300px;"></div>
</div>
```

---

### ADIM 2: Chart Bileşenini Başlatacağız

**Telerik Chart kullanımı:**

```javascript
$("#satis-grafik").kendoChart({
  dataSource: {
    data: [
      { sube: "YAĞCILAR", motorin: 100000, benzin: 50000 },
      { sube: "TEPEKUM", motorin: 100000, benzin: 45000 },
      { sube: "NAMDAR", motorin: 29000, benzin: 25000 },
      { sube: "ŞEKER", motorin: 60000, benzin: 40000 },
      { sube: "AKOVA", motorin: 50000, benzin: 35000 },
      { sube: "KOOP.", motorin: 60000, benzin: 30000 },
      { sube: "NAZİLLİ", motorin: 70000, benzin: 40000 }
    ]
  },
  title: {
    text: "Şube Bazlı Satış Karşılaştırması"
  },
  legend: {
    position: "top"
  },
  seriesDefaults: {
    type: "column"
  },
  series: [{
    name: "Motorin",
    field: "motorin",
    color: "#4CAF50"
  }, {
    name: "Benzin",
    field: "benzin",
    color: "#2196F3"
  }],
  categoryAxis: {
    field: "sube",
    labels: {
      rotation: -45
    }
  },
  valueAxis: {
    labels: {
      format: "N0"
    },
    title: {
      text: "Satış (Litre)"
    }
  },
  tooltip: {
    visible: true,
    format: "{0}",
    template: "#= series.name #: #= value # Litre"
  }
});
```

---

### ADIM 3: Chart'ı Sayfaya Entegre Edeceğiz

**Nereye:** Operasyon sayfası içeriği, sağ üstte veya ayrı bir bölümde

**Ne yapacağız:**
- Chart container'ı HTML'e ekleyeceğiz
- Chart'ı JavaScript ile başlatacağız
- Sayfa yüklendiğinde grafik görünecek

---

## 📊 DEĞİŞİKLİK ÖZETİ

### Dosyalar:
1. **`telerik_yeni_proje.html`** → Chart bileşeni eklenecek

### Değişiklikler:
- ✅ 1 adet HTML container eklenecek (Chart için)
- ✅ 1 adet Chart başlatma kodu eklenecek
- ✅ Şube bazlı satış grafiği görünecek

---

## 🎨 NASIL GÖRÜNECEK?

### Şu An:
- ❌ Sadece tablo var
- ❌ Görsel yok
- ❌ Karşılaştırma zor

### Olacak:
- ✅ Renkli çubuk grafik görünecek
- ✅ Motorin ve Benzin satışları yan yana karşılaştırılacak
- ✅ Şube bazlı görselleştirme
- ✅ Tooltip ile detaylı bilgi
- ✅ Profesyonel görünüm

---

## ✅ TEST PLANI

### Test 1: Chart Görünümü
- Sayfa açıldığında Chart görünüyor mu?
- Çubuk grafik doğru çiziliyor mu?
- Renkler doğru mu? (Motorin: Yeşil, Benzin: Mavi)

### Test 2: Veri Gösterimi
- Şube isimleri görünüyor mu?
- Satış değerleri doğru mu?
- Tooltip çalışıyor mu? (Fareyi çubuğun üzerine getirince)

### Test 3: Responsive
- Chart sayfaya uyumlu mu?
- Boyutlandırma doğru mu?

---

## 🚨 DİKKAT EDİLECEKLER

### 1. Chart Özellikleri
- `type: "column"` → Çubuk grafik
- `series` → Birden fazla seri (Motorin, Benzin)
- `categoryAxis` → X ekseni (Şube isimleri)
- `valueAxis` → Y ekseni (Satış değerleri)
- `tooltip` → Detaylı bilgi gösterimi

### 2. Veri Formatı
- Veriler array içinde object formatında olmalı
- Her object bir kategoriyi temsil eder (şube)
- Her object'te seri alanları olmalı (motorin, benzin)

### 3. Konumlandırma
- Chart container'ı sayfanın uygun bir yerine yerleştirilecek
- Responsive olmalı (farklı ekran boyutlarına uyumlu)

---

## 📝 SONUÇ

### Ne Yapacağız:
1. ✅ HTML'e Chart container ekleyeceğiz
2. ✅ Chart bileşenini başlatacağız
3. ✅ Şube bazlı satış grafiği göstereceğiz
4. ✅ Test edeceğiz

### Faydaları:
- ✅ %80 daha anlaşılır (görsel grafik)
- ✅ Karşılaştırma kolaylaşır
- ✅ Profesyonel görünüm
- ✅ İstatistik görselleştirme

### Risk:
- ⚠️ Düşük risk (sadece görsel ekleniyor, mevcut işlevselliği etkilemez)
- ⚠️ Çalışmazsa geri alınabilir

---

**Hazırız! Chart bileşenini ekleyelim mi?** 🚀
