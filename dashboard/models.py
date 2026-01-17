from django.db import models
from django.core.validators import MinValueValidator


# Şube seçenekleri
SUBE_CHOICES = [
    ('YAGCILAR', 'YAĞCILAR'),
    ('TEPEKUM', 'TEPEKUM'),
    ('NAMDAR', 'NAMDAR'),
    ('SEKER', 'ŞEKER'),
    ('AKOVA', 'AKOVA'),
    ('KOOP', 'KOOP.'),
    ('NAZILLI', 'NAZİLLİ'),
]

# Ürün seçenekleri
URUN_CHOICES = [
    ('MOTORIN', 'MOTORİN'),
    ('BENZIN', 'BENZİN'),
]

# Ödeme türü seçenekleri
ODEME_TURU_CHOICES = [
    ('DBS', 'DBS'),
    ('NAKIT', 'NAKİT'),
    ('KK', 'K.K'),
]


class MotorinSatis(models.Model):
    """MOTORİN günlük satış değerleri"""
    tarih = models.DateField(verbose_name="Tarih")
    sube = models.CharField(max_length=20, choices=SUBE_CHOICES, verbose_name="Şube")
    deger = models.DecimalField(
        max_digits=15, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="Satış Değeri"
    )
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")

    class Meta:
        verbose_name = "Motorin Satış"
        verbose_name_plural = "Motorin Satışları"
        unique_together = [['tarih', 'sube']]  # Aynı tarih ve şube için tek kayıt
        ordering = ['-tarih', 'sube']

    def __str__(self):
        return f"{self.tarih} - {self.get_sube_display()} - {self.deger}"


class BenzinSatis(models.Model):
    """BENZİN günlük satış değerleri"""
    tarih = models.DateField(verbose_name="Tarih")
    sube = models.CharField(max_length=20, choices=SUBE_CHOICES, verbose_name="Şube")
    deger = models.DecimalField(
        max_digits=15, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="Satış Değeri"
    )
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")

    class Meta:
        verbose_name = "Benzin Satış"
        verbose_name_plural = "Benzin Satışları"
        unique_together = [['tarih', 'sube']]  # Aynı tarih ve şube için tek kayıt
        ordering = ['-tarih', 'sube']

    def __str__(self):
        return f"{self.tarih} - {self.get_sube_display()} - {self.deger}"


class Tahsilat(models.Model):
    """TAHSİLAT işlemleri (30 satır)"""
    sira_no = models.IntegerField(verbose_name="Sıra No", unique=True)  # 1-30
    kime = models.CharField(max_length=200, blank=True, null=True, verbose_name="Kime Ödeme Yapılacak")
    ne_kadar = models.DecimalField(
        max_digits=15, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="Ne Kadar"
    )
    onay = models.BooleanField(default=False, verbose_name="Onay")
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")

    class Meta:
        verbose_name = "Tahsilat"
        verbose_name_plural = "Tahsilatlar"
        ordering = ['sira_no']

    def __str__(self):
        return f"Tahsilat #{self.sira_no} - {self.kime or 'Boş'} - {self.ne_kadar}"


class Odeme(models.Model):
    """ÖDEME işlemleri (30 satır)"""
    sira_no = models.IntegerField(verbose_name="Sıra No", unique=True)  # 1-30
    kime = models.CharField(max_length=200, blank=True, null=True, verbose_name="Kime Ödeme Yapılacak")
    ne_kadar = models.DecimalField(
        max_digits=15, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="Ne Kadar"
    )
    onay = models.BooleanField(default=False, verbose_name="Onay")
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")

    class Meta:
        verbose_name = "Ödeme"
        verbose_name_plural = "Ödemeler"
        ordering = ['sira_no']

    def __str__(self):
        return f"Ödeme #{self.sira_no} - {self.kime or 'Boş'} - {self.ne_kadar}"


