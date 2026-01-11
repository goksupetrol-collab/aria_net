"""
Fiyat Değişimi MenuItem'ı sıra numarasını 5'e düzelt
"""
import os
import sys
import django

# Proje dizinine git
os.chdir(os.path.dirname(os.path.abspath(__file__)))

# Django ayarlarını yükle
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'aria_net.settings')
django.setup()

from dashboard.models import MenuItem

print("Fiyat Degisimi sira numarasi duzeltiliyor...")

# Fiyat Değişimi'ni bul
fiyat_degisimi = MenuItem.objects.filter(name='fiyat_degisimi').first()

if not fiyat_degisimi:
    print("HATA: Fiyat Degisimi bulunamadi!")
    exit(1)

print(f"Mevcut sira no: {fiyat_degisimi.sira_no}")

# Sıra No 5'te başka bir şey var mı kontrol et
existing5 = MenuItem.objects.filter(sira_no=5).exclude(name='fiyat_degisimi').first()

if existing5:
    print(f"Sira No 5'te baska bir oge var: {existing5.baslik} (sira no: {existing5.sira_no})")
    # O öğenin sıra numarasını fiyat değişiminin eski sıra numarasına taşı
    eski_sira = fiyat_degisimi.sira_no
    existing5.sira_no = eski_sira
    existing5.save()
    print(f"{existing5.baslik} sira no {eski_sira}'a tasindi")

# Fiyat Değişimi'ni sıra no 5'e taşı
fiyat_degisimi.sira_no = 5
fiyat_degisimi.save()

print(f"OK Fiyat Degisimi sira no 5'e tasindi!")

print("\nTum aktif MenuItem kayitlari:")
for item in MenuItem.objects.filter(aktif=True).order_by('sira_no'):
    print(f"  {item.sira_no}. {item.baslik} ({item.name}) - Aktif: {item.aktif}")
