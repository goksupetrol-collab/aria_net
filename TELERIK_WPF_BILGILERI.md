# TELERİK WPF DOKÜMANTASYONU - ÖZET

> **Not:** Bu dosya bilgi amaçlıdır. Bizim proje **Kendo UI** (web) kullanıyor, **WPF** (masaüstü) değil. Ama Telerik'in genel yaklaşımını anlamak için yararlı.

## 🎯 WPF NEDİR? (Basit Açıklama)

**WPF = Windows Presentation Foundation**

- 🖥️ **Ne için:** Windows bilgisayarlarda çalışan masaüstü programları yapmak için
- 💻 **Örnekler:** Excel, Word, Photoshop gibi programlar
- 📦 **Kurulum:** Programı bilgisayara kurarsınız, çalıştırırsınız
- 🌐 **Web değil:** İnternet tarayıcısı gerekmez

## 🔄 WPF vs KENDO UI - FARKLAR

| Özellik | WPF (Masaüstü) | Kendo UI (Web - Bizim Proje) |
|---------|----------------|------------------------------|
| **Platform** | Windows masaüstü | Web tarayıcısı |
| **Dil** | C# / VB.NET + XAML | JavaScript + HTML + CSS |
| **Kurulum** | Bilgisayara kurulur | Web sunucusunda çalışır |
| **Erişim** | Programı açarsınız | Tarayıcıdan `http://...` ile erişilir |
| **Bizim Proje** | ❌ Kullanmıyoruz | ✅ Kullanıyoruz |

## 📋 WPF'DEKİ BİLEŞENLER (160+ Adet)

### Data Management (Veri Yönetimi)
- **GridView** → Kendo UI'da: `kendoGrid`
- **ListBox** → Kendo UI'da: `kendoListBox`
- **PivotGrid** → Kendo UI'da: `kendoPivotGrid`
- **TreeListView** → Kendo UI'da: `kendoTreeList`

### Navigation (Navigasyon)
- **Menu** → Kendo UI'da: `kendoMenu` ✅ (Biz kullanıyoruz!)
- **ToolBar** → Kendo UI'da: `kendoToolbar` ✅ (Biz kullanıyoruz!)
- **TabControl** → Kendo UI'da: `kendoTabStrip`
- **TreeView** → Kendo UI'da: `kendoTreeView`

### Editors (Düzenleyiciler)
- **ComboBox** → Kendo UI'da: `kendoComboBox`
- **DatePicker** → Kendo UI'da: `kendoDatePicker`
- **NumericUpDown** → Kendo UI'da: `kendoNumericTextBox`

### Data Visualization (Veri Görselleştirme)
- **ChartView** → Kendo UI'da: `kendoChart`
- **Gauge** → Kendo UI'da: `kendoCircularGauge`
- **Map** → Kendo UI'da: `kendoMap`

## 💡 WPF DOKÜMANTASYONUNDAN ÖĞRENİLECEKLER

### 1. Bileşen İsimleri Benzer
- WPF'deki bileşen isimleri genelde Kendo UI'da da var
- Örnek: WPF'de `Menu`, Kendo UI'da da `Menu`
- **Yararı:** WPF dokümantasyonunda bir özellik görürseniz, Kendo UI'da da olabilir

### 2. Tasarım Mantığı Aynı
- Telerik'in tüm ürünlerinde benzer tasarım yaklaşımı
- Renk paleti, stil sistemi benzer
- **Yararı:** WPF'deki tasarım örneklerini Kendo UI'da uygulayabilirsiniz

### 3. Özellik Karşılaştırması
- WPF'deki bir özellik Kendo UI'da da olabilir
- Örnek: WPF'de `orientation: "horizontal"`, Kendo UI'da da var
- **Yararı:** WPF dokümantasyonundan özellik isimlerini öğrenip Kendo UI'da arayabilirsiniz

### 4. Best Practices (En İyi Uygulamalar)
- Telerik'in önerdiği kullanım şekilleri
- Performans ipuçları
- **Yararı:** WPF'deki best practice'leri Kendo UI'da da uygulayabilirsiniz

## ⚠️ DİKKAT EDİLMESİ GEREKENLER

### ❌ Kopyala-Yapıştır Yapmayın!
- WPF kodu C#/XAML, Kendo UI kodu JavaScript
- Direkt kopyalayamazsınız
- **Doğrusu:** Mantığı anlayıp JavaScript'e çevirin

### ❌ WPF Örneklerini Direkt Kullanmayın!
- WPF: `<telerik:RadMenu>` (XAML)
- Kendo UI: `$("#menu").kendoMenu()` (JavaScript)
- **Doğrusu:** Kendo UI dokümantasyonuna bakın

### ✅ Mantığı Öğrenin!
- WPF'de nasıl yapıldığını görün
- Aynı mantığı Kendo UI'da uygulayın
- **Örnek:** WPF'de `orientation: "horizontal"` varsa, Kendo UI'da da olabilir

## 📚 WPF DOKÜMANTASYONUNDA NELER VAR?

### 1. Bileşen Listesi
- 160+ bileşen listesi
- Her bileşenin açıklaması
- **Yararı:** Hangi bileşenlerin mevcut olduğunu görebilirsiniz

### 2. Özellikler
- Her bileşenin özellikleri
- Kullanım örnekleri
- **Yararı:** Kendo UI'da da benzer özellikler olabilir

### 3. Styling (Stil)
- Tema kullanımı
- Özelleştirme yöntemleri
- **Yararı:** Kendo UI'da da benzer stil yaklaşımları var

### 4. Data Binding (Veri Bağlama)
- Veri kaynağına bağlama
- Filtreleme, sıralama
- **Yararı:** Kendo UI Grid'de de benzer mantık

## 🎯 SONUÇ

**WPF Dokümantasyonu Bize Ne Sağlar?**
1. ✅ Telerik'in genel yaklaşımını anlamak
2. ✅ Bileşen isimlerini öğrenmek
3. ✅ Özellik karşılaştırması yapmak
4. ✅ Tasarım mantığını öğrenmek

**Ama Unutmayın:**
- ❌ Kod örnekleri farklı (C# vs JavaScript)
- ❌ Direkt kopyalayamazsınız
- ✅ Mantığı öğrenip Kendo UI'da uygulayın

**En Önemlisi:**
- 🎯 **Bizim proje için:** Kendo UI dokümantasyonuna bakın
- 📚 **Genel bilgi için:** WPF dokümantasyonunu okuyun
- 🔍 **Karşılaştırma için:** İkisini birlikte inceleyin

---

**Kaynak:** https://www.telerik.com/products/wpf/documentation/introduction