class Entry(models.Model):
    """ENTRY/Sipariş hazırlama (30 sipariş)"""
    sira_no = models.IntegerField(verbose_name="Sıra No", unique=True)  # 1-30
    firma = models.CharField(max_length=20, choices=SUBE_CHOICES, verbose_name="Firma/Şube")
    urun = models.CharField(max_length=20, choices=URUN_CHOICES, verbose_name="Ürün")
    litre = models.DecimalField(
        max_digits=15, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="Litre"
    )
    tl = models.DecimalField(
        max_digits=15, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="TL (Litre × Alış Fiyatı)"
    )
    odeme_turu = models.CharField(
        max_length=10, 
        choices=ODEME_TURU_CHOICES, 
        blank=True, 
        null=True,
        verbose_name="Ödeme Türü"
    )
    bos_alan = models.CharField(max_length=200, blank=True, null=True, verbose_name="Boş Alan (Sonra Doldurulacak)")
    onay = models.BooleanField(default=False, verbose_name="Onay/Ekle")
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")

    class Meta:
        verbose_name = "Sipariş"
        verbose_name_plural = "Siparişler"
        ordering = ['sira_no']

    def __str__(self):
        return f"Sipariş #{self.sira_no} - {self.get_firma_display()} - {self.get_urun_display()} - {self.litre}L"


class AlisFiyati(models.Model):
    """Alış Fiyatı Tablosu (Şube + Ürün bazında sabit fiyat)"""
    sube = models.CharField(max_length=20, choices=SUBE_CHOICES, verbose_name="Şube")
    urun = models.CharField(max_length=20, choices=URUN_CHOICES, verbose_name="Ürün")
    fiyat = models.DecimalField(
        max_digits=15, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="Alış Fiyatı (TL)"
    )
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")

    class Meta:
        verbose_name = "Alış Fiyatı"
        verbose_name_plural = "Alış Fiyatları"
        unique_together = [['sube', 'urun']]  # Aynı şube ve ürün için tek kayıt
        ordering = ['sube', 'urun']

    def __str__(self):
        return f"{self.get_sube_display()} - {self.get_urun_display()} - {self.fiyat} TL"


class Tanker(models.Model):
    """TANKER bilgileri (20 tanker)"""
    sira_no = models.IntegerField(verbose_name="Sıra No", unique=True)  # 1-20
    tanker_adi = models.CharField(max_length=100, verbose_name="Tanker Adı/Soyadı")
    cekici_plaka = models.CharField(max_length=20, blank=True, null=True, verbose_name="Çekici Plaka")
    dorse_plaka = models.CharField(max_length=20, blank=True, null=True, verbose_name="Dorse Plaka")
    goz_1 = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="1. Göz Kapasitesi (Litre)"
    )
    goz_2 = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="2. Göz Kapasitesi (Litre)"
    )
    goz_3 = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="3. Göz Kapasitesi (Litre)"
    )
    goz_4 = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="4. Göz Kapasitesi (Litre)"
    )
    goz_5 = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="5. Göz Kapasitesi (Litre)"
    )
    toplam_goz_kapasitesi = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="Toplam Göz Kapasitesi (Litre)"
    )
    toplam_tasima_kapasitesi = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="Toplam Taşıma Kapasitesi (Litre)"
    )
    aktif = models.BooleanField(default=False, verbose_name="Aktif (Bugün Kullanılacak)")
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")

    class Meta:
        verbose_name = "Tanker"
        verbose_name_plural = "Tankerler"
        ordering = ['sira_no']

    def __str__(self):
        return f"Tanker #{self.sira_no} - {self.tanker_adi}"


