"""
Fiyat Değişimi MenuItem'ı direkt ekle
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
from django.db.models import Max

print("Fiyat Değişimi MenuItem ekleniyor...")

# Mevcut kayıtları kontrol et
existing_items = MenuItem.objects.filter(aktif=True).order_by('sira_no')
print("\nMevcut menü öğeleri:")
for item in existing_items:
    print(f"  {item.sira_no}. {item.baslik} ({item.name})")

# Sıra No 5'i kontrol et
existing5 = MenuItem.objects.filter(sira_no=5).first()
if existing5:
    print(f"\nUYARI: Sira No 5 zaten var: {existing5.baslik}")
    # Sonraki boş sıra numarasını bul
    max_sira = MenuItem.objects.aggregate(Max('sira_no'))['sira_no__max'] or 0
    sira_no = max_sira + 1
    print(f"Yeni sira no: {sira_no}")
else:
    sira_no = 5

# Fiyat Değişimi'ni ekle veya güncelle
menu, created = MenuItem.objects.get_or_create(
    name='fiyat_degisimi',
    defaults={
        'sira_no': sira_no,
        'baslik': 'Fiyat Değişimi',
        'tab_baslik': 'Fiyat Değişimi',
        'icon': '📈',
        'page_url': '/fiyat-degisimi/',
        'aktif': True
    }
)

if created:
    print(f"\nOK Fiyat Degisimi eklendi! Sira No: {menu.sira_no}")
else:
    print(f"\nOK Fiyat Degisimi zaten var! Sira No: {menu.sira_no}")
    # Güncelle
    menu.sira_no = sira_no
    menu.baslik = 'Fiyat Değişimi'
    menu.tab_baslik = 'Fiyat Değişimi'
    menu.icon = '📈'
    menu.page_url = '/fiyat-degisimi/'
    menu.aktif = True
    menu.save()
    print(f"OK Fiyat Degisimi guncellendi! Sira No: {menu.sira_no}")

print("\nTüm aktif MenuItem kayıtları:")
for item in MenuItem.objects.filter(aktif=True).order_by('sira_no'):
    print(f"  {item.sira_no}. {item.baslik} ({item.name}) - Aktif: {item.aktif}")