class AracBilgi(models.Model):
    """ARAÇ BİLGİ kartları (20 araç)"""
    sira_no = models.IntegerField(verbose_name="Sıra No", unique=True)  # 1-20
    firma = models.CharField(max_length=200, blank=True, null=True, verbose_name="Firma")
    sofor = models.CharField(max_length=200, blank=True, null=True, verbose_name="Şoför")
    tc = models.CharField(max_length=11, blank=True, null=True, verbose_name="T.C")
    dorse = models.CharField(max_length=50, blank=True, null=True, verbose_name="Dorse")
    cekici = models.CharField(max_length=50, blank=True, null=True, verbose_name="Çekici")
    goz_1 = models.CharField(max_length=50, blank=True, null=True, verbose_name="1. Göz")
    goz_2 = models.CharField(max_length=50, blank=True, null=True, verbose_name="2. Göz")
    goz_3 = models.CharField(max_length=50, blank=True, null=True, verbose_name="3. Göz")
    goz_4 = models.CharField(max_length=50, blank=True, null=True, verbose_name="4. Göz")
    goz_5 = models.CharField(max_length=50, blank=True, null=True, verbose_name="5. Göz")
    goz_6 = models.CharField(max_length=50, blank=True, null=True, verbose_name="6. Göz")
    toplam_litre = models.CharField(max_length=50, blank=True, null=True, verbose_name="Toplam Litre")
    tasima_siniri_lt = models.CharField(max_length=50, blank=True, null=True, verbose_name="Taşıma Sınırı Lt")
    aktif = models.BooleanField(default=False, verbose_name="Aktif")
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")

    class Meta:
        verbose_name = "Araç Bilgi"
        verbose_name_plural = "Araç Bilgileri"
        ordering = ['sira_no']

    def __str__(self):
        return f"Araç #{self.sira_no} - {self.firma or 'Boş'}"


class Hypco(models.Model):
    """HYPCO limit bilgileri"""
    SUTUN_CHOICES = [
        ('A', 'A'),
        ('B', 'B'),
        ('C', 'C'),
    ]
    satir_no = models.IntegerField(verbose_name="Satır No")
    sutun = models.CharField(max_length=1, choices=SUTUN_CHOICES, verbose_name="Sütun")
    deger = models.CharField(max_length=200, blank=True, null=True, verbose_name="Değer")
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")

    class Meta:
        verbose_name = "HYPCO"
        verbose_name_plural = "HYPCO"
        ordering = ['satir_no', 'sutun']
        unique_together = [['satir_no', 'sutun']]

    def __str__(self):
        return f"HYPCO - Satır {self.satir_no} - Sütun {self.sutun} - {self.deger or 'Boş'}"


class Aygaz(models.Model):
    """AYGAZ limit bilgileri"""
    SUTUN_CHOICES = [
        ('A', 'A'),
        ('B', 'B'),
        ('C', 'C'),
    ]
    satir_no = models.IntegerField(verbose_name="Satır No")
    sutun = models.CharField(max_length=1, choices=SUTUN_CHOICES, verbose_name="Sütun")
    deger = models.CharField(max_length=200, blank=True, null=True, verbose_name="Değer")
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")

    class Meta:
        verbose_name = "AYGAZ"
        verbose_name_plural = "AYGAZ"
        ordering = ['satir_no', 'sutun']
        unique_together = [['satir_no', 'sutun']]

    def __str__(self):
        return f"AYGAZ - Satır {self.satir_no} - Sütun {self.sutun} - {self.deger or 'Boş'}"


class Firma(models.Model):
    """Firma/Şube tanımları - PetroNet'ten alındı"""
    sira_no = models.IntegerField(verbose_name="Sıra No", unique=True)
    ad = models.CharField(max_length=100, verbose_name="Firma Adı")
    sube = models.CharField(max_length=100, verbose_name="Şube", blank=True, default="")
    vergi_no = models.CharField(max_length=20, blank=True, default="", verbose_name="Vergi No")
    vergi_dairesi = models.CharField(max_length=100, blank=True, default="", verbose_name="Vergi Dairesi")
    adres = models.CharField(max_length=255, blank=True, default="", verbose_name="Adres")
    telefon = models.CharField(max_length=30, blank=True, default="", verbose_name="Telefon")
    eposta = models.EmailField(blank=True, default="", verbose_name="E-posta")
    yetkili_kisi = models.CharField(max_length=100, blank=True, default="", verbose_name="Yetkili Kişi")
    aktif = models.BooleanField(default=True, verbose_name="Aktif")
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")

    class Meta:
        verbose_name = "Firma"
        verbose_name_plural = "Firmalar"
        ordering = ['sira_no']

    def __str__(self):
        return f"{self.sira_no} - {self.ad}"


class EvrakTuru(models.Model):
    """Şube evrak türleri"""
    ad = models.CharField(max_length=100, verbose_name="Evrak Türü")
    aktif = models.BooleanField(default=True, verbose_name="Aktif")
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")

    class Meta:
        verbose_name = "Evrak Türü"
        verbose_name_plural = "Evrak Türleri"
        ordering = ["ad"]

    def __str__(self):
        return self.ad


class FirmaEvrak(models.Model):
    """Firma/Şube evrakları"""
    firma = models.ForeignKey(Firma, on_delete=models.CASCADE, related_name="evraklar", verbose_name="Firma")
    evrak_turu = models.ForeignKey(EvrakTuru, on_delete=models.PROTECT, related_name="evraklar", verbose_name="Evrak Türü")
    dosya = models.FileField(upload_to="firma_evraklari/", verbose_name="Dosya")
    aciklama = models.CharField(max_length=200, blank=True, default="", verbose_name="Açıklama")
    bitis_tarihi = models.DateField(null=True, blank=True, verbose_name="Bitiş Tarihi")
    uyari_gunu = models.IntegerField(default=7, verbose_name="Uyarı Günü")
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")

    class Meta:
        verbose_name = "Firma Evrakı"
        verbose_name_plural = "Firma Evrakları"
        ordering = ["-olusturma_tarihi"]

    def __str__(self):
        return f"{self.firma.ad} - {self.evrak_turu.ad}"


class MenuItem(models.Model):
    """Ribbon menü öğeleri - PetroNet gibi veritabanında saklanıyor"""
    sira_no = models.IntegerField(verbose_name="Sıra No", unique=True)
    name = models.CharField(max_length=100, verbose_name="Menü Adı (Kod)", unique=True)
    baslik = models.CharField(max_length=100, verbose_name="Başlık (Türkçe)")
    tab_baslik = models.CharField(max_length=100, verbose_name="Tab Başlığı", blank=True, null=True, help_text="Tab'da görünecek başlık (boşsa baslik kullanılır)")
    icon = models.CharField(max_length=10, verbose_name="İkon (Emoji)", default="⛽")
    page_url = models.CharField(max_length=200, verbose_name="Sayfa URL", blank=True, null=True)
    aktif = models.BooleanField(default=True, verbose_name="Aktif")
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")
    
    class Meta:
        verbose_name = "Menü Öğesi"
        verbose_name_plural = "Menü Öğeleri"
        ordering = ['sira_no']
    
    def __str__(self):
        return f"{self.sira_no} - {self.baslik}"
    
    def get_tab_baslik(self):
        """Tab başlığını döndür (tab_baslik varsa onu, yoksa baslik)"""
        return self.tab_baslik if self.tab_baslik else self.baslik


class Urun(models.Model):
    """Ürün tanımları - MOTORİN, BENZİN vb."""
    sira_no = models.IntegerField(verbose_name="Sıra No", unique=True)
    ad = models.CharField(max_length=100, verbose_name="Ürün Adı")
    aktif = models.BooleanField(default=True, verbose_name="Aktif")
    olusturma_tarihi = models.DateTimeField(auto_now_add=True, verbose_name="Oluşturma Tarihi")
    guncelleme_tarihi = models.DateTimeField(auto_now=True, verbose_name="Güncelleme Tarihi")

    class Meta:
        verbose_name = "Ürün"
        verbose_name_plural = "Ürünler"
        ordering = ['sira_no']

    def __str__(self):
        return f"{self.sira_no} - {self.ad}"
